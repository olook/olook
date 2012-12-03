# == Schema Information
#
# Table name: braspag_authorize_responses
#
#  id                      :integer          not null, primary key
#  correlation_id          :string(255)
#  success                 :boolean
#  error_message           :string(255)
#  identification_code     :string(255)
#  braspag_order_id        :string(255)
#  braspag_transaction_id  :string(255)
#  amount                  :string(255)
#  payment_method          :integer
#  acquirer_transaction_id :string(255)
#  authorization_code      :string(255)
#  return_code             :string(255)
#  return_message          :string(255)
#  status                  :integer
#  credit_card_token       :string(255)
#  processed               :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  retries                 :integer          default(0)
#

require 'spec_helper'

describe BraspagAuthorizeResponse do
  pending "add some examples to (or delete) #{__FILE__}"
end
