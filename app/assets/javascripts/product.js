//= require ./partials/_credits_info
//= require formatter
//= require credit_card
//= require string_utils
//= require ./partials/_modal
//= require plugins/valentines_day
//= require plugins/jquery.meio.mask
//= require plugins/image_loader
//= require plugins/spy


$(function(){
  initProduct.loadAll();
  olook.spy('.spy');
});

initProduct = {
  gotoRelatedProduct :function() {
    $('a#goRelatedProduct').live('click', function(e) {
      $("html, body").animate({
        scrollTop: 900
      }, 'fast');
      e.preventDefault();
    });
  },  
  checkRelatedProducts : function() {
    return $("div#related ul.carousel").size() > 0 ? true : false;
  },
  showAlert : function(){
    $('p.alert_size').show().html("Qual é o seu tamanho mesmo?").delay(3000).fadeOut();
  },
  // for reasons unknown, this carousel is awkwardly inverted. I had to re-invert the names in order for it to work properly :P
  showCarousel : function() {
    if(initProduct.checkRelatedProducts() == true) {
      $("div#related ul.carousel").carouFredSel({
        auto: false,
        width: 860,
        items: 3,
        next : {
          button : ".carousel-prev",
          items : 3
        },
        prev : {
          button : ".carousel-next",
          items : 3
        }
      });
    }
  },
  plusQuantity: function() {
    initProduct.changeQuantity(1);
  },
  minusQuantity: function(){
    initProduct.changeQuantity(-1);
  },
  changeQuantity: function(by) {
    var maxVal = initProduct.selectedVariantMaxVal(),
      newVal = parseInt($("#variant_quantity").val()) + by;
    if(maxVal && newVal <= maxVal && newVal >= 1 ){
      $("#variant_quantity").val(newVal);
    }
  },
  selectedVariantMaxVal: function(){
    var variant = $('[name="variant[id]"]:checked');
    if (variant.length == 0) {
      initProduct.showAlert();
      return false;
    }
    var inventory = $('[name=inventory_' + variant.val() + ']');
    return inventory.val();
  },
  loadAddToCartForm : function() {
    if($('#compartilhar_email').length == 1) {
      var content = $('#compartilhar_email');
      $("ul.social-list li.email").on("click", function(e){
        e.preventDefault();
        e.stopPropagation();
        modal.show(content);
      });
    }
    $("#compartilhar_email form").submit(function(){
      $("input#send").addClass("opacidade").delay(300).attr('disabled', true);
    })

    $("a.open_loyalty_lightbox").show();

    $("form#product_add_to_cart").submit(function() {
      return !!(initProduct.selectedVariantMaxVal());
    });

    $("#add_product").click(function(e){
      e.preventDefault;
    });

    $(".plus").off('click').on('click', initProduct.plusQuantity);

    $(".minus").off('click').on('click', initProduct.minusQuantity);

    $("#variant_quantity").change(function(){
      var it = $(this);
      if (it.val() <= 0) {
        it.val(1);
      } else {
        var variant = $('[name="variant[id]"]:checked');
        var inventory = $('#inventory_' + variant.val());
        if(initProduct.selectedVariantMaxVal() && it.val() > inventory.val()) {
          it.val(inventory.val());
        }
      }
    });

    $('.size li').click(function(){
      $('#variant_quantity').val(1);
    });
  },
  loadAll : function() {
    initProduct.showCarousel();
    initProduct.gotoRelatedProduct();
    initProduct.loadUnloadTriggers();
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
  },

  loadUnloadTriggers : function() {
    $(window).on("beforeunload", function () {
      initProduct.unloadSelects();
    });    
  },    

  unloadSelects : function() {
    for(i = 0; i < $("li #variant_number").length; i++){
      $("li #variant_number")[i].selectedIndex = 0;            
    }
  }
}

initProduct.loadAddToCartForm();
