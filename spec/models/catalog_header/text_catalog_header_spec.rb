# encoding: utf-8
require 'spec_helper'

describe CatalogHeader::TextCatalogHeader do
  it { should validate_presence_of(:resume_title) }
  it { should validate_presence_of(:text_complement) }
  it { should validate_presence_of(:title) }
end

