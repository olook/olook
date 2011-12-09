$(document).ready(function() {
  ShowroomInit.updateListSize();

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

  $("div#mask_carousel_showroom a.arrows").live("click", function() {
    list = $(this).siblings("ul");
    listSize = $(list).find("li").size();
    minWidth = (listSize-1)*(-324);
    atualPosition = parseInt($(list).css("left").split("px")[0]);
    if($(this).hasClass("next") == true) {
      if(atualPosition > minWidth) {
        $(list).stop().animate({
          left: atualPosition+(-324)+"px"
        }, 'fast');
      }
    } else {
      if(atualPosition < 0) {
        $(list).stop().animate({
          left: atualPosition+(324)+"px"
        }, 'fast');
      }
    }
    return false;
  });
});

ShowroomInit = {
  updateListSize : function() {
    list = $("div#mask_carousel_showroom ul");
    listSize = $(list).find("li").size()*324;
    $(list).width(listSize);
  }
};
