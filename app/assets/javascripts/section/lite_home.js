//= require jquery
//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide


$(function(){
  olook.carousel();
});

olook.carousel = function() {
  $('#carousel').elastislide();
}