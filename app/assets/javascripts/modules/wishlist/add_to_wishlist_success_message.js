var AddToWishlistSuccessMessage = (function(){
  
  function AddToWishlistSuccessMessage(){};

  AddToWishlistSuccessMessage.prototype.facade = function(message) {
    $('#js-addToWishlistButton').fadeOut();
    $('#js-removeFromWishlistButton').fadeIn();

    if($('.js-empty-wishlist-box').size() == 1){
      $('.js-empty-wishlist-box').addClass('wishlistHasProduct').removeClass('wishlist').removeClass('js-empty-wishlist-box').addClass('js-full-wishlist-box');
      $('.js-sub-text').html("Você possui <span class='js-product-count'>1</span> produto(s)<br />na sua lista de favoritos.");  
    } else if($(".js-full-wishlist-box").size() == 1 && $(".js-product-count").size() == 1){
      $(".js-product-count").text(parseInt($(".js-product-count").text()) + 1); 
    }
    
  };

  AddToWishlistSuccessMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:add:success_message", this.facade, {}, this);
  };

  return AddToWishlistSuccessMessage;

})();
