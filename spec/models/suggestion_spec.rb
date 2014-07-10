 #-*- encoding : utf-8 -*-
require 'spec_helper'

describe Suggestion do

  context "subcategory is blank" do
    subject {Suggestion.for({filter_color: 'verde'})}
    it {should be_nil}
  end

  context "invalid color" do
    subject {Suggestion.for({subcategory: 'blusa', filter_color: 'verde água'})}
    it {should be_nil}
  end

  context "Blazer, Preto" do
    subject {Suggestion.for({subcategory: 'Blazer', filter_color: 'preto'})}
    it {should eq('Blazer Preto')}
  end

  context "Sandalia, Preto" do
    subject {Suggestion.for({subcategory: 'sandalia', filter_color: 'preto'})}
    it {should eq('Sandalia Preta')}
  end  

  context "Blusa, terrosos" do
    subject {Suggestion.for({subcategory: 'blusa', filter_color: 'terrosos'})}
    it {should eq('Blusa Em Tons Terrosos')}
  end

  context "Bolsa grande, vermelho" do
    subject {Suggestion.for({subcategory: 'bolsa grande', filter_color: 'vermelho'})}
    it {should eq('Bolsa Grande Vermelha')}
  end  

  context "ankle boot, amarelo" do
    subject {Suggestion.for({subcategory: 'ankle boot', filter_color: 'amarelo'})}
    it {should eq('Ankle Boot Amarela')}
  end  

end