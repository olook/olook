require 'spec_helper'

describe LookbookImageMap do
  it { should belong_to(:lookbook) }
  it { should belong_to(:image) }
  it { should belong_to(:product) }
  it { should validate_presence_of(:product) }
  it { should validate_presence_of(:image) }
  it { should validate_presence_of(:product) }
  
end
