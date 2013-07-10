# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Brand do
  describe ".categories" do
    context "brand with all categories" do
      subject { described_class.categories "olook" }
      it { should eq %w[roupas sapatos bolsas acessórios] }
    end


    context "brand with only accessories" do
      subject { described_class.categories "juliana manzini" }
      it { should eq %w[acessórios] }
    end

    context "brand with only shoes" do
      subject { described_class.categories "olook concept" }
      it { should eq %w[sapatos] }
    end


    context "brand with only clothes" do
      subject { described_class.categories "Some Brand with only clothes" }
      it { should eq %w[roupas] }
    end
  end
end
