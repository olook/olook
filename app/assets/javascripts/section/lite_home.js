//= require modernizr.custom.17475
//= require jquerypp.custom
//= require jquery.elastislide
//= require plugins/change_picture_onhover
//= require_tree ../modules/home


initHome = function(){
  olook.carousel();
  olook.changePictureOnhover('.look_thumbnail');
  new ImageLoader().load('look_thumbnail');
  new ImageLoader().load('highlight');


  new HomeEvents().config();
  setTimeout(function(){
    olookApp.publish('home:load');
  }, 1000);

  $(".looks_logged .js-thumbnail").click(function(e){
    log_event('click', 'logged_looks', {'productId': $(this).data().id});
  });
  $('.looks_logged .elastislide-list li').click(function(e){
    log_event('click', 'logged_products', {'productId': $(this).data().id});
  });

  $(".looks_unlogged .js-thumbnail").click(function(e){
    log_event('click', 'unlogged_looks', {'productId': $(this).data().id});
  });
  $('.looks_unlogged .elastislide-list li').click(function(e){
    log_event('click', 'unlogged_products', {'productId': $(this).data().id});
  });

};

olook.carousel = function() {
  $('#carousel').elastislide();
}

window.addEventListener('load', initHome);

