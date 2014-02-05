//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide
//= require plugins/change_picture_onhover


initHome = function(){
  olook.carousel();
  olook.changePictureOnhover('.look_thumbnail');
  new ImageLoader().load('look_thumbnail');
};

olook.carousel = function() {
  $('#carousel').elastislide();
}

window.addEventListener('load', initHome);
