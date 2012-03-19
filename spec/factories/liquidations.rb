# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :liquidation do
    name "olooklet"
    description "D" * 100
    starts_at Date.yesterday
    ends_at Date.tomorrow
    resume :products_ids=>[100, 10], :categories=>{1=>{"sandalia"=>"Sandália", "rasteira"=>"Rasteira"}, 2=>{"tate" => "Tate", "bau" => "Baú"}, 3 => {"joia" => "Jóia", "brinco" => "Brinco"}}, :heels=>{"baixo"=>"Baixo", "medio" => "Médio", "6.5" => "6.5"}, :shoe_sizes=>{"33"=>33, "34"=>34, "35"=>35, "36"=>36, "37"=>37, "38"=>38, "39"=>39, "40"=>40}
  end
end
