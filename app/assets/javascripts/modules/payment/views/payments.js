app.views.Payments = Backbone.View.extend({
  className: 'payments',
  initialize: function() {
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
  },
  addOne: function(payment){
    var paymentView = new app.views.Payment({model: payment});
    this.$el.append(paymentView.render().el);
  },
  addAll: function(){
    this.empty();
    this.collection.forEach(this.addOne, this);
  },
  empty: function() {
    this.$el.empty();
  },
  render: function(){
    this.addAll();
  }
});
