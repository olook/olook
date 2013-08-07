# -*- encoding : utf-8 -*-
class Category < EnumerateIt::Base
  associate_values(
    :shoe       => 1,
    :bag        => 2,
    :accessory  => 3,
    :cloth      => 4,
    :lingerie   => 5,
    :beachwear  => 6
  )

  def self.list_of_all_categories
    [Category::SHOE,Category::BAG,Category::ACCESSORY,Category::CLOTH, Category::LINGERIE, Category::BEACHWEAR]
  end

  def self.with_name name
    to_a.select{|category_array| category_array.first.pluralize.parameterize.match(name.parameterize)}.flatten.last
  end

  def self.for_class_name name
    key_for(self.with_name(name)).to_s.pluralize
  end
end