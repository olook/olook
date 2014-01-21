// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require plugins/change_picture_onhover
$(function() {
  olook.changePictureOnhover('.async');
  new ImageLoader().load('async');
});
