# -*- encoding : utf-8 -*-
class Category < EnumerateIt::Base
  associate_values(
    :shoe   => [1, 'Shoe'],
    :bag    => [2, 'Bag'],
    :jewel  => [3, 'Jewel']
  )
end
