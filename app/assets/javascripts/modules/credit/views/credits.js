app.views.Credits = Backbone.View.extend({
  className: 'loylat_credits',
  template: _.template($("#tpl-credits").html() || ""),
  initialize: function() {
    this.model.on("change", this.render, this);
  },
  events: {
    'click': 'selectCredits'
  },
  render: function(){
    var html = this.template(this.model.attributes);
    console.log(this.model.attributes)
    this.$el.html(html);
  },
  selectCredits: function(){
    this.model.set("use_credits", this.$el.find('input[type=checkbox]').is(':checked'));
    this.model.save();
  }
});
