//= require ./partials/_credits_info
//= require formatter
//= require credit_card
//= require string_utils
//= require plugins/spy

$(function(){
  initProduct.loadAll();
  olook.spy('a.spy');
});

initProduct = {
  checkRelatedProducts : function() {
    return $("div#related ul.carousel").size() > 0 ? true : false;
  },
  showAlert : function(){
    $('p.alert_size').show().html("Qual é o seu tamanho mesmo?").delay(3000).fadeOut();
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
    return variant.val();
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
      return !!(initProduct.selectedVariantMaxVal());
    });

    $("#add_product").click(function(e){
      e.preventDefault;
    });

    $(".plus").off('click').on('click', initProduct.plusQuantity);

    $(".minus").off('click').on('click', initProduct.minusQuantity);

    $("#variant_quantity").change(function(){
      var it = $(this);
      var inventory = $('#inventory_' + variant.val());
      if(initProduct.selectedVariantMaxVal() && it.val() > inventory.val()) {
        it.val(inventory.val());
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
