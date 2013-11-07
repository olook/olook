# -*- encoding : utf-8 -*-
class CpfValidator < ActiveModel::Validator
  def validate(record)
    return record.errors.add(:cpf, I18n.t("activerecord.errors.models.#{record.class.name.downcase}.attributes.cpf.blank")) if record.cpf.blank?
    current_cpf = Cpf.new(record.cpf)
    record.errors.add(:cpf, I18n.t("activerecord.errors.models.#{record.class.name.downcase}.attributes.cpf.invalid")) unless current_cpf.valido?
    record.cpf.gsub(/\D/,"") unless record.cpf.blank?
    duplicate_condition = User.where(:cpf => record.cpf)
    duplicate_condition = duplicate_condition.where('id <> :id', :id => record.id) unless record.id.nil?

    if duplicate_condition.any?
      record.errors.add(:cpf, I18n.t("activerecord.errors.models.#{record.class.name.downcase}.attributes.cpf.taken"))
    end
  end
end
