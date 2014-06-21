//= require ./partials/_credits_info
//= require formatter
//= require credit_card
//= require string_utils
//= require ./partials/_modal
//= require plugins/valentines_day
//= require plugins/jquery.meio.mask
//= require plugins/image_loader
//= require plugins/spy
//= require_tree ./modules/complete_look
//= require modules/product/load
//= require modules/product_available_notice/load

initProduct = {
  gotoRelatedProduct :function() {
    $('a[href="#related"]').live('click', function(e) {
      $("html, body").animate({scrollTop: 900}, 'fast');

      $.post("/produto/ab_test", {}, function( data ) {
        console.log(data);
      });


      e.preventDefault();
    });
  },
  checkRelatedProducts : function() {
    return $("div#related ul.carousel").size() > 0 ? true : false;
  },
  showAlert : function(){
    $('p.alert_size, p.js-alert').show().html("Selecione seu tamanho").delay(3000).fadeOut();
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
    console.log('binding addToCartForm in ' + Date.now());
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

    $(".js-add-product").off('click').on('click', function(){
      olookApp.publish('product:add');
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

var bindWishlistEvents = function(){
  $('#js-addToWishlistButton').click(function(){
    olookApp.mediator.publish('wishlist:add:click_button');
  });

  $('#js-removeFromWishlistButton').click(function(){
    var productId = $(this).data('product-id');
    olookApp.mediator.publish('wishlist:remove:click_button', productId);
  });
};

var loadCompleteLookModules = function(){
  new MinicartFadeOutManager().config();
  new MinicartDataUpdater().config();
  new MinicartBoxDisplayUpdater().config();
  new MinicartFadeInManager().config();
  new MinicartInputsUpdater().config();
};

$(function(){
  loadCompleteLookModules();
  initProduct.loadAll();
  bindWishlistEvents();
});
