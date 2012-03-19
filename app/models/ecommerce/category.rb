# -*- encoding : utf-8 -*-
class Category < EnumerateIt::Base
  associate_values(
    :shoe       => 1,
    :bag        => 2,
    :accessory  => 3
  )
end
