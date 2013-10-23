# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  serialize :facebook_permissions, Array

  attr_accessor :require_cpf, :validate_gender_birthday
  attr_accessible :first_name, :last_name, :email, :password,
    :password_confirmation, :remember_me, :cpf, :state, :city,
    :validate_gender_birthday
  attr_protected :invite_token


  has_many :points, :dependent => :destroy
  has_many :profiles, through: :points, order: Point.arel_table[:value].desc
  has_one :survey_answer, :dependent => :destroy
  has_one :user_info, :dependent => :destroy
  has_many :invites, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :addresses
  has_many :orders
  has_many :carts
  has_many :campaing_participants
  has_many :payments
  has_one :tracking, :dependent => :destroy
  has_many :user_credits
  has_many :credits

  before_create :generate_invite_token
  after_create :initialize_user, :update_campaign_email

  accepts_nested_attributes_for :addresses

  devise :database_authenticatable, :registerable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :token_authenticatable

  EmailFormat = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  InviteTokenFormat = /\b[a-zA-Z0-9]{8}\b/
  NameFormat = /^[A-ZÀ-ÿ\s-]+$/i

  scope :full, where(half_user: false)
  scope :custom_cpf_finder, ->(cpf) {where(cpf: [cpf, cpf.gsub(/[.-]/,"")])}
  search_methods :custom_cpf_finder

  validates :email, :format => {:with => EmailFormat}
  validates :first_name, :presence => true, :format => { :with => NameFormat }
  validates :last_name, :presence => true, :format => { :with => NameFormat }
  validates_with CpfValidator, :attributes => [:cpf], :if => :is_invited
  validates_with CpfValidator, :attributes => [:cpf], :if => :require_cpf
  validates_presence_of :gender, :if => Proc.new{|user| user.respond_to?(:half_user) and user.half_user}, :except => :update
  validates :gender, :birthday, presence: true, :if => 'validate_gender_birthday == "1"'

  FACEBOOK_FRIENDS_BIRTHDAY = "friends_birthday,user_birthday"
  FACEBOOK_PUBLISH_STREAM = "publish_stream"
  FACEBOOK_RELATIONSHIP = "user_relationships,user_relationship_details"
  FACEBOOK_EMAIL = 'email'
  ALL_FACEBOOK_PERMISSIONS = [FACEBOOK_FRIENDS_BIRTHDAY, FACEBOOK_PUBLISH_STREAM, FACEBOOK_RELATIONSHIP, FACEBOOK_EMAIL].join(",")

  Gender = {:female => 0, :male => 1}
  RegisteredVia = {:quiz => 0, :gift => 1, :thin => 2}

  def reseller?
    reseller
  end

  def cpf=(val)
    write_attribute(:cpf, val.to_s.gsub(/\D/,""))
  end

  def valid_password?(password)
    if has_fraud?
      Rails.logger.info("User ##{id}[#{email}] access was blocked because it has fraud!")
      return false
    end
    super
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def survey_answers
    survey_answer.try(:answers)
  end

  def set_facebook_data(omniauth)
    self.add_event(EventType::FACEBOOK_CONNECT) unless self.has_facebook?
    attributes = {:uid => omniauth["uid"], :facebook_token => omniauth["credentials"]["token"]}
    attributes.merge!(:facebook_permissions => (self.facebook_permissions.concat ALL_FACEBOOK_PERMISSIONS.gsub(" ", "").split(",")).uniq)
    update_attributes(attributes)
  end

  def remove_facebook_permissions!
    self.facebook_permissions = []
    self.save
  end

  def self.find_for_facebook_oauth(access_token)
    t = User.arel_table
    user = User.where(t[:uid].eq(access_token["uid"]).and(t[:uid].not_eq(nil)))
    user.first
  end

  def self.find_or_create_with_fb_jssdk_data(data)
    user = self.where(uid: data[:uid]).first
    if user
      user.gender = data[:gender]
      user.birthday ||= data[:birthday]
    else
      user = self.new(data)
      user.password = Devise.friendly_token[0,20]
    end
    saved = user.save
    [saved, user]
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

  def current_credit(date = DateTime.now, type = :available)
    UserCredit::CREDIT_CODES.keys.map{|user_credit_code| user_credits_for(user_credit_code).total(date, type)}.sum
  end

  def can_use_credit?(value)
    current_credit.to_f >= value.to_f
  end

  def credits_for?(value)
    value ||= 0
    self.current_credit - value
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

  def record_first_visit
    add_event(EventType::FIRST_VISIT) if first_visit?
  end

  def add_event(type, description = '')
    description = description.with_indifferent_access if description.is_a?(Hash)
    self.events.create(event_type: type, description: description.to_s)
    self.create_tracking(:utm_source => description.fetch(:utm_source, nil), :utm_medium => description.fetch(:utm_medium, nil),
    :utm_content => description.fetch(:utm_content, nil), :utm_campaign => description.fetch(:utm_campaign, nil),
    :gclid => description.fetch(:gclid, nil), :placement => description.fetch(:placement, nil),
    :referer => description.fetch(:referer, nil)) if type == EventType::TRACKING && description.is_a?(Hash)
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
    self.orders.count > 0
  end

  def first_buy?
    self.orders.paid.count == 1
  end

  def has_purchased_orders?
    self.orders.purchased.size > 0
  end

  def tracking_params(param_name)
    first_event = events(:where => EventType::TRACKING).first
    if first_event
      match_data = (/\"#{param_name}\"=>\"(\w+)\"/).match(first_event.description)
      return match_data.captures.first if match_data
    end
  end

  def first_time_buyer?
    ! has_purchased_orders?
  end

  def male?
    self.gender == Gender[:male]
  end

  def female?
    self.gender == Gender[:female]
  end

  def full_user?
    !half_user
  end

  def upgrade_to_full_user!
    if self.half_user
      self.add_event(EventType::UPGRADE_TO_FULL_USER)
      self.half_user = false
      self.save
    end
  end

  def registered_via? register_type
    self.registered_via == RegisteredVia[register_type]
  end

  def registered_via_string
    RegisteredVia.select{|k,v| v == self.registered_via}.key(self.registered_via).to_s
  end

  def gender_string
    Gender.select{|k,v| v == self.gender}.key(self.gender).to_s
  end

  def clean_auth_token
    self.authentication_token = nil
    self.save
  end

  def shoes_size
    return nil unless self.full_user?
    if user_info
      return user_info.shoes_size
    elsif survey_answers
      return UserInfo::SHOES_SIZE[survey_answers.fetch(:question_57, nil)]
    end
    nil
  end

  def user_credits_for code
    credit_type = CreditType.find_by_code!(code.to_s)
    self.user_credits.find_or_create_by_credit_type_id(credit_type.id)
  end

  def has_credit?(date = DateTime.now)
    self.current_credit(date) > 0
  end

  def first_visit_for_member?
    if self.first_visit?
      self.record_first_visit
      true
    else
      false
    end
  end

  def update_campaign_email
    campaign_email = CampaignEmail.find_by_email(self.email)
    if campaign_email
      campaign_email.update_attribute(:converted_user, true)
      update_attribute(:campaign_email_created_at, campaign_email.created_at)
    end
  end

  def converted_from_campaign_email?
    !self.campaign_email_created_at.nil?
  end

  def has_valid_cpf?
    self.cpf && Cpf.new(self.cpf).valido?
  end

  private

  def generate_invite_token
    loop do
      write_attribute(:invite_token, Devise.friendly_token[0..7])
      break unless User.find_by_invite_token(self.invite_token)
    end if self.invite_token.nil?
  end

  def initialize_user
    Resque.enqueue(SignupNotificationWorker, self.id)
    self.add_event(EventType::SIGNUP)
    UserCredit.add_for_invitee(self)
    self.reset_authentication_token!
  end
end
