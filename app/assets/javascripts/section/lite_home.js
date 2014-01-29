//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide
//= require plugins/change_picture_onhover


$(function(){
  olook.carousel();
  // olook.changePictureOnhover('a:has(img[data-hover])', 'hover')
});

olook.carousel = function() {
  $('#carousel').elastislide();
}
