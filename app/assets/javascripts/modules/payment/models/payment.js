app.models.Payment = Backbone.Model.extend({
  defaults:{
    name: null,
    percentage: null,
    description: null
  },
  urlRoot: app.server_api_prefix + "/payment_types"
});
