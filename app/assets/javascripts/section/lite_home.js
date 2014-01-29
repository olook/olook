//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide
//= require plugins/change_picture_onhover


$(function(){
  olook.carousel();
  olook.seeMore();
  // olook.changePictureOnhover('a:has(img[data-hover])', 'hover')
});

olook.carousel = function() {
  $('#carousel').elastislide();
}

olook.seeMore = function() {
  $('#carousel li a').on(
    {
      mouseover: function() {
        $(this).find('img').css('opacity', '0.65');
        $(this).find('.js-imgAddToCart').show();
      },
      mouseleave: function() {
        $(this).find('img').css('opacity', '1');
        $(this).find('.js-imgAddToCart').hide();
      }
    }
  );
}