$(document).ready(function() {
  var stringDesc = $("div#infos div.description p").not(".price").text();
  initProduct.sliceDesc(stringDesc);

  $("div#infos div.description p[class!='price'] a.more").live("click", function() {
    $(this).parent().text(stringDesc);
  });

  $("div#pics_suggestions div#full_pic ul li a.image_zoom").jqzoom({
    zoomType: 'standard',
    zoomWidth: 415,
    zoomHeight: 500,
    imageOpacity: 0.4,
    title: false,
    preloadImages: true,
    fadeoutSpeed: 'fast'
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
  
  $("div#carousel ul").carouFredSel({
    auto: false,
    width: 600,
    items: 10,
    prev : {
      button : ".product-prev",
      items : 1
    },
    next : {
      button : ".product-next",
      items : 1
    }
  });

  $("div#related ul").carouFredSel({
    auto: false,
    width: 860,
    items: 3,
    prev : {
      button : ".carousel-prev",
      items : 3
    },
    next : {
      button : ".carousel-next",
      items : 3
    }
  });
});

initProduct = {
  sliceDesc : function(string) {
    if(string.length > 120) {
      el = $("div#infos div.description p").not(".price");
      descSliced = el.text(string.slice(0,120)+"...");
      el.append("<a href='javascript:void(0);' class='more'>Ler tudo</a>");
    }
  }
};
