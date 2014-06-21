//= require plugins/change_picture_onhover
//= require plugins/spy

$(function(){
  olook.init();
  olook.spy('.spy');
});

o = olook;

$(function(){
  new ImageLoader().load('look_thumbnail');
  olook.changePictureOnhover('.async');
});
