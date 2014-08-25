class Wholesale
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :cnpj, :corporate_name, :fantasy_name, :first_name, :last_name, :email, :address, :neighborhood, :city, :state, :zip_code, :telephone, :cellphone, :cellphone_company
  validate :custom_error_messages

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def custom_error_messages
    errors.add(:cnpj, I18n.t("activerecord.errors.models.wholesale.attributes.cnpj")) if cnpj.blank?
    errors.add(:corporate_name, I18n.t("activerecord.errors.models.wholesale.attributes.corporate_name")) if corporate_name.blank?
    errors.add(:fantasy_name, I18n.t("activerecord.errors.models.wholesale.attributes.fantasy_name")) if fantasy_name.blank?
    errors.add(:first_name, I18n.t("activerecord.errors.models.wholesale.attributes.first_name")) if first_name.blank?
    errors.add(:last_name, I18n.t("activerecord.errors.models.wholesale.attributes.last_name")) if last_name.blank?
    errors.add(:email, I18n.t("activerecord.errors.models.wholesale.attributes.email")) if email.blank?
    errors.add(:address, I18n.t("activerecord.errors.models.wholesale.attributes.address")) if address.blank?
    errors.add(:neighborhood, I18n.t("activerecord.errors.models.wholesale.attributes.neighborhood")) if neighborhood.blank?
    errors.add(:city, I18n.t("activerecord.errors.models.wholesale.attributes.city")) if city.blank?
    errors.add(:state, I18n.t("activerecord.errors.models.wholesale.attributes.state")) if state.blank?
    errors.add(:zip_code, I18n.t("activerecord.errors.models.wholesale.attributes.zip_code")) if zip_code.blank?
    errors.add(:telephone, I18n.t("activerecord.errors.models.wholesale.attributes.telephone")) if telephone.blank?
  end

  def persisted?
  	false
  end

end
