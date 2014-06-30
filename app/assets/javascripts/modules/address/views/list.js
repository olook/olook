app.views.List = Backbone.View.extend({
  tagName: 'ul',

  events: {
    'click .zip': 'remove',
    'click .js-changeAddress': 'teste'
  },  
  initialize: function() {
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
  },
  addOne: function(address) {
    var addressView = new app.views.Address({model: address});
    addressView.render();
    this.$el.append(addressView.el);
  },
  addAll: function() {
    this.collection.forEach(this.addOne, this);
  },
  render: function(){
    this.addAll();
  },

  remove: function(e) {
    var id = e.target.id;
    var modelToDestroy = this.collection.get(id);
    this.collection.remove(modelToDestroy);
  },

  teste: function(a, b) {
    alert('oeeee');
  },


})