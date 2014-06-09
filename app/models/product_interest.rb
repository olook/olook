class ProductInterest < ActiveRecord::Base
  attr_accessible :campaign_email_id, :product_id

  belongs_to :campaign_email

  def self.creates_for(email, product_id)
    newsletter_user = newsletter_user_for(email)

    # TODO => Nao gostei disso.
    interest = ProductInterest.new(campaign_email_id: newsletter_user.id, product_id: product_id)   

    if newsletter_user.valid?
      interest.save
    else 
      interest.errors.add(:email, "Email invalido")
    end

    interest
  end

  private

    def self.newsletter_user_for email
      user = User.find_by_email email   
      CampaignEmail.find_or_create_by_email(email) do |n|
        n.profile = "produto_esgotado"
        n.converted_user = user.present? 
      end      
    end

end
