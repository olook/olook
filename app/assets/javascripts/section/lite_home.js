//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide
//= require plugins/change_picture_onhover


initHome = function(){
  olook.carousel();
  olook.seeMore();
  olook.changePictureOnhover('.look_thumbnail');
  new ImageLoader().load('look_thumbnail');
};

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

window.addEventListener('load', initHome);
