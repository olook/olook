# -*- encoding : utf-8 -*-
require "spec_helper"

describe ProductSearchWorker do
  it ".perform" do
    expect(described_class.perform).to be_true
  end
end
