app.views.Freights = Backbone.View.extend({
  initialize: function() {
    olookApp.subscribe('address:change', this.empty, {}, this);
    olookApp.subscribe('address:remove', this.empty, {}, this);
    olookApp.subscribe('address:add', this.empty, {}, this);
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
  },
  addOne: function(freight){
    var freightView = new app.views.Freight({model: freight});
    this.$el.append(freightView.render().el);
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
