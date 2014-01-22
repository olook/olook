// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require plugins/change_picture_onhover
$(function() {
  olook.changePictureOnhover('.async');
  new ImageLoader().load('async');
});

/*** Wishlist Add Cart Button ***/

$('.img').on(
  {
    mouseover: function() {
      $(this).find('.js-imgAddToCart').show();
    },
    mouseleave: function() {
      $(this).find('.js-imgAddToCart').hide();
    }
  }
);

$('.js-imgAddToCart').click(function(){
  var it = $(this);
  var cartId = it.data('cart-id');
  var variantId = it.data('variant');

  $.ajax({
      'type': 'put',
      'url': '/sacola/' + cartId,
      'data': {'variant_numbers[]': variantId},
      'success': function(data) {
        // triggers an event to update the minicart and change the class of the product added
            debugger;
            it.removeClass('add_product').addClass('added_product').text('Adicionado');
        }
      });

});