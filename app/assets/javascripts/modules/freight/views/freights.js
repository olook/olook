app.views.Freights = Backbone.View.extend({
  template: _.template($('#tpl-freights').html() || ""),
  className: 'freights',
  initialize: function(opts) {
    olookApp.subscribe('address:change', this.remove, {}, this);
    olookApp.subscribe('address:remove', this.removeAddress, {}, this);
    olookApp.subscribe('address:add', this.remove, {}, this);
    olookApp.subscribe('address:selected', this.checkShipping, {}, this);
    olookApp.subscribe('freight:toggle_button', this.toggleButton, {}, this);
    this.cart = opts['cart'];
    this.collection.on('reset', this.render, this);
  },
  events: {
    'click .js-finishFreight': 'goToPayment'
  },  
  addOne: function(freight){
    var freightView = new app.views.Freight({model: freight});
    this.$el.find('h4').after(freightView.render().el);
  },
  addAll: function(){
    this.empty();
    this.collection.forEach(this.addOne, this);
  },
  setSelected: function() {
    var shipping_service_id = this.cart.get('shipping_service_id');
    this.collection.forEach(function(freight){
      if(freight.get('shipping_service_id') == shipping_service_id){
        freight.set('selected', true);
      }
    });
  },
  checkShipping: function() {
    if(this.cart.get('shipping_service_id') == null) {
      this.remove();
    }
  },
  empty: function(){
    this.$el.find('p').remove();
  },
  render: function(){
    this.$el.html(this.template({}));
    this.addAll();
    this.setSelected();
  },
  removeAddress: function(address) {
    if(address.get('selected')) {
      this.remove();
    }
  },

  hide: function() {
    this.$el.empty();
  },

  toggleButton: function() {
    if(this.cart.stepValid()){
      this.$el.find(".js-finishFreight").removeClass("disabled");
    } else if(!$(".js-finishFreight").hasClass("disabled")){
      $(".js-finishFreight").addClass("disabled");
    }  
  },

  goToPayment: function() {
    olookApp.publish("app:next_step");
  }
});
