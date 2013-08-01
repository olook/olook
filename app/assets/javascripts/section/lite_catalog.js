//= require plugins/slider
//= require plugins/spy
//= require plugins/toggle_class_slide_next
//= require plugins/custom_select
var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 600;
  olook.slider('#slider-range', start_position, final_position);
  olook.spy('p.spy');
  olook.spy('a.product_link');
  olook.customSelect(".custom_select");
  olook.toggleClassSlideNext(".title-category");
}

$(filter.init);
