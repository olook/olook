//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide
//= require plugins/change_picture_onhover
//= require_tree ../modules/home


initHome = function(){
  olook.carousel();
  olook.changePictureOnhover('.look_thumbnail');
  new ImageLoader().load('look_thumbnail');
  new HomeEvents().config();
  setTimeout(function(){
    olookApp.publish('home:load');
  }, 1000);

};

olook.carousel = function() {
  $('#carousel').elastislide();
}

window.addEventListener('load', initHome);

