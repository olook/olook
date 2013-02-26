# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_order, :class => Order do
    association :freight, :factory => :freight
    user_first_name 'José'
    user_last_name 'Ernesto'
    user_email 'jose.ernesto@dominio.com'
    user_cpf '228.016.368-35'
    after(:create) do |order|
      FactoryGirl.create(:billet, :order => order)
    end
  end

  factory :restricted_order, :class => Order do
    association :freight, :factory => :freight
    restricted true

    after(:create) do |order|
      FactoryGirl.create(:billet, :order => order)
    end    
  end

  factory :clean_order_credit_card, :class => Order do
    association :freight, :factory => :freight

    after(:create) do |order|
      FactoryGirl.create(:credit_card, :order => order)
    end
  end

  factory :clean_order_credit_card_authorized, :class => Order do
    association :freight, :factory => :freight

    after(:create) do |order|
      FactoryGirl.create(:authorized_credit_card, :order => order, :user => order.user)
    end
  end

  factory :order_without_payment, :class => Order do
    association :freight, :factory => :freight

  end

  factory :order do
    association :freight, :factory => :freight
    subtotal BigDecimal.new("100")
    amount_paid BigDecimal.new("100")
    user_first_name 'José'
    user_last_name 'Ernesto'
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
  end

  factory :authorized_order, :class => Order do
    association :freight, :factory => :freight
    user_first_name 'José'
    user_last_name 'Ernesto'
    user_email 'jose.ernesto@dominio.com'
    user_cpf '228.016.368-35'
    state "authorized"
    subtotal BigDecimal.new("100")
    amount_paid BigDecimal.new("100")

    after(:create) do |order|
      FactoryGirl.create(:credit_card_with_response, :order => order)
    end
    after(:create) do |order|
      FactoryGirl.create(:authorized, :order => order)
    end
  end

  factory :delivered_order, :class => Order do
    association :freight, :factory => :freight
    association :user
    state "delivered"
    subtotal BigDecimal.new("99.90")
    amount_paid BigDecimal.new("99.90")
    
    after(:create) do |order|
      FactoryGirl.create(:billet, :order => order)
    end    
  end
end
