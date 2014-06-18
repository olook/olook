class ModalExhibitionPolicy
  BLACK_LIST = /(sacola|pagamento|admin)/
  NUMBER_OF_VIEWS_TO_SHOW = [0,5]

  def self.apply?(opts={})
    return false if opts[:mobile] == true || opts[:user]
     avaliable_path?(opts[:path]) && avaliable_cookie?(opts[:cookie])
  end

  private

  def self.avaliable_path?(path)
    path !~ BLACK_LIST
  end

  def self.avaliable_cookie?(cookie)
    without_cookie?(cookie) || with_avaliable_views?(cookie)
  end

  def self.without_cookie?(cookie)
    cookie.blank?
  end

  def self.with_avaliable_views?(cookie)
    NUMBER_OF_VIEWS_TO_SHOW.include? cookie
  end
end
