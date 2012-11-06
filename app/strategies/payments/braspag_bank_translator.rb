# -*- encoding : utf-8 -*-
module Payments
  class BraspagBankTranslator
    ACQUIRERS_CONFIG = YAML.load_file "#{Rails.root}/config/acquirers.yml"

    def self.payment_method_for bank 
      ACQUIRERS_CONFIG[current_acquirer][sanitize(bank)]
    end

    private
      def self.sanitize bank
        raise "bank cannot be null" if bank.nil? || bank.empty?

        bank.downcase
      end

      def self.current_acquirer
        Setting.acquirer
      end
  end
end