$(document).ready(function() {
  //initLookbooks.updateListSize();

  $("div#carousel_lookbooks a.arrows").live("click", function () {
    list = $(this).siblings("ul");
    listSize = $(list).find("li").size();
    minWidth = (listSize-3)*(-326);
    atualPosition = parseInt($(list).css("left").split("px")[0]);
    if($(this).hasClass("next") == true) {
      if(atualPosition > minWidth) {
        $(list).stop().animate({
          left: atualPosition+(-326)+"px"
        }, 'fast');
      }
    } else {
      if(atualPosition < 0) {
        $(list).stop().animate({
          left: atualPosition+(326)+"px"
        }, 'fast');
      }
    }
    return false;
  });

  $("div#carousel_lookbooks_product ul").jcarousel({
    scroll: 1
  });
});

initLookbooks = {
  updateListSize :function() {
    listLookbooks = $("div#carousel_lookbooks ul");
    listLookbooksSize = $(listLookbooks).find("li").size()*326;
    $(listLookbooks).width(listLookbooksSize);
    listLookbookPics = $("div#carousel_lookbooks_product ul");
    listLookbookPicsSize = $(listLookbookPics).find("li").size()*970;
    $(listLookbookPics).width(listLookbookPicsSize);
  }
}
