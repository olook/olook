# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :address do
    city 'Rio de Janeiro'
    state 'RJ'
    country 'BRA'
    complement 'ap 45'
    street 'Rua Exemplo Teste'
    number '12354'
    neighborhood 'Centro'
    zip_code '87656-908'
    telephone '(35)3712-3457'
    mobile '(21)99876-2737'
  end
end
