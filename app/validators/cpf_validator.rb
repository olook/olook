# -*- encoding : utf-8 -*-
class CpfValidator < ActiveModel::Validator
  def validate(record)
    current_cpf = Cpf.new(record.cpf)
    record.errors.add(:cpf, "é inválido") unless current_cpf.valido?
    record.errors.add(:cpf, "já está cadastrado") if User.find_by_cpf(record.cpf)
  end
end

