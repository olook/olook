app.views.CreditCardForm = Backbone.View.extend({
  className: 'creditCardForm',
  template: _.template($("#tpl-credit-card-form").html()),

  initialize: function() {
    olookApp.subscribe('payment:creditcard:show', this.render, {}, this);
    olookApp.subscribe('payment:creditcard:hide', this.hide, {}, this);
  },

  events: {
  },

  render: function(model) {
    var html = this.template();
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  }

});
