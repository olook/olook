# -*- encoding : utf-8 -*-
class Users::RegistrationsController < Devise::RegistrationsController
  layout :layout_by_resource

  before_filter :check_survey_response, :only => [:new, :create]
  before_filter :authenticate_user!, :only => [:destroy_facebook_account, :edit, :update]

  def new
    resource = build_resource({:half_user => false})
    respond_with resource
  end

  def new_half
    resource = build_resource({:half_user => true})
    respond_with resource
  end

  def create_half
    self.create
  end

  def edit
    if params[:checkout_registration] == "true"
      if @user.cpf.blank?
        @user.errors.add(:cpf, I18n.t('activerecord.errors.models.user.attributes.cpf.blank'))
      elsif !@user.has_valid_cpf?
        @user.errors.add(:cpf, I18n.t('activerecord.errors.models.user.attributes.cpf.invalid'))
      end
    end

    @questions = Question.from_registration_survey
    @presenter = SurveyQuestions.new(@questions)
  end

  def update
    @questions = Question.from_registration_survey
    @presenter = SurveyQuestions.new(@questions)
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation) if
      params[:user][:password_confirmation].blank?
    end
    params[:user].delete(:cpf) if params[:user][:cpf] && resource.has_valid_cpf?

    # Override Devise to use update_attributes instead of update_with_password.
    # This is the only change we make.

    if resource.update_attributes(params[:user])
      if params[:user_info] && params[:user_info][:shoes_size]
        shoe_size = params[:user_info][:shoes_size]
        if resource.user_info
          resource.user_info.update_attribute(:shoes_size, shoe_size)
        else
          resource.create_user_info( { :shoes_size => shoe_size } )
        end
      end
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource, :bypass => true
      after_update_path = after_update_path_for(resource)
      if after_update_path
        respond_with resource, :location => after_update_path_for(resource)
      else
        render_with_scope :edit
      end
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  def destroy_facebook_account
    @user.update_attributes(:uid => nil, :facebook_token => nil, :facebook_permissions => [])
    redirect_to(member_showroom_path, :notice => "Sua conta do Facebook foi removida com sucesso")
  end

  protected

  def build_resource(params = nil)
    resource = super(params)

    if data_face = user_data_from_facebook
      # resource.email = data_face["email"]
      resource.first_name = data_face["first_name"]
      resource.last_name = data_face["last_name"]
      resource.uid = data_face["id"]
      resource.facebook_token = session["devise.facebook_data"]["credentials"]["token"]
      @signup_with_facebook = true
    end

    if bday = session[:profile_birthday]
      resource.birthday = Date.new(
        bday[:year].to_i,
        bday[:month].to_i,
        bday[:day].to_i)
    end

    if session[:invite]
      resource.is_invited = true
    end

    if !resource.half_user
      resource.registered_via = User::RegisteredVia[:quiz]
    else
      if @cart.try(:has_gift_items?)
        resource.registered_via = User::RegisteredVia[:gift]
      else
        resource.registered_via = User::RegisteredVia[:thin]
      end
    end

    resource
  end

  def after_sign_up_path_for(resource_or_scope)
    unless resource_or_scope.half_user
      ProfileBuilder.factory(session[:profile_birthday], session[:profile_questions], resource_or_scope)
      session[:profile_birthday] = nil
      session[:profile_questions] = nil
    end

    session[:tracking_params] ||= {}
    if session[:tracking_params].present?
      resource.add_event(EventType::TRACKING, session[:tracking_params])
    end

    if session[:invite]
      resource.accept_invitation_with_token(session[:invite][:invite_token])
    end

    session[:tracking_params] = nil
    session["devise.facebook_data"] = nil
    session[:invite] = nil

    if @cart
      @cart.update_attributes(:user_id => resource.id)

      if @cart.has_gift_items?
        GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id) if session[:occasion_id]
        GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id) if session[:recipient_id]
      end

      return new_checkout_url(protocol: 'https') if @cart.items_total > 0
    end

    if resource.half_user && resource.male?
      gift_root_path
    else
      member_welcome_path
    end
  end

  def after_update_path_for(resource)
    if @cart && @cart.items_total > 0
      new_checkout_url(protocol: 'https')
    end
  end

  def user_data_from_facebook
    if session["devise.facebook_data"]
      session["devise.facebook_data"]["extra"]["raw_info"]
    end
  end

  def check_survey_response
    if session[:profile_questions].nil? || session[:profile_birthday].nil?
      redirect_to wysquiz_path
    end
  end

  def layout_by_resource
    return "my_account" if action_name == "edit"
    return "my_account" if action_name == "update"
    return "checkout" if (action_name == "new_half" || action_name == "create_half") && params[:checkout_registration] == "true"
    return "site"
  end
end
