require 'spec_helper'

describe UsedPromotion do
  it { should belong_to :order }
  it { should belong_to :promotion  }
end
