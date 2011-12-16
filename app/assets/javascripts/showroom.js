$(document).ready(function() {
  ShowroomInit.updateListSize();
  ShowroomInit.slideProductAnchor();

  $("#showroom div.products_list a.more").toggle(function() {
    el = $(this).attr('rel');
    box = $(this).parents('.type_list').find("."+el);
    box.slideDown();
    },
    function() {
      el = $(this).attr('rel');
      box = $(this).parents('.type_list').find("."+el);
      box.slideUp();
    }
  );

  $("div#mask_carousel_showroom ul").jcarousel({
    scroll: 1
  });
});

ShowroomInit = {
  updateListSize : function() {
    list = $("div#mask_carousel_showroom ul");
    listSize = $(list).find("li").size()*324;
    $(list).width(listSize);
  },
  slideProductAnchor : function() {
    anchor = window.location.hash;
    container = $(anchor+"_container");
    if($(container).length > 0) {
      container_position = $(container).position().top;
      position = container_position - 40;
      $("html, body").animate({
        scrollTop: position
      }, 'fast');
    }
  }
};
