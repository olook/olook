require 'spec_helper'

describe WishedProduct do
  it { should belong_to :variant }
  it { should belong_to :wishlist }
  it { should respond_to :retail_price }
end
