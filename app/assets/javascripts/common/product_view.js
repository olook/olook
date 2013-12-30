
$(document).ready(function(){
  new ImageLoader().load("async");
  initQuickView.productZoom();

  accordion();
  delivery();
  guaranteedDelivery();  
});

$(function() {
  var stringDesc = $("div#infos div.description p.description").text();
  
  // initQuickView.productZoom();


  /** MODAL GUIA DE MEDIDAS **/
  $(".size_guide a").click(function(e){
    modal.show($("#modal_guide"));
    e.preventDefault();
    
  })

  $("div#product-details a.more").live("click", function() {
    el = $(this).parent();
    el.text(stringDesc);
    el.append("<a href='javascript:void(0);' class='less'>Esconder</a>");
  });

  $("div#gallery ul#thumbs li a").live("click", function() {
    rel = $(this).attr('rel');
    $("div#gallery div#full_pic ul li").hide();
    $("div#gallery div#full_pic ul li."+rel).show();
    $("ul#thumbs li a").find("img.selected").removeClass("selected");
    $(this).children().addClass("selected");
    return false;
  });

  
  $("div#product-details div.size ol li").live('click', function() {
    if($(this).hasClass("unavailable") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input[type='radio']").attr('checked', false);
      lists.removeClass("selected");
      $(this).find("input[type='radio']").attr('checked', true);
      $(this).addClass('selected');
      inventory = $(this).find("input[type='hidden']").val();
      badge = $("div#gallery div#full_pic p.warn.quantity");
      remaining = $("div#product-details p.remaining");
      if(inventory < 2) {
        $(remaining).html("Resta apenas <strong><span>0</span> unidade</strong> para o seu tamanho");
      } else {
        $(remaining).html("Restam apenas <strong><span>0</span> unidades</strong> para o seu tamanho");
      }
      $(remaining).hide();
      $(badge).hide();
      if(inventory <= 3) {
        $(remaining).find("span").text(inventory);
        $(badge).find("span").text(inventory);
        $(remaining).show();
        $(badge).show();
      }
      return false;
    }
  });

  $("#add_item").live('submit', function(event) {
    if(initQuickView.inQuickView) {
      $("#close_quick_view").trigger('click');
    }

    initBase.openDialog();
    $('body .dialog').show();
    $('body .dialog').css("left", ((viewWidth  - '930') / 2) + $('body').scrollLeft() );
    $('body .dialog').css("top", ((viewHeight  - '515') / 2) + $('body').scrollTop() );
    $('body .dialog #login_modal').fadeIn('slow');
    initBase.closeDialog();
  });

});

initQuickView = {
  inQuickView : false,

  productZoom : function() {
    $("div#gallery div#full_pic ul li a.image_zoom").each(function(){
       var _url = "http:" + $(this).attr('href');
       $(this).zoom({url: _url})
    });
  },

  twitProduct : function() {
    $("ul.social li.twitter a").live("click", function(e) {
      var width  = 575,
          height = 400,
          left   = ($(window).width()  - width)  / 2,
          top    = ($(window).height() - height) / 2,
          url    = this.href,
          opts   = 'status=1' +
                   ',width='  + width  +
                   ',height=' + height +
                   ',top='    + top    +
                   ',left='   + left;

      window.open(url, 'twitter', opts);
      e.preventDefault();
    });
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
  },

  shareProductOnFacebook : function() {
    $("ul.social li.facebook a").live("click", function() {
      postProductToFacebookFeed();
      return false;
    })
  }
};

function accordion(){
  el = $("#product-particulars h3");
  el.on("click", function(e){
    e.stopPropagation();
    e.preventDefault();
    isOpen = $(this).hasClass( "open");
    if(!isOpen){
      $(this).siblings("h3").removeClass("open").siblings("div").slideUp();
      $(this).addClass("open").next().addClass("open").slideDown();
    } else {
      $(this).removeClass("open").siblings("div").slideUp();    
    }
  });  
}

function guaranteedDelivery(){
  $('.payment_type input').click(function(e){
    if($("#checkout_payment_method_billet").is(':checked')) {
      $('#billet_expiration').slideDown();
    } else {
      $('#billet_expiration').slideUp();
    }
  });
}

function findDeliveryTime(it, warranty_deliver){
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
function delivery(){
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
