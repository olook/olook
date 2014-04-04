class NoBanner < Header

  def self.model_name
    Header.model_name
  end

  def no_banner?
    true
  end

end
