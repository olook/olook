# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :order do
    association :freight, :factory => :freight
    association :user, :factory => :user 

    subtotal BigDecimal.new("100")
    amount_paid BigDecimal.new("100")

    user_email 'jose.ernesto@dominio.com'
    user_cpf '228.016.368-35'
    
    trait :with_billet do
      after(:create) do |order|
        FactoryGirl.create(:billet, :order => order)
      end 
    end
  
    trait :with_authorized_credit_card do
      after(:create) do |order|
        FactoryGirl.create(:credit_card_with_response_authorized, :order => order)
      end
    end   
  
    factory :clean_order, :class => Order do
      after(:create) do |order|
        FactoryGirl.create(:billet, :order => order)
      end
    end

    factory :restricted_order, :class => Order do
      restricted true

      after(:create) do |order|
        FactoryGirl.create(:billet, :order => order)
      end    
    end

    factory :clean_order_credit_card, :class => Order do
      after(:create) do |order|
        FactoryGirl.create(:credit_card, :order => order)
      end
    end

    factory :clean_order_credit_card_authorized, :class => Order do
      after(:create) do |order|
        FactoryGirl.create(:authorized_credit_card, :order => order, :user => order.user)
      end
    end

    factory :order_without_payment, :class => Order do
    end

    factory :authorized_order, :class => Order do
      state "authorized"

      after(:create) do |order|
        FactoryGirl.create(:credit_card_with_response, :order => order)
      end
      after(:create) do |order|
        FactoryGirl.create(:authorized, :order => order)
      end
    end  

    factory :delivered_order, :class => Order do
      state "delivered"
      subtotal BigDecimal.new("99.90")
      amount_paid BigDecimal.new("99.90")
      
      after(:create) do |order|
        FactoryGirl.create(:billet, :order => order)
      end    
    end

    factory :order_with_canceled_payment, :class => Order do
      state "canceled"

      #after_create do |order|
      #  FactoryGirl.create(:credit_card_with_response_canceled, :order => order)
      #end
    end

  end
end
