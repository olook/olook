//= require plugins/change_picture_onhover

$(function(){
  olook.changePictureOnhover('.look_thumbnail');
  new ImageLoader().load('look_thumbnail');
});
