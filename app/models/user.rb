# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_protected :invite_token

  before_create :generate_invite_token

  has_many :points
  has_many :profiles, :through => :points
  has_one :survey_answer

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates :email, :uniqueness => true
  validates_format_of :email, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates_format_of :name, :with => /^[A-ZÀ-ÿ\s-]+$/i

  def self.find_for_facebook_oauth(access_token, survey_answer, profile_points, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      [user, false]
    else
      if profile_points
        user = User.create(:name => data["name"],
                  :email => data["email"],
                  :password => Devise.friendly_token[0,20])
                  
        survey_answer.user = user
        survey_answer.save  
        [user, true]
      else
        ["", true]
      end    
    end 
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

  def counts_and_write_points(session)
    if self.points.size == 0
      session.each do |profile_id, points|
        self.points.create!(:value => points, :profile_id => profile_id)
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
  
  private

  def generate_invite_token
    loop do
      write_attribute(:invite_token, Devise.friendly_token)
      break unless User.find_by_invite_token(self.invite_token)
    end if self.invite_token.nil?
  end
  
end
