require 'spec_helper'

describe Catalog::Moment do
  it { should belong_to(:moment) }
end
