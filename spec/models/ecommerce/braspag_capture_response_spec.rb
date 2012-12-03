# == Schema Information
#
# Table name: braspag_capture_responses
#
#  id                      :integer          not null, primary key
#  correlation_id          :integer
#  success                 :boolean
#  processed               :boolean          default(FALSE)
#  error_message           :string(255)
#  braspag_transaction_id  :string(255)
#  acquirer_transaction_id :string(255)
#  amount                  :string(255)
#  authorization_code      :string(255)
#  return_code             :string(255)
#  return_message          :string(255)
#  status                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  identification_code     :string(255)
#  retries                 :integer          default(0)
#

require 'spec_helper'

describe BraspagCaptureResponse do
  pending "add some examples to (or delete) #{__FILE__}"
end
