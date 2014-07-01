# -*- encoding : utf-8 -*-
class ProductInterest < ActiveRecord::Base
  attr_accessible :campaign_email_id, :product_id, :color, :subcategory

  belongs_to :campaign_email

  def self.creates_for(email, product_id,product_color,product_subcategory)
    newsletter_user = newsletter_user_for(email)

    # TODO => Nao gostei disso.
    interest = ProductInterest.new(campaign_email_id: newsletter_user.id, product_id: product_id, color: product_color, subcategory: product_subcategory)

    if newsletter_user.valid?
      interest.save
    else 
      interest.errors.add(:email, "Email invalido")
    end

    interest
  end

  def self.as_csv
    CSV.generate do |csv|
      csv << ["Email", "Id do produto", "Criado em", "Subcategoria", "Cor"]
      all.each do |item|
        csv << [item.campaign_email.email,item.product_id, I18n.l(item.created_at, format: "%d/%m/%Y"), item.subcategory, item.color]
      end
    end
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
