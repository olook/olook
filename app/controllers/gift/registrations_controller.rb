class Gift::RegistrationsController < Devise::RegistrationsController  
  
  def create
    build_resource
    resource.half_user = true
    if resource.save
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
        GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id)
        GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id)
        redirect_to add_products_to_gift_cart_cart_path(:products => session[:gift_products])
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end