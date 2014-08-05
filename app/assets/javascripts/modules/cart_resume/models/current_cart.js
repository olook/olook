app.models.CurrentCart = Backbone.Model.extend({
  url: app.server_api_prefix + '/current_cart',
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
  freightKind: function() {
    if(this.selectedFreight()) {
      return this.selectedFreight().pretty_kind();
    }
    return "";

  },
  freightDue: function() {
    if(this.selectedFreight())
      return this.selectedFreight().formatted_delivery_time();
    return "";
  },
  freightValue: function() {
    if(this.selectedFreight())
      return this.selectedFreight().formatted_price();
    return "";
  },
  selectedFreight: function() {
    var shipping_service_id = this.get('shipping_service_id');
    var selectedFreight = _.find(this.get('freights'), function(item) {
      return item.shipping_service_id == shipping_service_id;
    });
    return selectedFreight ? new app.models.Freight(selectedFreight) : null;
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
  stepValid: function() {
    var step = this.get('step');
    switch(step) {
      case "payment":
        return this.paymentStepValid();
      case "confirmation":
        return true;
      default:
        return this.addressStepValid();
    }
  },
  paymentStepValid: function() {
  },
  addressStepValid: function() {
    var ssi = this.get('shipping_service_id'), ai = this.get('address_id');
    return (parseInt(ssi) > 0 && parseInt(ai) > 0);
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
