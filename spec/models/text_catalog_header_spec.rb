# encoding: utf-8
require 'spec_helper'

describe TextCatalogHeader do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:resume_title) }
end

