class ModalExhibitionPolicy
  BLACK_LIST = /(sacola|pagamento)/

  def self.apply?(opts={})
     avaliable_path?(opts[:path]) && without_cookie?(opts[:cookie]) && opts[:user].blank? && opts[:mobile] == false
  end

  private

  def self.avaliable_path?(path)
    path !~ BLACK_LIST
  end

  def self.without_cookie?(cookie)
    cookie.blank?
  end

end
