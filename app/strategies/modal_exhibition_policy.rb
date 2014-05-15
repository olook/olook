class ModalExhibitionPolicy
  BLACK_LIST = /(sacola|pagamento)/

  def self.apply?(path,cookie)
    path !~ BLACK_LIST && cookie.blank?
  end
end
