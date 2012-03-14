module ProductsHelper
  def variant_classes(variant)
    classes = []
    if !variant.available_for_quantity?
      classes << "unavailable"
    elsif !current_user.nil?
      if !current_user.user_info.nil?
        classes << "selected" if variant.description == current_user.user_info.shoes_size.to_s
      end
    end
    classes.join(" ")
  end
end
