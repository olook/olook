# -*- encoding : utf-8 -*-
class CampaignEmailValidator < ActiveModel::Validator
  def validate(record)
    if User.where(email: record.email).any?
      record.errors.add(:email, :exists, email: record.email)
    end
  end
end

