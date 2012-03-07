# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Credit do
  it { should belong_to(:user) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:value) }
end