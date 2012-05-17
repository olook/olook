$(document).ready(function() {
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
        height: '315px'
      }, 'fast');
      $(this).addClass("open");
      $(word).text("Fechar");
    }
  });

  $("div#carousel ul").carouFredSel({
    auto: false,
    width: 760,
    items: {
      visible: 4
      },
    prev : {
      button : ".product-prev",
      items : 4
    },
    next : {
      button : ".product-next",
      items : 4
    }
  });

  $("div#related ul.carousel").carouFredSel({
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
