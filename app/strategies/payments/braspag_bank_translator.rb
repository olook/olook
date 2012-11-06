# -*- encoding : utf-8 -*-
module Payments
  class BraspagBankTranslator

    def self.payment_method_for bank 
      @@acquirers_config ||= load_config
      @@acquirers_config[current_acquirer][sanitize(bank)]
    end

    private
      def self.sanitize bank
        raise "bank cannot be null" if bank.nil? || bank.empty?
        bank.downcase
      end

      def self.current_acquirer
        Setting.acquirer
      end

      def self.load_config
        YAML.load_file "#{Rails.root}/config/acquirers.yml"
      end
  end
end