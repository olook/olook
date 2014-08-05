app.views.Address = Backbone.View.extend({
  tagName: 'li',
  model: app.models.Address,
  template: _.template($("#tpl-address").html() || ""),
  events: {
    'click input[type=radio]': 'selectAddress',
    'click li:not(.links)': 'selectAddress',
    'click .js-changeAddress': 'changeAddress',
    'click .js-removeAddress': 'removeAddress',
  },
  initialize: function() {
    /*
      Events on model callbacks
     */
    this.model.on('destroy', this.remove, this);
    this.model.on('change', this.render, this);
  },

  render: function() {
    var html = this.template(this.model.attributes);
    this.$el.html(html);
    if(this.model.get('selected')) {
      this.selectAddress();
    }
  },

  remove: function() {
    this.$el.remove();
  },

  changeAddress: function() {
    olookApp.publish('address:change', this.model);
    $("#save-btn").val("Alterar Endereço");
  },

  removeAddress: function() {
    olookApp.publish('address:remove', this.model);
    this.model.destroy();
  },

  selectAddress: function() {
    this.$el.find('input[type=radio]').not(':checked').attr('checked', 'checked');
    olookApp.publish('address:selected', this.model);
  }
});
