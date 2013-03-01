# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :promotion_rule, class: CartItemsAmount do
    name "CartItemsAmount"
    type "CartItemsAmount"
    after(:create) do |promo_rule|
      promo_rule.rule_parameters << FactoryGirl.create(:rule_parameter)
      promo_rule.promotions << FactoryGirl.create(:compre_3_pague_2)
    end
  end
end
