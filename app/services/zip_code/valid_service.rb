# -*- encoding : utf-8 -*-
class ZipCode::ValidService
  VALID_ZIP_FORMAT = /\A(\d{8})\z/
  def self.apply? zip
    zip.to_s.match(VALID_ZIP_FORMAT)
  end
end


