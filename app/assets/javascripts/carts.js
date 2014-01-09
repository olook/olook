//= require ./partials/_credits_info
//= require plugins/spy
//= require plugins/check_freebie
$(function() {
  showInfoCredits();
  olook.spy('.cart_item[data-url]');
  if ($('#cart_gift_wrap').is(':checked')){
    $('#subtotal_parcial').append("<div id='embrulho_presente'></div>");
    var span_gift_target = $('#embrulho_presente');
    span_gift_target.html($("#gift_value").text().trim());
  }else{
    $('#embrulho_presente').remove();
  }
  if ($('#cart_use_credits').is(':checked') && $(".cupom").filter(":visible").length > 0){
    $('#subtotal_parcial').append("<div id='credito_fidelidade'></div>");
    var span_target = $('#credito_fidelidade');
    span_target.html("-"+$("#total_user_credits").text().trim());
  }else{
    $('#credito_fidelidade').remove();
  }

  $("form#coupon input").focus(function() {
    _gaq.push(['_trackEvent', 'Checkout', 'FillCupom', '', , true]);
  });


  $("#facebook_share").click(function(element) {
    postCartToFacebookFeed(element)
  })

  $("form#gift_message").bind("ajax:success", function(evt, xhr, settings) {
        document.location = $("a.continue").attr("href");
    });

    $(".continue").click(function() {
    $("form#gift_message").submit();
  })


  $('section#cart a.continue.login').live('click', function(e) {
    clone = $('.dialog.product_login').clone().addClass("clone");
    content = clone[0].innerHTML;
    initBase.modal(content);
    e.preventDefault();
  });

  $('#cart_use_credits').change(function() {
    $('#use_credit_form').submit();
  });

  $( "#cart_gift_wrap" ).change(function() {
    $( "#gift_wrap" ).submit();
  });

  $("#credits_credits_last_order").change(function() {
    $("#credits_last_order").submit();
  });

  $("table.check tbody tr td a").live("click", function(e) {
    clone = $('div.credit_details').clone().addClass("clone");
    content = clone[0].outerHTML;
    initBase.newModal(content);
    e.preventDefault();
  });

  if($("div#carousel").size() > 0) {
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
  }

  if($("div#carousel_lookbooks").size() > 0) {
    $("div#carousel_lookbooks ul").carouFredSel({
      auto: false,
      width: 970,
      items: 3,
      prev : {
        button : ".prev-lookbook",
        items : 1
      },
      next : {
        button : ".next-lookbook",
        items : 1
      },
      pagination: {
        container : "div#carousel_lookbooks .pagination",
        items : 1
      }
    });
  }

  showGiftPackageModal();
  showCreditPackageModal();
  showSmellPackageModal();
});

function showGiftPackageModal(){
   var content = $(".modal_gift");
   $("a.txt-conheca").bind("click", function(e){
      initBase.newModal(content);
      e.preventDefault();
      e.stopPropagation();
   })

}

function showCreditPackageModal(){
   content = $(".modal_credit");
   $("a.txt-credito").bind("click", function(e){
      initBase.newModal(content);
      e.preventDefault();
      e.stopPropagation();
   })

}

function showSmellPackageModal(){
   var content = $(".modal_smell");
   $("a.seeTheSmell").bind("click", function(e){
      initBase.newModal(content);
      e.preventDefault();
      e.stopPropagation();
   })

}

function changeCartItemQty(cart_item_id) {
    $('form#change_amount_' + cart_item_id).submit();
}

function postCartToFacebookFeed(element) {
  var obj = {
      picture: 'cdn.olook.com.br/assets/socialmedia/facebook/icon-app/app-2012-09-19.jpg',
      method: 'feed',
      caption: 'www.olook.com.br',
      link: 'http://www.olook.com.br',
      description: 'Comprei no site da olook e amei! Já conhece? Roupas, sapatos, bolsas e acessórios incríveis. Troca e devolução grátis em até 30 dias. Conheça!'
  }

  FB.ui(obj, function(response) {
    if (response && response.post_id) {
        var cart = $(element).data("cart-id")
      $.ajax({
        url: $(element).attr('href'),
        type: "PUT",
        data: { cart: { facebook_share_discount: true }  },
        dataType: "script"
        });
      _gaq.push(['_trackEvent', 'Checkout', 'FacebookShare', '', , true]);
      $("#facebook-share").hide();
      $(".msg").show();
      }
    }
  );
}
