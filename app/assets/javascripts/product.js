$(document).ready(function() {
  var stringDesc = $("div#infos div.description p").not(".price").text();
  initProduct.sliceDesc(stringDesc);

  $("#product div.box_carousel a.open_carousel").live("click", function () {
    word = $(this).find("span");
    carousel = $(this).parent().find("div#carousel");
    if($(this).hasClass("open") == true) {
      $(carousel).animate({
        height: '0px'
      }, 'fast');
      $(this).removeClass("open");
      $(word).text("Abrir");
    } else{
      $(carousel).animate({
        height: '280px'
      }, 'fast');
      $(this).addClass("open");
      $(word).text("Fechar");
    }
  });

  $("div#infos div.description p[class!='price'] a.more").live("click", function() {
    el = $(this).parent();
    el.text(stringDesc);
    el.append("<a href='javascript:void(0);' class='less'>Esconder</a>");
  });

  $("div#infos div.description p[class!='price'] a.less").live("click", function() {
    initProduct.sliceDesc(stringDesc);
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
    width: 760,
    items: 10,
    prev : {
      button : ".product-prev",
      items : 4
    },
    next : {
      button : ".product-next",
      items : 4
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

  $("#add_item").submit(function(event) {
    initBase.openDialog();
    $('body .dialog').show();
    $('body .dialog').css("left", (viewWidth - '930') / 2);
    $('body .dialog').css("top", (viewHeight - '515') / 2);
    $('body .dialog #login_modal').fadeIn('slow');
    initBase.closeDialog();
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
