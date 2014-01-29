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
  $('#carousel li, .look, .fav_product').on(
    {
      mouseover: function() {
        $(this).find('.seeMore').show();
      },
      mouseleave: function() {
        $(this).find('.seeMore').hide();
      }
    }
  );
}
