app.views.Freights = Backbone.View.extend({
  initialize: function() {
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
  },
  addOne: function(freight){
    var freightView = new app.views.Freight({model: freight});
    this.$el.append(freightView.render().el);
  },
  addAll: function(){
    this.$el.html('');
    this.collection.forEach(this.addOne, this);
  },
  render: function(){
    this.addAll();
  }
});
