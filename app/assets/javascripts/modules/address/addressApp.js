
$(function () {
  var address = new Address();
  var addressList = new AddressList();
  addressList.fetch();

  var addressListView = new AddressListView({collection: addressList});
  var form = new App.AddressFormView({model: address, collection: addressList});
    
  $('#addressApp').html(addressListView.el);

});