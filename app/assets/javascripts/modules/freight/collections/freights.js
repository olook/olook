app.collections.Freights = Backbone.Collection.extend({
  model: app.models.Freight,
  url: app.server_api_prefix + '/freights'
});
