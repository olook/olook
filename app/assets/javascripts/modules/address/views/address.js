app.views.Address = Backbone.View.extend({
  model: app.models.Address,
  // events: {
  //   'click js-changeAddress': 'test'
  // },

  // test: function(e) {
  //   alert('oeee');
  // },
  
  initialize: function() {
    /*
      To use {{ variable }} on the templates
     */
    _.templateSettings = {
      interpolate: /\{\{(.+?)\}\}/g
    };
    this.template = _.template($("#address-template").html());

    /*
      Events
     */
    this.model.on('destroy', this.remove, this);
  },

  render: function() {
    var dict = this.model.toJSON();
    var html = this.template(dict);
    this.$el.html(html);
  },

  remove: function() {
    this.$el.remove();
  }
});