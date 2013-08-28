//= require ./partials/_credits_info
$(function(){
  initProduct.loadAll();
});

initProduct = {
  checkRelatedProducts : function() {
    return $("div#related ul.carousel").size() > 0 ? true : false;
  },
  showAlert : function(){
    $('p.alert_size').show().html("Qual é o seu tamanho mesmo?") 
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
  loadAddToCartForm : function() {
    if($('#compartilhar_email').length == 1) {
      var content = $('#compartilhar_email');
      $("ul.social-list li.email").on("click", function(e){
        e.preventDefault();
        e.stopPropagation();
        initBase.newModal(content);
      });
    }
    $("#compartilhar_email form").submit(function(){
      $("input#send").addClass("opacidade").delay(300).attr('disabled', true);
    })

    $("a.open_loyalty_lightbox").show();

    $("form#product_add_to_cart").submit(function() {
      if ($('[name="variant[id]"]:checked').length == 0) {
        initProduct.showAlert();
        return false; 
      }
      return true;
    });

    $("#add_product").click(function(e){
      e.preventDefault;
    });

    $(".plus").click(function(){
      var variant = $('[name="variant[id]"]:checked');
      if (variant.length == 0) {
        initProduct.showAlert();
        return;
      }
      var max = $("#inventory_" + variant.val());
      if(parseInt($("#variant_quantity").val()) < max.val()) {
        $("#variant_quantity").val(parseInt($("#variant_quantity").val()) + 1);
      }
    });

    $(".minus").click(function(){
      var variant = $('[name="variant[id]"]:checked');
      if (variant.length == 0) {
        initProduct.showAlert();
        return;
      }
      if(parseInt($("#variant_quantity").val()) > 1){
        $("#variant_quantity").val(parseInt($("#variant_quantity").val()) - 1);
      }
    });

    $('.size li').click(function(){
      $('#variant_quantity').val(1);
    });
  },
  loadAll : function() {
    initProduct.showCarousel();
    showInfoCredits();

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
    initProduct.loadAddToCartForm();
  }
}

initProduct.loadAddToCartForm();
