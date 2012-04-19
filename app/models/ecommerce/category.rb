# -*- encoding : utf-8 -*-
class Category < EnumerateIt::Base
  associate_values(
    :shoe       => 1,
    :bag        => 2,
    :accessory  => 3
  )

  def self.array_of_all_categories
    [Category::SHOE,Category::BAG,Category::ACCESSORY]
  end
end
