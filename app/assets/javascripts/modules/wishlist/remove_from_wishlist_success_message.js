var RemoveFromWishlistSuccessMessage = (function(){
  function RemoveFromWishlistSuccessMessage(){};
  RemoveFromWishlistSuccessMessage.prototype.facade = function(productId) {
    // product-page
    $('#js-removeFromWishlistButton').fadeOut();
    $('#js-addToWishlistButton').fadeIn();

    // wishlist page
    $('.js-product-' + productId).fadeOut();
    $('.js-product-' + productId).remove();

    if ($('.product').size() == 0) {
      $('.noProductWished').show();
    }

    if($(".js-full-wishlist-box").size() == 1 && parseInt($(".js-product-count").text()) == 1){
      $('.js-full-wishlist-box').addClass('wishlist').removeClass('wishlistHasProduct').removeClass('js-full-wishlist-box').addClass('js-empty-wishlist-box');
      $('.js-sub-text').html("Você ainda não adicionou nenhum<br />produto a sua lista de favoritos.");
    }else if($(".js-full-wishlist-box").size() == 1 && parseInt($(".js-product-count").text()) > 1){
      $(".js-product-count").text(parseInt($(".js-product-count").text()) - 1);
    }
  };

  RemoveFromWishlistSuccessMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:remove:success_message", this.facade, {}, this);
  };

  return RemoveFromWishlistSuccessMessage;
})();
