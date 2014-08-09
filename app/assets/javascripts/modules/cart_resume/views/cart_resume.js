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
    this.model.on("change:payment_data", this.render, this);
  },


  render: function() {
    this.$el.html(this.template(this.model.toTemplate()));
    this.addAllItems();
    if(this.model.stepValid()){
      this.$el.find("#js-finalize-order").removeClass("disabled");
    } else if(!$("#js-finalize-order").hasClass("disabled")){
      $("#js-finalize-order").addClass("disabled");
    }
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
