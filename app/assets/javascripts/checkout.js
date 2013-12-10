//= require state_cities
//= require plugins/cep

updateCreditCardSettlementsValue = function(select_box, total, reseller) {
  selected = select_box.val();
  select_box.empty();
  var options = [];
  for (i=1; i<= CreditCard.installmentsNumberFor(total, reseller); i++) {
    installmentValue = total / i;
    text = i + "x de " + Formatter.toCurrency(installmentValue) + " sem juros";
    select_box.append("<option value=" + i + ">" + text + "</option>");
  }
  select_box.val(selected);
}

function maskTel(tel){
  ddd  = $(tel).val().substring(1, 3);
  dig9 = $(tel).val().substring(4, 5);

  if(ddd == "11" && dig9 == "9")
    $(tel).setMask("(99)99999-9999");
  else
    $(tel).setMask("(99)9999-9999");
}

var masks = {
  cep: function(){
    $("input.zip_code").setMask({
      mask: '99999-999'
    });
  },
  tel: function(tel){
    $(tel).keyup(function(){
      maskTel(tel);
    });
  },
  card_brands: {
    "Visa":"9999999999999999",
    "Mastercard":"9999999999999999",
    "Diners":"9999999999999999"
  },
  card: function(){
    $("input.credit_card_number").setMask('9999999999999999')
  }
}

function isVariation() {
  return $("#freight_service_ids").val() != "";
}

function retrieve_freight_price_for_control_or_variation(zip_code) {
  if (isVariation()) {
    retrieve_freight_price_for_variation(zip_code);
  } else {
    retrieve_freight_price(zip_code);
  }
}

function retrieve_freight_price(zip_code) {
  retrieve_freight_price_for_checkout('shippings', zip_code);
}

function retrieve_freight_price_for_variation(zip_code) {
  retrieve_freight_price_for_checkout('shipping_updated_freight_table', zip_code);
}

function retrieve_freight_price_for_checkout(url_base, zip_code) {
  $.ajax({
    url: '/' + url_base + '/' + zip_code,
    type: 'GET',
    beforeSend: function(){
      $("#freight_price").hide();
      $("#delivery_time").hide();
      $("#total").hide();
      $("#total_billet").hide();
      $("#total_debit").hide();
    },
    success: showTotal
  });
}

function retrieve_zip_data(zip_code) {

  $.ajax({
    url: '/address_data',
  type: 'POST',
  data: {
    zip_code: zip_code
  },
  beforeSend: function(){
    $("#address_fields").fadeOut();
  },
  success: function(){
    $("#address_fields").delay(300).fadeIn();
    masks.tel(".tel_contato1");
    masks.tel(".tel_contato2");
    masks.cep();
  }
  });
}

function changeCartItemQty(cart_item_id) {
  $('form#change_amount_' + cart_item_id).submit();
}

var helpLeft2 = 0;
function setButton(){
  el = $("#cart-box").height();
  h = el + 120;

  $("#new_checkout .send_it").css("top", h).fadeIn();

  if($('input.send_it').size() > 0)
    return helpLeft2 = $('input.send_it').offset().left;
}

function showAboutSecurityCode(){
  $("a.find_code").click(function(){
    content = $("div.modal_security_code");
    initBase.newModal(content);
  })
}

//SHOW TOTAL
function showTotal(){
  var _out = "span#total, span#total_billet, span#total_debit, #debit_discount_cart, #billet_discount_cart";
  var _in = [];
  if($("div.billet").is(':visible')){
    _in.push("span#total_billet");
    _in.push("#billet_discount_cart");
  } else if($('div.debit').is(':visible')) {
    _in.push("span#total_debit");
    _in.push("#debit_discount_cart");
  } else {
    _in.push("span#total");
  }
  $(_out).not(_in.join(',')).fadeOut('fast');
  $(_in.join(',')).delay(200).fadeIn();
}

function freightCalc(){
  zip_code = $("#checkout_address_zip_code").val();
  if (zip_code) {
    retrieve_freight_price_for_control_or_variation(zip_code);
  }

  $("#checkout_address_street").on("focus", function(){
    zip_code = $("#checkout_address_zip_code").val();
    retrieve_freight_price_for_control_or_variation(zip_code);
  });
}

function trackStateForFreightABTest() {
  state = $("#checkout_address_state").val() || $(".address_recorded:checked").data("state");
  if (state != undefined) {
    actionSuffix = isVariation() ? 'Var' : 'Ctrl';
    _gaq.push(['_trackEvent', 'FreightABTest', 'FreightPreview' + actionSuffix, state, true]);
  }
}

$(function() {

  masks.card();
  window.setTimeout(setButton,600);
  masks.tel(".tel_contato1");
  masks.tel(".tel_contato2");

  freightCalc();
  showAboutSecurityCode();
  showSmellPackageModal();

  if($(".box-step-one input[type=radio]").size() == 1){
    $(".box-step-one input[type=radio]").trigger('click');
  }

  $(".credit_card").click(function() {
    $(".box-debito .debit_bank_Itau").removeClass("selected").siblings("input:checked").removeAttr("checked");
  });

  var msie6 = $.browser == 'msie' && $.browser.version < 7;
  if(!msie6 && $('.box-step-three').length == 1) {
    var helpLeft = $('.box-step-three').offset().left;
    // Função para scrollar box passo 3 
    // $(window).scroll(function(event) {
    //   var y = $(this).scrollTop();
    //   if(y >= 170) {
    //     $('div.box-step-three').addClass('fixed').css({'left' : helpLeft, 'top' : '0', 'float' : 'left'});
    //     $('input.send_it').addClass('fixed bt-checkout').css('left', helpLeft2);
    //   } else {
    //     $('.box-step-three').removeClass('fixed').removeAttr('style');
    //     $('input.send_it').removeClass('fixed bt-checkout').css('left', "")
    //   }
    // });
  }

  function showSmellPackageModal(){
   var content = $(".modal_smell");
   $("a.seeTheSmell").bind("click", function(e){
      initBase.newModal(content);
      e.preventDefault();
      e.stopPropagation();
   })
  }



  $("div.box-step-two #checkout_credits_use_credits").change(function() {
    $("#cart-box #credits_used").hide();
    $("#cart-box #total").hide();
    $("#cart-box #total_billet").hide();
    $("#cart-box #total_debit").hide();
    $("#cart-box #billet_discount_cart").hide();
    $.ajax({
      url: '/sacola',
      type: 'PUT',
      data: {
        cart: {
          use_credits: $(this).attr('checked') == 'checked'
        },
      freight_price: $("#freight_price").text()
      }
    });
  });

  // ABOUT CREDITS MODAL
  $("div.box-step-two .more_credits").click(function(){
    $("#overlay-campaign").show();
    $("#about_credits").fadeIn();
  });

  $("div.box-step-two button").click(function(){
    $("#about_credits").fadeOut();
    $("#overlay-campaign").hide();
  });

  $("#overlay-campaign").one({
    click: function(){

      $("#about_credits,#overlay-campaign").fadeOut();
    }
  });
  $(document).keyup(function(e) {
    if (e.keyCode == 27) { //ESC
      $("#about_credits,#overlay-campaign").fadeOut();
    }
  });


  // SHOW PAYMENT TYPE
  function showPaymentType(){
    var payment_type_checked = $(".payment_type input:checked");
    $(".payment_type").siblings('div').hide();
    elem=$(payment_type_checked).val();
    $("div."+elem).show();
    showTotal();
  };
  showPaymentType();

  $(".payment_type input").click(function(){
	  showPaymentType();
	  $(".payment_type").siblings("div").find("input:checked").removeAttr("checked");
	  $(".payment_type").siblings("div").find("input[type='text']").val('');
	  $(".payment_type").siblings("div").find("span.selected").removeClass("selected");

  })


  //SELECT CARD
  var cards = $("ol.cards li span");
  $.each(cards, function(){
    $(this).bind('click',function(){
      $("ol.cards li span, .box-debito .debit_bank_Itau").removeClass("selected").siblings("input:checked").removeAttr("checked");
      $("input.credit_card_number").setMask(masks.card_brands[$(this).attr("class")]);
      $(this).addClass("selected").siblings("input").attr('checked','checked');
    });
  });

  var debit = $(".box-debito span.debit_bank_Itau");
  $(debit).click(function(){
    $(this).addClass("selected").siblings("input").attr('checked','checked');
    $("ol.cards li input:checked").removeAttr("checked");
    $("ol.cards li span").removeClass("selected");
  });

  $("form.edit_cart_item").submit(function() {
    retrieve_freight_price($("#checkout_address_zip_code").val(),null);
    return true;
  });
});
