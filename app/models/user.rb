# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base  
  serialize :facebook_permissions, Array

  attr_accessor :require_cpf
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :cpf
  attr_protected :invite_token

  has_many :points, :dependent => :destroy
  has_one :survey_answer, :dependent => :destroy
  has_one :user_info, :dependent => :destroy
  has_many :invites, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :addresses
  has_many :orders
  has_many :payments, :through => :orders
  has_many :credits
  has_one :tracking, :dependent => :destroy

  before_create :generate_invite_token
  
  delegate :shoes_size, :to => :user_info, :allow_nil => true

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :token_authenticatable

  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  InviteTokenFormat = /\b[a-zA-Z0-9]{8}\b/
  NameFormat = /^[A-ZÀ-ÿ\s-]+$/i

  validates :email, :format => {:with => EmailFormat}
  validates :first_name, :presence => true, :format => { :with => NameFormat }
  validates :last_name, :presence => true, :format => { :with => NameFormat }
  validates_with CpfValidator, :attributes => [:cpf], :if => :is_invited
  validates_with CpfValidator, :attributes => [:cpf], :if => :require_cpf
  validates_presence_of :gender, :if => Proc.new{|user| user.respond_to?(:half_user) and user.half_user}
  
  FACEBOOK_FRIENDS_BIRTHDAY = "friends_birthday"
  FACEBOOK_PUBLISH_STREAM = "publish_stream"
  ALL_FACEBOOK_PERMISSIONS = [FACEBOOK_FRIENDS_BIRTHDAY, FACEBOOK_PUBLISH_STREAM].join(",")
  
  Gender = {:female => 0, :male => 1}
  
  def name
    "#{first_name} #{last_name}".strip
  end

  def survey_answers
    survey_answer.try(:answers)
  end

  def set_facebook_data(omniauth, session)
    attributes = {:uid => omniauth["uid"], :facebook_token => omniauth["credentials"]["token"]}
    if session[:facebook_scopes]
      attributes.merge!(:facebook_permissions => (self.facebook_permissions.concat session[:facebook_scopes].gsub(" ", "").split(",")).uniq)
    end
    update_attributes(attributes)
  end

  def self.find_for_facebook_oauth(access_token)
    t = User.arel_table
    user = User.where(t[:uid].eq(access_token["uid"]).and(t[:uid].not_eq(nil)))
    user.first
  end

  def invite_token=(token)
    raise 'Invite token is read only'
  end

  def invite_for(email_address)
    the_invite = invites.find_by_email(email_address) || invites.build(:email => email_address)
    the_invite.save ? the_invite : nil
  end

  def invites_for(email_addresses, limit = Invite::LIMIT)
    email_addresses[0..limit].map do |email_address|
      invite_for email_address
    end.compact
  end

  def inviter
    Invite.find_inviter(self) if is_invited?
  end

  def accept_invitation_with_token(token)
    inviting_member = User.find_by_invite_token!(token)
    accepted_invite = inviting_member.invite_for(email) || inviting_member.invites.create(:email => email, :sent_at => Time.now)
    accepted_invite.accept_invitation(self)
  end

  def has_facebook?
    self.uid.present?
  end
  
  def has_facebook_friends_birthday?
    has_facebook? && self.facebook_permissions.include?(FACEBOOK_FRIENDS_BIRTHDAY)
  end

  def can_access_facebook_extended_features?
    has_facebook? && self.facebook_permissions.include?(FACEBOOK_PUBLISH_STREAM)
  end

  def invite_bonus
    InviteBonus.calculate(self)
  end

  def used_invite_bonus
    InviteBonus.already_used(self)
  end

  def current_credit
    credits.last.try(:total) || 0
  end

  def has_not_exceeded_credit_limit?(value = 0)
    (used_invite_bonus + current_credit + value) <= InviteBonus::LIMIT_FOR_EACH_USER
  end

  def can_use_credit?(value)
    current_credit.to_f >= value.to_f
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
    self.events.create(event_type: type, description: description.to_s)
    self.create_tracking(description) if type == EventType::TRACKING && description.is_a?(Hash)
  end

  def invitation_url(host = 'www.olook.com.br')
    Rails.application.routes.url_helpers.accept_invitation_url self.invite_token, :host => host
  end

  def all_profiles_showroom(category = nil, collection = Collection.active)
    result = []
    self.profile_scores.each do |profile_score|
      result = result | profile_showroom(profile_score.profile, category, collection).all
    end
    Product.remove_color_variations result
  end

  def main_profile_showroom(category = nil, collection = Collection.active)
    categories = category.nil? ? [Category::SHOE,Category::BAG,Category::ACCESSORY] : [category]
    results = []
    categories.each do |cat|
      results += all_profiles_showroom(cat, collection = Collection.active)[0..4]
    end
     Product.remove_color_variations results
  end

  def profile_showroom(profile, category = nil, collection = Collection.active)
    scope = profile.products.only_visible.
            where(:collection_id => collection)
    scope = scope.where(:category => category) if category
    scope
  end

  def birthdate
    birthday.strftime("%d/%m/%Y") if birthday
  end

  def age
    return @age if @age
    if birthday
      today = Date.today
      age = today.year - birthday.year
      age -= 1 if(today.yday < birthday.yday)
      @age = age
    end
  end

  def is_new?
    (self.created_at + 24.hours) > DateTime.now
  end

  def is_old?
    (self.created_at + 24.hours) < DateTime.now
  end

  def has_purchases?
    self.orders.not_in_the_cart.count > 0
  end

  def first_buy?
    self.orders.paid.count == 1
  end

  def tracking_params(param_name)
    first_event = events(:where => EventType::TRACKING).first
    if first_event
      match_data = (/\"#{param_name}\"=>\"(\w+)\"/).match(first_event.description)
      return match_data.captures.first if match_data
    end
  end

  def total_revenue(total_method = :total)
    self.orders.joins(:payment)
        .where("payments.state IN ('authorized','completed')")
        .inject(0) { |sum,order| sum += order.send(total_method) }
  end

  def tracking_params(param_name)
    first_event = events(:where => EventType::TRACKING).first
    if first_event
      match_data = (/\"#{param_name}\"=>\"(\w+)\"/).match(first_event.description)
      return match_data.captures.first if match_data
    end
  end

  def total_revenue(total_method = :total)
    self.orders.joins(:payment)
        .where("payments.state IN ('authorized','completed')")
        .inject(0) { |sum,order| sum += (order.send(total_method) || 0) }
  end

  private

  def generate_invite_token
    loop do
      write_attribute(:invite_token, Devise.friendly_token[0..7])
      break unless User.find_by_invite_token(self.invite_token)
    end if self.invite_token.nil?
  end
end
