# -*- encoding : utf-8 -*-
module Payments
  class BraspagBankTranslator

    def self.payment_method_for bank 
      configs[current_acquirer][sanitize(bank)]
    end

    private
      def self.sanitize bank
        raise "bank cannot be null" if bank.nil? || bank.empty?
        bank.downcase
      end

      def self.current_acquirer
        Setting.acquirer
      end

      def self.configs
        @@acquirers_config ||= YAML.load_file "#{Rails.root}/config/acquirers.yml"
        @@acquirers_config
      end
  end
end