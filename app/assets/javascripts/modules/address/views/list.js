app.views.List = Backbone.View.extend({
  tagName: 'ul',

  events: {
    'click .zip': 'remove',
    'click .js-changeAddress': 'changeAddress'
  },  
  initialize: function() {
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('change', this.update, this);
  },
  addOne: function(address) {
    var addressView = new app.views.Address({model: address});
    addressView.render();
    this.$el.append(addressView.el);
  },
  addAll: function() {
    this.collection.forEach(this.addOne, this);
  },
  update: function(){
    this.collection.fetch();
    this.render();
  },
  render: function(){
    this.$('.js-addAddress').empty();
    // this.$el.$("ul").empty();
    this.addAll();
  },

  remove: function(e) {
    var id = e.target.id;
    var modelToDestroy = this.collection.get(id);
    this.collection.remove(modelToDestroy);
  },

  changeAddress: function(e) {
    app.views.form().showForm(e,true);
  },


})