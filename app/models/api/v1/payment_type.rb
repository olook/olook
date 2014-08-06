class Api::V1::PaymentType
  FILENAME = File.expand_path(File.join(Rails.root, "config/payment_types.yml"))
  @@file = YAML::load(File.open(FILENAME))
  def self.all
    @@file
  end

  def self.find(type)
    all.find { |p| p['type'].to_s == type.to_s }
  end
end
