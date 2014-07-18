app.models.CurrentCart = Backbone.Model.extend({
  urlRoot: app.server_api_prefix + '/current_cart',
  attributesToServer: ['address_id', 'use_credits', 'facebook_share_discount',
    'shipping_service_id', 'payment_method', 'payment_data'],
  fullAddress: function() {
    var address = this.get('address');
    if(!address) return "";
    var fullAddress = [ address['street'], ", ",
    address['number'], " - ",
    address['neighborhood'], ", ",
    address['city'], "-",
    address['state'], "."];
    return fullAddress.join('');
  },
  stepLabel: function() {
    var step = this.get('step');
    switch(step) {
      case "payment":
        return "Finalizar Compra";
      case "confirmation":
        return "OK";
      default:
        return "Ir para pagamento";
    }
  },
  itemsCount: function() {
    var dt = this.get('items_count');
    if(dt == 1) {
      return dt + " item";
    } else {
      return dt + " itens";
    }
  },
  toJSON: function() {
    return _.object(_.map(this.attributesToServer, function(key) {
      return [key, this.get(key)];
    }, this));
  }
});
