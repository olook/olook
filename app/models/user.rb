# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  has_many :points
  has_many :profiles, :through => :points

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates :email, :uniqueness => true
  validates_format_of :email, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates_format_of :name, :with => /^[A-ZÀ-ÿ\s-]+$/i

  def self.find_for_facebook_oauth(access_token, survey_answer, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else
      user = User.create(:name => data["name"],
                  :email => data["email"],
                  :password => Devise.friendly_token[0,20])
                  
      survey_answer.user = user
      survey_answer.save  
      user     
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
    session.each do |profile_id, points|
      self.points.create!(:value => points, :profile_id => profile_id)
    end
  end
end
