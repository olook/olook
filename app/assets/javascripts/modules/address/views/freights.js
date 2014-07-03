app.views.Freights = Backbone.View.extend({
  render: function() {
    this.collection.forEach(this.addOne, this);
  },
  addOne: function(freight){
    var freightView = new app.views.Freight({model: freight});
    this.$el.append(freightView.render().el);
  }
});
