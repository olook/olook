require 'spec_helper'

describe CancellationReason do
  context 'validations' do
    it {should validate_presence_of(:source)}
    it {should belong_to(:order)}
  end
end
