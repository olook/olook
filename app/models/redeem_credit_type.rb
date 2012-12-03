# encoding: utf-8
# == Schema Information
#
# Table name: credit_types
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code       :string(255)
#

class RedeemCreditType < CreditType
  
  def add(opts={})
    raise ArgumentError.new('Admin user is required!') if opts[:admin_id].nil?
    super(opts)
  end
  
end
