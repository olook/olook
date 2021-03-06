//= require ./plugins/jquery.zoom-min
//= require ./partials/_credits_info
//= require formatter
//= require credit_card
//= require string_utils
//= require ./partials/_modal
//= require plugins/valentines_day
//= require plugins/jquery.meio.mask
//= require plugins/image_loader
//= require_tree ./modules/complete_look
//= require_tree ./modules/wishlist/
//= require modules/product/load
//= require modules/product_available_notice/load

initProduct = {
  setZoom: function(context){
    var it = $(context);
    var zoom_img = it.data('zoom');
    if(!zoom_img) zoom_img = it.find('[data-zoom]').data('zoom');
    it.zoom({url: zoom_img});
  },
  setSizeClick: function(clicked) {
    if(!$(clicked).hasClass("unavailable")) {
      var lists = $(clicked).parents("ol").find("li");
      lists.find("input[type='radio']").attr('checked', false);
      lists.removeClass("selected");
      $(clicked).find("input[type='radio']").attr('checked', true);
      $(clicked).addClass('selected');
      return false;
    }
  },
  gotoRelatedProduct :function() {
    $('a[href="#related"]').live('click', function(e) {
      $("html, body").animate({scrollTop: 900}, 'fast');
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

    /** Clique no Tamanho **/
    $(".size ol li").on('click', function() {
      initProduct.setSizeClick(this);
    });

    /** MODAL GUIA DE MEDIDAS **/
    $(".size_guide a, .size-guide").click(function(e){
      olook.newModal($('<div id="modal_guide"></div>'), 630, 800, '#000');
      e.preventDefault();
    })

    /** Thumbs e Zoom **/
    $('.thumbs li img').on('click', function(){
      var it = $(this);
      $('.js-image-zoom img').attr('src', it.data('full')).data('zoom', it.data('zoom'));
      initProduct.setZoom('.js-image-zoom');
    });

    initProduct.setZoom('.js-image-zoom');
    loadWishlistModules();
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

var loadWishlistModules = function() {
  new AddToWishlist().config();
  new AddToWishlistSuccessMessage().config();
  new AddToWishlistErrorMessage().config();  
  new RemoveFromWishlist().config();
  new RemoveFromWishlistSuccessMessage().config();
}


var loadCompleteLookModules = function(){
  new MinicartFadeOutManager().config();
  new MinicartDataUpdater().config();
  new MinicartBoxDisplayUpdater().config();
  new MinicartFadeInManager().config();
  new MinicartInputsUpdater().config();
};


var findDeliveryTime = function(it, warranty_deliver){
    var cep = it.siblings('.ship-field').val();
    if(cep.length < 9){
      $(".shipping-msg").removeClass("ok").hide().delay(500).fadeIn().addClass("error").text("O CEP informado parece estranho. Que tal conferir?");
      return false;
    }else{
      var suf = '';
      if (warranty_deliver) {
        suf = '?warranty_deliver=1';
      }
      $.getJSON("/shippings/"+cep+suf, function(data){
        var klass = 'ok';
        if(data['class']){
          klass = data['class'];
        }
        it.parent().siblings(".shipping-msg").removeClass("error").hide().delay(500).fadeIn().addClass(klass).text(data.message);
      });
    }
  }

var delivery = function(){
  var sf = $("#ship-field, #cepDelivery");
  if(sf.setMask)
    sf.setMask({mask: '99999-999'});
  $("#shipping #search").click(function(){
    var it = $(this);
    if(it.data('warrantyDeliver')){
      findDeliveryTime(it, true);
    } else {
      findDeliveryTime(it);
    }
  });
}

$(function(){
  loadCompleteLookModules();
  initProduct.loadAll();
  bindWishlistEvents();
  delivery();
});
