# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :order do
    association :payment, :factory => :billet
  end
end
