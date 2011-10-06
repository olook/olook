# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :cpf, :require_cpf
  attr_accessor :require_cpf
  attr_protected :invite_token

  has_many :points
  has_many :profiles, :through => :points
  has_one :survey_answer
  has_many :invites

  before_create :generate_invite_token

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validate :check_cpf
  validates :email, :uniqueness => true
  validates_format_of :email, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates_format_of :first_name, :with => /^[A-ZÀ-ÿ\s-]+$/i
  validates_format_of :last_name, :with => /^[A-ZÀ-ÿ\s-]+$/i

  InviteTokenFormat = /\b[a-zA-Z0-9]{20}\b/

  def self.find_for_facebook_oauth(access_token)
    data = access_token['extra']['user_hash']
    user = User.find_by_uid(data["id"])
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
        user.first_name = data["first_name"]
        user.last_name = data["last_name"]
        user.cpf = "Preencha seu CPF" if session[:invite]
      end
    end
  end

  def counts_and_write_points(session)
    user_dont_have_points = self.points.size == 0
    if user_dont_have_points
      session.each do |profile_id, points|
        self.points.create(:value => points, :profile_id => profile_id)
      end
    end
  end

  def invite_token=(token)
    if new_record?
      write_attribute(:invite_token, token)
    else
      raise 'Invite token is read only'
    end
  end

  def invite_for(email)
    self.invites.find_or_create_by_email(:email => email)
  end

  def accept_invitation_with_token(token)
    inviting_member = User.find_by_invite_token(token)
    raise 'Invalid token' unless inviting_member

    #inviting_member.invite_for(email).tap do |invite|
    #  invite.invited_member = self
    #  invite.accepted_at = Time.now
    #  invite.save
    #end
  end

  def has_facebook?
    self.uid.present?
  end

  def get_invite_token
    invite_token
  end

  private

  def check_cpf
    current_cpf = Cpf.new(self.cpf)
    if require_cpf
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
