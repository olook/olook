$(document).ready(function() {
  initProduct.showCarousel();

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
         _gaq.push(['_trackEvent', 'product_show','open_showroom' ]);

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
  
  if($('#compartilhar_email').length == 1) {
     var content = $('#compartilhar_email'), h = content.height() + 70, w = content.width() + 70;
     $("ul.social li.email").click(function(e){
        e.preventDefault();
        e.stopPropagation();
        initBase.newModal(content, h, w);
     });
  }
  
  
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
  }
}
