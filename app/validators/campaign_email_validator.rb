# -*- encoding : utf-8 -*-
class CampaignEmailValidator < ActiveModel::Validator
  def validate(record)
    if User.where(email: record.email).any?
      record.errors.add(:email, "já está cadastrado")
    end
  end
end

