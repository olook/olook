# encoding: utf-8
require 'spec_helper'

describe TextCatalogHeader do
  it { should validate_presence_of(:title) }
end

