# == Schema Information
#
# Table name: catalogs
#
#  id             :integer          not null, primary key
#  type           :string(255)
#  association_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Catalog::Catalog do
  it { should_not allow_value("Catalog::Catalog").for(:type) }
  it { should validate_presence_of(:type) }
  it { should have_many(:products)}
end
