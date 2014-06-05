var AddToWishlist = (function(){
  function AddToWishlist(){};

  AddToWishlist.prototype.facade = function(productId) {

    var action_url = '/wished_products';

    var element = $('[name="variant[id]"]:checked');
    if (element.size() == 0) {
      olookApp.publish("wishlist:add:error_message", "Qual é o seu tamanho mesmo?");
    } else {
      var values = {'variant_id': element.val()}
      $.post(action_url, values, function(data) {
          olookApp.publish("wishlist:add:success_message", data.message);
        }).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar/1';
          }
        });
    }
  };

  AddToWishlist.prototype.config = function(){
    olookApp.subscribe('wishlist:add:click_button', this.facade, {}, this);
  };

  return AddToWishlist;
})();