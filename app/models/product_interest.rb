class ProductInterest < ActiveRecord::Base
  attr_accessible :campaign_email_id, :product_id

  belongs_to :campaign_email

  def self.creates_for email, product_id
    user = User.find_by_email email   
    newsletter_user = CampaignEmail.find_or_create_by_email(email) do |n|
      n.profile = "produto_esgotado"
      n.converted_user = user.present? 
    end


    # TODO => Nao gostei disso.
    interest = ProductInterest.create({campaign_email_id: newsletter_user.id, product_id: product_id})   
    interest.errors.add(:email, "Email invalido") if !newsletter_user.valid?
    interest
  end

end
