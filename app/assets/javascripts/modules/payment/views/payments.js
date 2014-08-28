app.views.Payments = Backbone.View.extend({
  template: _.template($('#tpl-payment-list').html()||""),
  className: 'payments',
  initialize: function(opts) {
    this.cart = opts['cart'];
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('payment:selected', this.paymentSelected, this);
  },
  addOne: function(payment){
    var paymentView = new app.views.Payment({model: payment});
    this.$el.append(paymentView.render().el);

    var paymentMethod = this.cart.get('payment_method');
    if(paymentMethod == payment.attributes.type){ 
      paymentView.selectPayment();
    }
  },
  addAll: function(){
    this.collection.forEach(this.addOne, this);
  },
  remove: function() {
    Backbone.View.prototype.remove.apply(this, arguments); //super()
    this.paymentDetails.remove();
  },
  render: function(){
    this.$el.html(this.template({}));
    this.paymentDetails = this.$el.find('.payment-details');
    this.selectedAddress = this.$el.find('.js-selectedAddress');

    this.addAll();
    this.$el.after(this.paymentDetails); 
  },

  paymentSelected: function(model) {
    this.$el.find('.selected').removeClass('selected');
    olookApp.publish('payment:selected', model);
  }
});
