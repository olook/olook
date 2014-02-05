//= require plugins/custom_select
//= require plugins/slider
//= require plugins/spy
//= require plugins/change_picture_onhover
//= require plugins/video_modal

var cts = {} || null;
cts = {
  init: function(){
    if(typeof start_position == 'undefined') start_position = 0;
    if(typeof final_position == 'undefined') final_position = 600;
    olook.slider('#slider-range', start_position, final_position);
    olook.customSelect('.filter select');
    olook.spy('p.spy');
    olook.changePictureOnhover('.async');
    olook.videoModal('.video_link');
    cts.showSelectUl();
    cts.hideSelectUlOnBodyClick();
  },
  showSelectUl: function(){
    $("span.txt-filter").click(function(event){
      $(this).parent().siblings().find("ul, .tab_bg").hide();
      $(this).parent().siblings().find("span.txt-filter.clicked").removeClass("clicked");
      $(this).toggleClass('clicked').siblings().toggle();
      event.stopPropagation();
    });
  },
  hideSelectUlOnBodyClick: function(){
    $("html").click(function(){
      if($(".filter ul").is(":visible")){
        $(".filter ul:visible, .filter .tab_bg:visible").hide();
        $(".filter span.txt-filter.clicked").removeClass("clicked");
      }
    });
  }
}
$(function() {
  cts.init();
  $(".container-imgs ul").carouFredSel({
    auto: {
      duration: 1000
    },
    prev : {
      button : ".anterior",
      key : "left"
    },
    next : {
      button : ".proximo",
      key : "right"
    }
  });
});
