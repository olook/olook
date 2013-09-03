require 'spec_helper'

describe ConsolidatedSell do
  describe 'associations' do
    it { should belong_to(:product) }
  end
end
