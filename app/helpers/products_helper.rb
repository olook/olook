module ProductsHelper
  def variant_classes(variant)
    classes = []
    if !variant.available_for_quantity?
      classes << "unavailable"
    elsif variant.description == current_user.user_info.shoes_size.to_s
      classes << "selected"
    end
    classes.join(" ")
  end
end
