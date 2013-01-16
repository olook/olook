module Checkout::CheckoutHelper

  def errors_for(object, field)
    errors = object.errors.messages[field].first
    %(<span class="span_error">&nbsp;#{errors}</span>).html_safe
  end

  def error_class_if_needed(object, field)
    object.errors.messages[field].empty? ? "" : "input_error"
  end

end