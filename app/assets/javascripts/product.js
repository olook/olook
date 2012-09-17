$(document).ready(function() {
  initProduct.showCarousel();
  initProduct.pinProduct();

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

  $("div#carousel ul.products_list").carouFredSel({
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
});

initProduct = {
  checkRelatedProducts : function() {
    return $("div#related ul.carousel").size() > 0 ? true : false;
  },

  showCarousel : function() {
    if(initProduct.checkRelatedProducts() == true) {
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
    }
  },

  pinProduct : function() {
    $("ul.social li.pinterest a").live("click", function(e) {
      var width  = 710,
          height = 545,
          left   = ($(window).width()  - width)  / 2,
          top    = ($(window).height() - height) / 2,
          url    = this.href,
          opts   = 'status=1' +
                   ',width='  + width  +
                   ',height=' + height +
                   ',top='    + top    +
                   ',left='   + left;

      window.open(url, 'pinterest', opts);
      e.preventDefault();
    });
  }
}
