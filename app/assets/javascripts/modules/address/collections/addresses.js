app.collections.Addresses = Backbone.Collection.extend({
  model: app.models.Address,
  url: app.server_api_prefix + '/addresses',
});
