# -*- encoding : utf-8 -*-
class ZipCode::SanitizeService
  def self.clean zip
    zip.to_s.to_s.gsub(/\D/, '')
  end
end
