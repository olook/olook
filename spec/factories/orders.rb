# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_order, :class => Order do
    association :payment, :factory => :billet
    association :freight, :factory => :freight
  end
  factory :order do
    association :payment, :factory => :billet
    association :freight, :factory => :freight
    after_create do |order|
      order.stub(:total).and_return(100)
      order.stub(:reload)
    end
  end
end
