//= require plugins/slider
//= require plugins/spy
//= require plugins/new_modal
//= require plugins/toggle_class_slide_next
//= require plugins/custom_select
//= require plugins/change_picture_onhover
//= require plugins/jquery.meio.mask
//= require plugins/discount_price_updater

var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 600;
  olook.slider('#slider-range', start_position, final_position);
  olook.spy('p.spy');
  olook.changePictureOnhover('img.async');
  olook.customSelect(".custom_select");
  olook.toggleClassSlideNext(".title-category");
  olook.priceUpdater();
}

$(filter.init);
