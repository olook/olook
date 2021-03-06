app.models.CurrentCart = Backbone.Model.extend({
  url: app.server_api_prefix + '/current_cart',
  attributesToServer: ['address_id', 'use_credits', 'facebook_share_discount',
    'shipping_service_id', 'payment_method', 'payment_data'],

  toTemplate: function() {
    return $.extend({}, this.attributes, {
      subtotal: app.formatted_currency(this.get('subtotal')),
      items_subtotal: app.formatted_currency(this.get('items_subtotal')),
      payment_discounts: app.formatted_currency(this.get('payment_discounts')),
      hasPaymentDiscounts: this.get('payment_discounts') != 0,
      full_address: this.fullAddress(),
      items_count: this.itemsCount(),
      freight: this.freightValue(),
      freight_kind: this.freightKind(),     
      freight_due: this.freightDue(),
      payment_method: this.paymentName(),
      step_label: this.stepLabel(),
      gift_wrap_value: this.giftWrapCheckedValue(),
      hasGiftWrap: this.get('gift_wrap') != 0,
      credits: app.formatted_currency(this.get('credits')),
      hasCredits: this.get('credits') != 0,
      discounts: app.formatted_currency(this.get('discounts')),
      hasDiscounts: this.get('discounts') != 0,
      total: app.formatted_currency(this.get('total')),
    });
  },
  giftWrapCheckedValue: function() {
    if(this.get('gift_wrap')){
      return app.formatted_currency(this.get('gift_wrap_value'));
    }
    return app.formatted_currency(0);
  },
  paymentName: function() {
    var pay = this.payment();
    if (pay.get('name')) {
      return pay.get('name');
    }
    return '---';
  },
  payment: function() {
    return new app.models.Payment(this.get('payment'));
  },
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
    return "---";

  },
  freightDue: function() {
    if(this.selectedFreight())
      return this.selectedFreight().formatted_delivery_time();
    return "---";
  },
  freightValue: function() {
    if(this.selectedFreight()) 
      return this.selectedFreight().formatted_price();
    return "---";
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
    var payment_method = this.get('payment_method');

    switch(payment_method) {
      case "CreditCard":
        return (this.credit_card != undefined && this.credit_card.isValid());
      case "Debit":
        return (this.debit != undefined && this.debit.isValid());
      default:
        return (!StringUtils.isEmpty(payment_method));
    }

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
  },

  isEmpty: function() {
    return this.get('items_count') == undefined || this.get('items_count') == 0;
  }
});
