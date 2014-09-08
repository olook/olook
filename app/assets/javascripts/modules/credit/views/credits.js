app.views.Credits = Backbone.View.extend({
  className: 'credits',
  template: _.template($("#tpl-credits").html() || ""),
  initialize: function() {
    this.model.on("change", this.render, this);

  },
  events: {
    'click': 'selectCredits'
  },
  render: function(){
    var html = this.template(this.model.attributes);
    this.$el.html(html);
    if(this.model.get('use_credits') == true){
      this.$el.find('input[type=checkbox]').attr('checked','checked');
    } else {
      this.$el.find('input[type=checkbox]').removeAttr('checked');
    }
  },
  selectCredits: function(){
    this.model.set("use_credits", this.$el.find('input[type=checkbox]').is(':checked'));
    this.model.save();
  }
});
