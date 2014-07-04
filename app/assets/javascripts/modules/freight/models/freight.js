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
    if(centsprice < 10) {
      centsprice = "0" + centsprice;
    }
    return "R$ " + intprice + "," + centsprice;
  },

  pretty_kind: function() {
    switch(this.get('kind')) {
      case 'default':
        return 'Convencional';
      case 'fast':
        return 'Rápido';
      case 'motoboy':
        return 'A Jato';
    }
  },

  toTpl: function() {
    return $.extend({}, this.attributes, {
      pretty_kind: this.pretty_kind(),
      delivery_time: this.formatted_delivery_time(),
      price: this.formatted_price(),
    });
  }
});
