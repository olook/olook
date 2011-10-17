# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :cpf, :require_cpf
  attr_protected :invite_token

  has_many :points
  has_many :profiles, :through => :points
  has_one :survey_answer
  has_many :invites

  before_create :generate_invite_token

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validate :check_cpf

  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  InviteTokenFormat = /\b[a-zA-Z0-9]{20}\b/

  validates :email, :uniqueness => true
  validates_format_of :email, :with => EmailFormat
  validates_format_of :first_name, :with => /^[A-ZÀ-ÿ\s-]+$/i
  validates_format_of :last_name, :with => /^[A-ZÀ-ÿ\s-]+$/i

  def name
    "#{first_name} #{last_name}".strip
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
    the_invite = invites.find_or_create_by_email(email_address)
    the_invite.valid? ? the_invite : nil
  end

  def invites_for(email_addresses)
    email_addresses.map do |email_address|
      invite_for email_address
    end.compact
  end

  def accept_invitation_with_token(token)
    inviting_member = User.find_by_invite_token(token)
    raise 'Invalid token' unless inviting_member

    inviting_member.invite_for(email).tap do |invite|
      invite.invited_member = self
      invite.accepted_at = Time.now
      invite.save
    end
  end

  def has_facebook?
    self.uid.present?
  end

  private

  def check_cpf
    current_cpf = Cpf.new(self.cpf)
    if is_invited
      errors.add(:cpf, "é inválido") unless current_cpf.valido?
    end
  end

  def generate_invite_token
    loop do
      write_attribute(:invite_token, Devise.friendly_token)
      break unless User.find_by_invite_token(self.invite_token)
    end if self.invite_token.nil?
  end

end
