class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me
  has_many :points
  has_many :profiles, :through => :points

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else
      User.create(:first_name => data["first_name"],
                  :last_name => data["last_name"],
                  :email => data["email"],
                  :password => Devise.friendly_token[0,20]) 
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

  def contabilize_points(session)
    session.each do |profile_id, points|
      self.points.create!(:value => points, :profile_id => profile_id)
    end
  end
end
