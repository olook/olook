app.views.MercadoPago = Backbone.View.extend({
  className: 'billet',
  template: _.template($("#tpl-mercadopago").html()),

  initialize: function() {
    olookApp.subscribe('payment:mercadopago:show', this.render, {}, this);
    olookApp.subscribe('payment:mercadopago:hide', this.hide, {}, this);
  },

  events: {
  },

  render: function(model) {
    var html = this.template(model.attributes);
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  }

});
