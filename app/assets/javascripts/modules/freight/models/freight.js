app.models.Freight = Backbone.Model.extend({
  urlRoot: app.server_api_prefix + "/freights",
  formatted_delivery_time: function() {
    var dt = this.get('delivery_time');
    if(dt == 1) {
      return dt + " dia";
    } else {
      return dt + " dias";
    }
  },

  formatted_price: function() {
    var price = this.get('price');
    var intprice = parseInt(price);
    var centsprice = Math.round(( price - intprice ) * 100);
    return "R$ " + intprice + "," + centsprice;
  },

  toTpl: function() {
    return $.extend({}, this.attributes, {
      delivery_time: this.formatted_delivery_time(),
      price: this.formatted_price(),
    })
  }
});
