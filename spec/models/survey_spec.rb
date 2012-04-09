require 'spec_helper'

describe Survey do
  describe 'relationships' do
    it { should have_many :questions }
  end
end
