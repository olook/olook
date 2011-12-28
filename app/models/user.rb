# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessor :require_cpf
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :cpf
  attr_protected :invite_token

  has_many :points, :dependent => :destroy
  has_one :survey_answer, :dependent => :destroy
  has_many :invites, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :addresses
  has_many :orders
  has_many :payments, :through => :orders

  before_create :generate_invite_token

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  InviteTokenFormat = /\b[a-zA-Z0-9]{8}\b/
  NameFormat = /^[A-ZÀ-ÿ\s-]+$/i

  validates :email, :format => {:with => EmailFormat}
  validates :first_name, :presence => true, :format => { :with => NameFormat }
  validates :last_name, :presence => true, :format => { :with => NameFormat }
  validates_with CpfValidator, :if => :is_invited
  validates_with CpfValidator, :if => :require_cpf

  def name
    "#{first_name} #{last_name}".strip
  end

  def survey_answers
    survey_answer.try(:answers)
  end

  def self.find_for_facebook_oauth(access_token)
    data = access_token['extra']['user_hash']
    t = User.arel_table
    user = User.where(t[:uid].eq(data["id"]).and(t[:uid].not_eq(nil)))
    user.first
  end

  def invite_token=(token)
    raise 'Invite token is read only'
  end

  def invite_for(email_address)
    the_invite = invites.find_by_email(email_address)|| invites.build(:email => email_address)
    the_invite.save ? the_invite : nil
  end

  def invites_for(email_addresses, limit = Invite::LIMIT)
    email_addresses[0..limit].map do |email_address|
      invite_for email_address
    end.compact
  end

  def accept_invitation_with_token(token)
    inviting_member = User.find_by_invite_token(token)
    raise 'Invalid token' unless inviting_member

    accepted_invite = inviting_member.invite_for(email)
    if accepted_invite.nil?
      accepted_invite = inviting_member.invites.create(:email => email, :sent_at => Time.now)
    end
    accepted_invite.accept_invitation(self)
  end

  def has_facebook?
    self.uid.present?
  end

  def invite_bonus
    InviteBonus.calculate(self)
  end

  def used_invite_bonus
    InviteBonus.already_used(self)
  end

  def profile_scores
    self.points.includes(:profile).order('value DESC')
  end

  def main_profile
    self.profile_scores.first.try(:profile)
  end

  def profile_name
    main_profile.first_visit_banner.to_sym if main_profile
  end

  def first_visit?
    self.events.where(:event_type => EventType::FIRST_VISIT).empty?
  end

  def has_early_access?
    true # temporary fix. Should become 1 hour delay
  end

  def record_first_visit
    add_event(EventType::FIRST_VISIT) if first_visit?
  end

  def record_early_access
    add_event(EventType::EARLY_ACCESS) unless has_early_access?
  end

  def add_event(type, description = '')
    self.events.create(event_type: type, description: description)
  end

  def invitation_url(host = 'www.olook.com.br')
    Rails.application.routes.url_helpers.accept_invitation_url self.invite_token, :host => host
  end

  def all_profiles_showroom(category = nil)
    result = []
    self.profile_scores.each do |profile_score|
      result = result | profile_showroom(profile_score.profile, category).all
    end
    remove_color_variations result
  end

  def main_profile_showroom(category = nil)
    remove_color_variations(profile_showroom(self.main_profile, category)) if self.main_profile
  end

  def profile_showroom(profile, category = nil)
    scope = profile.products.only_visible.
            where(:collection_id => Collection.current)
    scope = scope.where(:category => category) if category
    scope
  end

  def birthdate
    birthday.strftime("%d/%m/%Y") if birthday
  end

  private

  def remove_color_variations(products)
    result = []
    already_displayed = []
    displayed_and_sold_out = {}

    products.each do |product|
      # Only add to the list the products that aren't already shown
      unless already_displayed.include?(product.name)
        result << product
        already_displayed << product.name
        displayed_and_sold_out[product.name] = result.length - 1 if product.sold_out?
      else
        # If a product of the same color was already displayed but was sold out
        # and the algorithm find another color that isn't, replace the sold out one
        # by the one that's not sold out
        if displayed_and_sold_out[product.name] && !product.sold_out?
          result[displayed_and_sold_out[product.name]] = product
          displayed_and_sold_out.delete product.name
        end
      end
    end
    result
  end

  def generate_invite_token
    loop do
      write_attribute(:invite_token, Devise.friendly_token[0..7])
      break unless User.find_by_invite_token(self.invite_token)
    end if self.invite_token.nil?
  end
end
