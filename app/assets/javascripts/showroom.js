$(document).ready(function() {
  ShowroomInit.updateListSize();
  ShowroomInit.slideProductAnchor();

  $("#showroom div.products_list a.more").live("click", function() {
    el = $(this).attr('rel');
    box = $(this).parents('.type_list').find("."+el);
    if(box.is(":visible") == false) {
      box.slideDown();
      container_position = $(box).position().top;
      ShowroomInit.slideToProductsContainer(container_position);
    } else {
      box.slideUp();
      topBox = $(this).parent(".products_list");
      container_position = $(topBox).position().top;
      ShowroomInit.slideToProductsContainer(container_position);
    }
  });

  $("div#mask_carousel_showroom ul").jcarousel({
    scroll: 1
  });

  $("section#greetings.christmas a.gift").live("click", function() {
    width = $(document).width();
    height = $(document).height();
    viewWidth = $(window).width();
    viewHeight = $(window).height();
    imageW = $('.dialog.christmas img').width();
    imageH = $('.dialog.christmas img').height();

    $('body').prepend("<div class='overlay'></div>");
    $('.overlay').width(width).height(height);
    $(".dialog.christmas").show();
    $(".dialog.christmas img").animate({
      width: 'toggle',
      height: 'toggle'
    });

    $('body .dialog.christmas').css("left", (viewWidth - '800') / 2);
    $('body .dialog.christmas').css("top", (viewHeight - '600') / 2);

    $('.dialog.christmas img').fadeIn('slow');

    $('.dialog.christmas img, .overlay, .dialog.christmas #close_dialog').click(function(){
      $('.dialog.christmas, .overlay').fadeOut('slow', function(){
        $('.dialog.christmas, .dialog.christmas img, .overlay').hide();
      });
    });
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
      }, 'slow');
    }
  },

  slideToProductsContainer : function(container_position) {
    position = container_position - 100;
    $("html, body").animate({
      scrollTop: position
    }, 'fast');
  }
};
