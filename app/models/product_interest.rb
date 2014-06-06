class ProductInterest < ActiveRecord::Base
  attr_accessible :campaign_email_id, :product_id



  belongs_to :campaign_email


  def self.creates_for email, product_id
    user = User.find_by_email email   
    newsletter_user = CampaignEmail.find_or_create_by_email(email) do |n|
      n.profile = "produto_esgotado"
    end

    if user
      newsletter_user.update_attribute(:converted_user, true)
    end

    ProductInterest.create({campaign_email_id: newsletter_user.id, product_id: product_id})

  end

end
