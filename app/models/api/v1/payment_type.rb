class Api::V1::PaymentType
  FILENAME = File.expand_path(File.join(Rails.root, "config/payment_types.yml"))
  @@file = YAML::load(File.open(FILENAME))
  def self.all
    @@file
  end
end
