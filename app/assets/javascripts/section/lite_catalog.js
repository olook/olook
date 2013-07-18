//= require plugins/slider
//= require plugins/spy
var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 600;
  olook.slider('#slider-range', start_position, final_position);
  olook.spy('p.spy');
  filter.showSelectBoxText();
  filter.hideShow();
}
filter.showSelectBoxText = function(){
  var setText = function(e) {
    var txt = $('option:selected', e).text();
    $(e).prev().children("span").text(txt);
  }
  $(".custom_select").each(function(){
    setText(this);
    $(this).change(function(){
      setText(this);
    });
  });
}
filter.hideShow = function(){
  $(".title-category").each(function(){
    $(this).on("click", function(){
      $(this).toggleClass("close").next().slideToggle();
    })
  })
}


$(filter.init);
