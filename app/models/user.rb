# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :cpf, :require_cpf
  attr_protected :invite_token

  has_many :points, :dependent => :destroy
  has_one :survey_answer, :dependent => :destroy
  has_many :invites, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :addresses
  has_many :orders

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

  def invite_for(email_address, was_sent_at = nil)
    the_invite = invites.find_by_email(email_address) || invites.build(:email => email_address)
    the_invite.sent_at = was_sent_at unless was_sent_at.nil?

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

    inviting_member.invite_for(email, Time.now).accept_invitation(self)
  end

  def has_facebook?
    self.uid.present?
  end

  def invite_bonus
    InviteBonus.calculate(self)
  end

  def profile_scores
    self.points.includes(:profile).order('value DESC')
  end

  def first_visit?
    self.events.where(:type => EventType::FIRST_VISIT).empty?
  end

  def record_first_visit
    add_event(EventType::FIRST_VISIT) if first_visit?
  end

  def add_event(type, description = '')
    self.events.create(type: type, description: description)
  end

  private

  def generate_invite_token
    loop do
      write_attribute(:invite_token, Devise.friendly_token[0..7])
      break unless User.find_by_invite_token(self.invite_token)
    end if self.invite_token.nil?
  end
end
