require 'spec_helper'

describe Catalog::Catalog do
  it { should_not allow_value("Catalog::Catalog").for(:type) }
  it { should validate_presence_of(:type) }
  
end
