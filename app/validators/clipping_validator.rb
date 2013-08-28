# -*- encoding : utf-8 -*-
class ClippingValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:base, 'por favor adicione um link ou um arquivo pdf') if record.link.blank? && record.pdf_file.blank?
  end
end
