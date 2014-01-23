// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require plugins/change_picture_onhover
$(function() {
  olook.changePictureOnhover('.async');
  new ImageLoader().load('async');


  $('.js-imgAddToCart').click(function(e){

    var it = $(this);
    var cartId = it.data('cart-id');
    var variantId = it.data('variant');
    
    if (it.hasClass('added_product')) {
      return false;
    }

    $.ajax({
        'type': 'put',
        'url': '/sacola/' + cartId,
        'data': {'variant_numbers[]': variantId},
        'success': function(data) {
          // triggers an event to update the minicart and change the class of the product added
            it.removeClass('add_product').addClass('added_product').text('Adicionado');
          }
        });

  });


  $('.js-removeFromWishlistButton').click(function(e){
    var it = $(this);
    var productId = it.data('product-id');
    olookApp.mediator.publish(RemoveFromWishlist.name, productId);
    e.preventDefault();
  });

});

/*** Wishlist Add Cart Button ***/

$('.img').on(
  {
    mouseover: function() {
      $(this).find('.js-imgAddToCart').show();
      $(this).find('img').css('opacity', '0.65');
    },
    mouseleave: function() {
      $(this).find('.js-imgAddToCart').hide();
      $(this).find('img').css('opacity', '1');
    }
  }
);