# -*- encoding : utf-8 -*-
class MarketingUploaderWorker
  @queue = :marketing_uploader

  def self.perform
    MarketingReports::Builder.new(:userbase_with_auth_token_and_credits).upload("base_atualizada_purchases_auth_token_and_credits.csv")
  end
end
