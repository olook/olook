//= require plugins/slider
//= require plugins/spy
//= require plugins/new_modal
//= require plugins/toggle_class_slide_next
//= require plugins/custom_select
//= require plugins/change_picture_onhover
//= require plugins/jquery.meio.mask

var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 600;
  olook.slider('#slider-range', start_position, final_position);
  olook.spy('p.spy');
  olook.changePictureOnhover('.async');
  olook.customSelect(".custom_select");
  olook.toggleClassSlideNext(".title-category");

  $(".more_info_show").click(function(e){
    e.preventDefault();
      $(".summary,.more_info_show").css("display", "none");
      $(".full,.more_info_hide").css("display", "block");
  });

  $(".more_info_hide").click(function(e){
    e.preventDefault();
      $(".full,.more_info_hide").css("display", "none");
      $(".summary,.more_info_show").css("display", "block");
  });

  $("a.mercado_pago_button").click(function(e){
      content = $("div.mercado_pago");
      olook.newModal(content, 640, 800);
  });
}


$(filter.init);


loadThumbnails = function() {
  new ImageLoader().load("async");
}

window.addEventListener('load', loadThumbnails);
