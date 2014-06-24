/**
 * Represents an Address
 */
var Address = Backbone.Model.extend({

  /**
   * Cidade e cep sao obrigatorios
   * @param  {[hash]} attr
   * @return {[boolean]} false is is valid, a hash otherwise
   */
  validate: function(attr) {
    errors = [];

    if (!attr.city) {
      errors.push({name: 'city', message: 'Cidade é obrigatória'});
    }
    
    if (!attr.zip_code) {
      errors.push({name: 'zip_code', message: 'CEP é obrigatório'});
    }


    return errors.length > 0 ? errors : false;
  }
});



var AddressList = Backbone.Collection.extend({
  model: Address,
  url: '/api/v1/addresses',

  initialize: function() {
    this.bind('remove', this.onModelRemoved, this);
  },

  onModelRemoved: function (model, collection, options) {
    console.log("[remove] options = ", options);
    model.destroy();
  }


});