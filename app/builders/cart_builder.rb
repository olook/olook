class CartBuilder
  
  def self.gift(controller, resource)
    #session[:gift_products]
    GiftOccasion.find(session[:occasion_id]).update_attributes(:user_id => resource.id)
    GiftRecipient.find(session[:recipient_id]).update_attributes(:user_id => resource.id)
    cart_path
  end
  
  def self.offline(controller, resource)
    #session[:offline_variant]
    cart_path
  end
  
end