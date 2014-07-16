app.views.CartResume = Backbone.View.extend({
  className: 'cart_resume',
  template: _.template($("#tpl-cart-resume").html() || ""),
  // tagName: 'li',
  // model: app.models.Address,
  // events: {
  //   'click input[type=radio]': 'selectAddress',
  //   'click ul': 'selectAddress',
  //   'click .js-changeAddress': 'changeAddress',
  //   'click .js-removeAddress': 'removeAddress',
  // },
  // initialize: function() {
  //   /*
  //     Events on model callbacks
  //    */
  //   this.model.on('destroy', this.remove, this);
  //   this.model.on('change', this.render, this);
  // },

  render: function() {
    this.$el.html(this.template({
      full_address: "Rua Tanquinho, 64 - Tatuapé, São Paulo - SP 03080-040",
      freight_kind: "A Jato",
      freight_due: "3 horas",
      items_count: "3 itens",
      payment_method: "Cartão de Crédito",
    }));
  },

  // remove: function() {
  //   this.$el.remove();
  // },

  // changeAddress: function() {
  //   olookApp.publish('address:change', this.model);
  // },

  // removeAddress: function() {
  //   this.model.destroy();
  // },

  // selectAddress: function() {
  //   this.$el.find('input[type=radio]').not(':checked').attr('checked', 'checked');
  //   olookApp.publish('address:selected', this.model.attributes);
  // }
});
