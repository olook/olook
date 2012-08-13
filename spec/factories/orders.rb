# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_order, :class => Order do
    association :payment, :factory => :billet
    association :freight, :factory => :freight
    user_first_name 'José'
    user_last_name 'Ernesto'
    user_email 'jose.ernesto@dominio.com'
    user_cpf '228.016.368-35'
    after_build do |order|
      Resque.stub(:enqueue)
    end
  end

  factory :restricted_order, :class => Order do
    association :payment, :factory => :billet
    association :freight, :factory => :freight
    restricted true

    after_build do |order|
      Resque.stub(:enqueue)
    end
  end

  factory :clean_order_credit_card, :class => Order do
    association :payment, :factory => :credit_card
    association :freight, :factory => :freight

    after_build do |order|
      Resque.stub(:enqueue)
    end
  end

  factory :order do
    association :payment, :factory => :billet
    association :freight, :factory => :freight
    subtotal BigDecimal.new("100")
    amount_paid BigDecimal.new("100")
    user_first_name 'José'
    user_last_name 'Ernesto'
    user_email 'jose.ernesto@dominio.com'
    user_cpf '228.016.368-35'
    
    after_build do |order|
      Resque.stub(:enqueue)
      Resque.stub(:enqueue_in)
    end
  end

  factory :authorized_order, :class => Order do
    association :payment, :factory => :credit_card_with_response
    association :freight, :factory => :freight
    state "authorized"
    subtotal BigDecimal.new("100")
    amount_paid BigDecimal.new("100")

    after_build do |order|
      Resque.stub(:enqueue)
      Resque.stub(:enqueue_in)
    end
  end

  factory :delivered_order, :class => Order do
    association :payment, :factory => :billet
    association :freight, :factory => :freight
    association :user
    state "delivered"
    subtotal BigDecimal.new("99.90")
    amount_paid BigDecimal.new("99.90")
  end
end
