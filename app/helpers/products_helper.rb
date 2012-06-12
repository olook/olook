module ProductsHelper
  def variant_classes(variant, shoe_size = nil)
    classes = []
    if !variant.available_for_quantity?
      classes << "unavailable"
    else
      if shoe_size.nil? || shoe_size <= 0
        if !current_user.nil? && !current_user.user_info.nil? &&
          variant.description == current_user.user_info.shoes_size.to_s
            classes << "selected"
        end
      else
        classes << "selected" if variant.description.to_s == shoe_size.to_s
      end
    end
    classes.join(" ")
  end
end
