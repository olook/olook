app.views.Debit = Backbone.View.extend({
  className: 'debit',
  template: _.template($("#tpl-debit").html() || ""),

  initialize: function(opts) {
    olookApp.subscribe('payment:debit:show', this.render, {}, this);
    olookApp.subscribe('payment:debit:hide', this.hide, {}, this);
    this.cart = opts['cart'];
  },

  events: {
    "change [name=bank]": "changeBank"
  },

  render: function(model) {
    var html = this.template(model.attributes);
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  },

  changeBank: function() {
    var bank = this.$el.find('[name=bank]:checked').val();
    this.cart.set('payment_data', { bank: bank });
  }

});
