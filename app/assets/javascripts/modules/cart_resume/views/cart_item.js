app.views.CartItem = Backbone.View.extend({
  tagName: 'tr',
  className: 'cart-item',
  template: _.template($("#tpl-cart-item").html() || ""),

  toTemplate: function() {
    return $.extend({}, this.model.attributes, {
      price_declaration: this.priceDeclaration(),
      color: this.model.colorClass(),
    });
  },

  priceDeclaration: function() {
    var price = parseFloat(this.model.get('price'));
    var retail_price = parseFloat(this.model.get('retail_price'));
    if(retail_price < price) {
      return _.template($("#tpl-cart-item-price-promotion").html() || "")({
        price: app.formatted_currency(price),
        retail_price: app.formatted_currency(retail_price)
      });
    } else {
      return app.formatted_currency(price);
    }
  },

  render: function() {
    this.$el.html(this.template(this.toTemplate()));
  },

});
