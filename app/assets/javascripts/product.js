$(document).ready(function() {
  initProduct.updateListSize();

  $("div#carousel a.arrow").live("click", function () {
    list = $(this).siblings(".mask").find("ul");
    listSize = $(list).find("li").size();
    minWidth = (listSize-11)*(-50);
    atualPosition = parseInt($(list).css("left").split("px")[0]);
    if($(this).hasClass("next") == true) {
      if(atualPosition > minWidth) {
        $(list).stop().animate({
          left: atualPosition+(-50)+"px"
        }, 'fast');
      }
    } else {
      if(atualPosition < 0) {
        $(list).stop().animate({
          left: atualPosition+(50)+"px"
        }, 'fast');
      }
    }
    return false;
  });

  $("div#pics_suggestions ul#thumbs li").each(function() {
    clazz = $(this).find("a").attr("class");
    parts = clazz.split("-");
    $("img.load-image-"+parts[2]).asynchImageLoader({event:'click', selector:'a.load-async-'+parts[2]});
  });

  $("div#pics_suggestions ul#thumbs li a").live("click", function() {
    rel = $(this).attr('rel');
    $("div#pics_suggestions div#full_pic ul li").hide();
    $("div#pics_suggestions div#full_pic ul li."+rel).show();
    return false;
  });

  $("div#box_tabs ul.tabs li a").live("click", function() {
    rel = $(this).attr("rel");
    $(this).parents("ul").find("li a").removeClass("selected");
    contents = $(this).parents("div#box_tabs").find("ul.tabs_content li");
    contents.removeClass("selected");
    $(this).addClass("selected");
    contents.each(function(){
      if($(this).hasClass(rel) == true) {
        $(this).addClass("selected");
      }
    });
    return false;
  });

  $("div#infos div.size ol li").live('click', function() {
    if($(this).hasClass("unavailable") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input").attr('checked', false);
      lists.removeClass("selected");
      $(this).find('input').attr('checked', true);
      $(this).addClass('selected');
      return false;
    }
  });
  
  $("div#pics_suggestions ul#thumbs li:first-child a").click();
  initProduct.zoomImg();
});

initProduct = {
  zoomImg : function() {
    $("div#pics_suggestions div#full_pic ul li a.image_zoom").jqzoom({
      zoomType: 'reverse',
      zoomWidth: 415,
      zoomHeight: 500,
      title: false,
      position: 'right'
    });
  },
  
  updateListSize : function() {
    list = $("div#carousel ul");
    listSize = $(list).find("li").size()*50;
    $(list).width(listSize);
  }
};
