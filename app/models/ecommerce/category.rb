# -*- encoding : utf-8 -*-
class Category < EnumerateIt::Base
  associate_values(
    :shoe       => 1,
    :bag        => 2,
    :accessory  => 3,
    :cloth      => 4
  )

  def self.list_of_all_categories
    [Category::SHOE,Category::BAG,Category::ACCESSORY,Category::CLOTH]
  end

  def self.with_name name
    to_a.select{|category_array| category_array.first.pluralize.parameterize.match(name.parameterize)}.flatten.last
  end

  def self.with_translate_name name
    result_array = self.to_a.select{ |category| category.first.parameterize == name}.flatten
    result_array.last
  end
end
