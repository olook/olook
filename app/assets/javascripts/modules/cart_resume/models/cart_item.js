//= require parameterize
app.models.CartItem = Backbone.Model.extend({
  colorClass: function () {
    var color = this.get('color');
    return URLify(color);
  }
});
