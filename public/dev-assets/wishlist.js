if(!visualization_mode) var visualization_mode = "product";
if(!olook) var olook = {};
olook.changePictureOnhover = function(selector, hover_picture) {
  if(!hover_picture){
    hover_picture = 'backside-picture';
  } else {
    hover_picture = 'hover';
  }
  $(selector).mouseenter(function() {
    var it;
    if($(this).is('img')){
      it = $(this);
    }else{
      it = $(this).children('img:first');
    }
    if(!it.data('original')){
      it.data('original', it.attr('src'));
    }
    it.attr('src', it.data(hover_picture));
  }).mouseleave(function() {
    var it;
    if($(this).is('img')){
      it = $(this);
    }else{
      it = $(this).children('img:first');
    }
    it.attr('src', it.data('original'));
  });
};
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  olook.changePictureOnhover('.async');
  new ImageLoader().load('async');


  $('.js-imgAddToCart').click(function(e){
    var it = $(this);
    var cartId = it.data('cart-id');
    var variantId = it.data('variant');
    var productId = it.data('product-id');

    var imageUrl = $(this).parent().find('.async').data('product').replace("catalog", "thumb");
    var quantity = "1";
    var size = $(this).parent().parent().find('ul li').html().trim();
    var price = $(this).parent().parent().find('.value').html().trim();
    var cartName = $(this).parent().parent().find('#cart_name').html().trim();

    if (it.hasClass('added_product') || it.hasClass('soldOut')) {
      e.preventDefault();
      return false;
    }
    
    _gaq.push(['_trackEvent', 'wishlist', 'add', productId, , true]);

    $.ajax({
        'type': 'put',
        'url': '/sacola/' + cartId,
        'data': {'variant_numbers[]': variantId},
        'success': function(data) {
          if($(".empty_cart").size() > 0){
            $("#cart_summary .scroll ul").html("");
            $(".cart").addClass("full");

          }
          $("#cart_summary .scroll ul").prepend("<li data-id='"+variantId+"' class='product_item'><img title='"+cartName+"' src='"+imageUrl+"'><h1>"+cartName+"</h1><p class='size'>Tamanho: "+size+"</p><p class='qte'>Quantidade:<span>1</span></p><p class='price'>"+price+"</p></li>");
          var cartItemNumber = parseInt($(".cart span #cart_items").html().replace("itens","").replace("item","").trim()) + 1;
          var cartItemText = cartItemNumber+" "+(cartItemNumber == 1 ? "item" : "itens");
          $(".cart span #cart_items").html(cartItemText);
          // triggers an event to update the minicart and change the class of the product added
            it.removeClass('add_product').addClass('added_product').text('Adicionado');
          }
        });
  });

  if ($('.product').size() == 0) {
    $('.noProductWished').show();
  }

  $('.js-removeFromWishlistButton').click(function(e){
    var it = $(this);
    var productId = it.data('product-id');
    _gaq.push(['_trackEvent', 'wishlist', 'remove', productId, , true]);

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
