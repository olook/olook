app.views.CartResume = Backbone.View.extend({
  className: 'cart_resume',
  template: _.template($("#tpl-cart-resume").html() || ""),
  events: {
    "click .js-see-cart-items": "seeCartItems",
    "click .js-close-modal": "hideCartItems",
    "click button": "goToNextStep",
  },
  initialize: function() {
    this.overlay = $('<div id="overlay-modal-items"></div>');
    this.overlay.on('click', $.proxy(this.hideCartItems, this));
    this.model.on('change', this.render, this);
  },

  toTemplate: function() {
    return $.extend({}, this.model.attributes, {
      subtotal: app.formatted_currency(this.model.get('subtotal')),
      full_address: this.model.fullAddress(),
      items_count: this.model.itemsCount(),
      freight_kind: "A Jato",
      freight_due: "3 horas",
      payment_method: "Cartão de Crédito",
      step_label: this.model.stepLabel(),
    });
  },

  render: function() {
    this.$el.html(this.template(this.toTemplate()));
    this.addAllItems();
  },

  seeCartItems: function() {
    this.overlay.hide().prependTo("body").fadeIn();
    this.$el.find('.modal-items').fadeIn();
  },

  hideCartItems: function() {
    var over = this.overlay;
    over.fadeOut(function(){
      over.detach().show();
    });
    this.$el.find('.modal-items').fadeOut();
  },

  emptyItems: function() {
    this.$el.find('.modal-items table').empty();
  },

  addAllItems: function() {
    this.emptyItems();
    _.each(this.model.get('items'), this.addOneItem, this);
  },

  addOneItem: function(item_attr) {
    var item = new app.models.CartItem(item_attr);
    var view = new app.views.CartItem({model: item});
    view.render()
    view.$el.appendTo(this.$el.find('.modal-items table'));
  },

  goToNextStep: function() {
    if(this.model.stepValid()){
      olookApp.publish("app:next_step");
    }
  },

});
