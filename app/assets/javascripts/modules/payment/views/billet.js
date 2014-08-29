app.views.Billet = Backbone.View.extend({
  className: 'billet',
  template: _.template($("#tpl-billet").html() || ""),

  initialize: function(opts) {
    this.cart = opts["cart"];
    olookApp.subscribe('payment:billet:show', this.render, {}, this);
    olookApp.subscribe('payment:billet:hide', this.hide, {}, this);
  },

  events: {
  },

  attr: function(model) {
    var exp = new Date(model.get('billet_expiration'));
    return {
      billet_expiration: exp.getDate() + "/" + ( exp.getMonth() + 1 ) + "/" + exp.getFullYear(),
    };
  },

  render: function(model) {
    this.cart.trigger('change:payment_data');
    
    var html = this.template(_.extend(this.attr(model), {payment_discounts: app.formatted_currency(this.cart.get("payment_discounts") * -1)}));
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  },

});
