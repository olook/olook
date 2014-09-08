app.collections.Payments = Backbone.Collection.extend({
  model: app.models.Payment,
  url: app.server_api_prefix + '/payment_types',

  findByPaymentMethod: function(method){
    return _.find(this.models, function(model){
      return model.get("type") == method;
    });
  }
});
