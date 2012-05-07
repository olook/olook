require 'spec_helper'

describe Catalog::Product do
  it { should belong_to(:catalog) }
  it { should belong_to(:product) }
  it { should belong_to(:variant) }
  
end
