# -*- encoding : utf-8 -*-
class CouponPresenter < BasePresenter

  def show_total_discount
    if fixed_value_coupon?
      h.number_to_currency(-1 * coupon.action_parameter.action_params[:param].to_f)
    end
  end

  def show_line_item_discount_for item
    if item.has_adjustment?
      if !fixed_value_coupon?
        h.link_to promotion_discount(item), "#", :class => 'discount_percent'
      else
        h.link_to h.number_to_currency(value_discount(item)), "#", :class => 'discount_value'
      end
    end
  end

  def show_markdown_for? item
    !fixed_value_coupon? || item.price != item.retail_price(avoid_ajustment: true)
  end

  def show_subtotal(item)
    if item.has_any_discount? && show_markdown_for?(item)
      h.concat(h.content_tag(:p, "de: #{h.number_to_currency(item.price * item.quantity)}", class: 'price_retail'))
      h.concat(h.content_tag(:p, "por: #{h.number_to_currency(item.retail_price(avoid_ajustment: fixed_value_coupon?) * item.quantity)}"))
      nil
    else
      retail_price_to_show = item.retail_price({avoid_ajustment: fixed_value_coupon?}) * item.quantity
      h.content_tag(:p, h.number_to_currency( retail_price_to_show), :id => "item_subtotal_#{item.id}")
    end
  end


  private
    def fixed_value_coupon?
      coupon && coupon.promotion_action.is_a?(ValueAdjustment)
    end

    def value_discount(item)
      item.adjustment_value
    end

    def promotion_discount(item)
      percent = ( 1 - ( item.retail_price(avoid_ajustment: fixed_value_coupon?) / item.price )  ) * 100.0
      percent == 100 ? "Grátis" : h.number_to_percentage(percent, :precision => 0)
    end
end
