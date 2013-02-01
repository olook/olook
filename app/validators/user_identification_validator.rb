class UserIdentificationValidator < ActiveModel::Validator
  def validate record
    current_cpf = Cpf.new(record.user_identification)
    record.errors.add(:user_identification, I18n.t('activerecord.errors.models.user.attributes.cpf.invalid')) unless current_cpf.valido?    
  end
end