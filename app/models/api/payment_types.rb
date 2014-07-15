module Api
  class PaymentTypes
    FILENAME = File.expand_path(File.join(Rails.root, "config/payment_types.yml"))
    @@file = YAML::load(File.open(FILENAME))
    def self.types
      @@file
    end
  end
end
