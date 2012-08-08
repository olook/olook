$(document).ready(function() {
  ShowroomInit.slideProductAnchor();

  $("section#greetings div.facebook h1 a").live("click", function(e) {
    e.preventDefault();
  });

  $("section#greetings div.facebook h1 a").hover(function() {
    $("section#greetings div.facebook div.profile").show();
  }, function() {
    $("section#greetings div.facebook div.profile").hide();
  });

  $("section#greetings div.facebook div.profile").hover(function() {
    $("section#greetings div.facebook div.profile").show();
  }, function() {
    $("section#greetings div.facebook div.profile").hide();
  });

  $("#showroom div.products_list a.more").live("click", function() {
    click = $(this);
    el = $(this).attr('rel');
    box = $(this).parents('.type_list').find("."+el);
    var url = $(this).data('url');
    if(box.is(":visible") == false) {
      $("<div class='loading'></div>").insertBefore($(this));
      if ($(this).hasClass("loaded") == false) {
        $.getScript(url).done(function() {
          box.slideDown(1000);
          container_position = $(box).position().top;
          ShowroomInit.slideToProductsContainer(container_position);
          $("div.loading").remove();
          $(click).addClass("loaded");
          try{
            FB.XFBML.parse();
          }catch(ex){}
        });
      } else {
        box.slideDown(1000);
        container_position = $(box).position().top;
        ShowroomInit.slideToProductsContainer(container_position);
        $("div.loading").remove();
      }
  } else {
      box.slideUp(1000);
      topBox = $(this).parent(".products_list");
      container_position = $(topBox).position().top;
      ShowroomInit.slideToProductsContainer(container_position);
    }
  });

  $("div.facebook.connected ul").carouFredSel({
    height: 40,
    width: 540,
    align: 'left',
    auto: false,
    prev : {
      button : ".carousel-prev-fb",
    },
    next : {
      button : ".carousel-next-fb",
    }
  });

  $("div#mask_carousel_showroom ul").carouFredSel({
    height: 186,
    auto : {
      pauseDuration : 15000
    },
    prev : {
      button : ".carousel-prev",
      key : "left"
    },
    next : {
      button : ".carousel-next",
      key : "right"
    }
  });

  if($('.dialog.didi').length == 1) {
    var clone = $('.dialog.didi').clone().addClass('clone');
    var content = clone[0].outerHTML;
    initBase.modal(content);
    $("html, body").animate({
      scrollTop: 0
    }, 'slow');
  }

  if($('.dialog.liquidation').length == 1) {
    var clone = $('.dialog.liquidation').clone();
    var content = clone[0].outerHTML;
    initBase.modal(content);
  }

  $(".dialog.liquidation :checkbox").live("change", function() {
    checked = $(this).is(":checked");
    $.post("/user_liquidations", { 'user_liquidation[dont_want_to_see_again]': checked });
  });

  $(".didi.dialog :checkbox").live("change", function() {
    checked = $(this).is(":checked");
    $.post("/user_notifications", { 'user_notification[dont_want_to_see_again]': checked });
  });
});

ShowroomInit = {
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

