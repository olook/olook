app.models.CurrentCart = Backbone.Model.extend({
  urlRoot: app.server_api_prefix + '/current_cart',
  fullAddress: function() {
    var address = this.get('address');
    if(!address) return "";
    return
    address['street'] + ", " +
    address['number'] + " - " +
    address['neighborhood'] + ", " +
    address['city'] + "-" +
    address['state'] + ".";
  },
  itemsCount: function() {
    var dt = this.get('items_count');
    if(dt == 1) {
      return dt + " item";
    } else {
      return dt + " itens";
    }
  },

});
