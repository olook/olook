# -*- encoding : utf-8 -*-
class Category < EnumerateIt::Base
  associate_values(
    :shoe       => [1, 'Shoe'],
    :bag        => [2, 'Bag'],
    :accessory  => [3, 'Accessory']
  )
end
