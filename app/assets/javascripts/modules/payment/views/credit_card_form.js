app.views.CreditCardForm = Backbone.View.extend({
  className: 'creditCardForm',
  template: _.template($("#tpl-credit-card-form").html()),

  initialize: function() {
    olookApp.subscribe('payment:creditcard', this.render, {}, this);
  },

  events: {
  },

  render: function() {
    var html = this.template();
    this.$el.html(html);
  }

});
