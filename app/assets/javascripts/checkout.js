//= require state_cities
//= require plugins/cep
//= require plugins/check_freebie
//= require plugins/footer_popup
//= require application_core/olook_app
//= require modules/facebook/events
//= require_tree ./modules/facebook/auth
//= require modules/facebook/auth

new FacebookEvents().config();
new FacebookAuth().config();
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
  dig9 = $(tel).val().substring(4, 5);
  ddd  = $(tel).val().substring(1, 3);

  if(dig9 == "9" && ddd.match(/11|12|13|14|15|16|17|18|19|21|22|24|27|28/)){
    $(tel).setMask("(99)99999-9999");
  } else {
    $(tel).setMask("(99)9999-9999");
  }
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

function retrieve_freight_price_for_checkout(zip_code, shipping_id, prevent_shipping_policy, new_address) {
  var url_path = '/shippings/' + zip_code
  var sel_shipping = $('input[name="checkout[shipping_service]"]:visible:checked').val();
  if (!zip_code) {
    return;
  }

  if(typeof new_address == 'undefined') {
    if(typeof shipping_id != 'undefined' && shipping_id.length != ''){
      url_path = url_path.concat('?freight_service_ids=' + shipping_id);
    } else if(sel_shipping) {
      url_path = url_path.concat('?freight_service_ids=' + sel_shipping);
    }
  }
  $.ajax({
    url: url_path,
    type: 'GET',
    data:{prevent_policy: prevent_shipping_policy},
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

function retrieve_shipping_service(){
  var checked_shipping = $('.shipping_service_radio:checked');
  var shipping_service_id = checked_shipping.data('shipping-service');
  zipcode = $('input.address_recorded:checked').data('zipcode') || $('.zip_code').val();
  var force_shipping_policy = '';
  if(checked_shipping.hasClass('express')){
    force_shipping_policy = true;
  }
  retrieve_freight_price_for_checkout(zipcode, shipping_service_id,force_shipping_policy);
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
    retrieve_freight_price_for_checkout(zip_code,"",false);
  }

  $("#checkout_address_zip_code").on("blur", function(){
    zip_code = $("#checkout_address_zip_code").val();
    retrieve_freight_price_for_checkout(zip_code,"",false, true);
  });
}

$(function() {
  if($('#checkout_address_state').length != 0){
    new dgCidadesEstados({
      cidade: document.getElementById('checkout_address_city'),
      estadoVal: checkoutState,
      estado: document.getElementById('checkout_address_state'),
      cidadeVal: checkoutCity
    });
    $('#checkout_address_state').change(function(){
      $(this).parent().find("p").html($(this).val());
    });
    $('#checkout_address_state').parent().find("p").html($('#checkout_address_state').val());
    $('#checkout_address_city').parent().find("p").html($('#checkout_address_city').val());
    $('#checkout_address_city').change(function(){
      $(this).parent().find("p").html($(this).val());
    });
    masks.tel(".tel_contato1");
    masks.tel(".tel_contato2");
    olook.cep('.zip_code', {
      estado: '#checkout_address_state',
      cidade: '#checkout_address_city',
      rua: '#checkout_address_street',
      bairro: '#checkout_address_neighborhood',
      applyHtmlTag: true,
      afterFail: function(){
    $('#checkout_address_state').parent().find("p").html($('#checkout_address_state').val());
    $('#checkout_address_city').parent().find("p").html($('#checkout_address_city').val());
        new dgCidadesEstados({
          cidade: document.getElementById(olook.cep.cidade.replace('#', '')),
          estado: document.getElementById(olook.cep.estado.replace('#', ''))
        });
      }
    });
  }
  masks.card();
  window.setTimeout(setButton,600);
  freightCalc();
  showAboutSecurityCode();
  olook.showSmellPackageModal();

  if($('input[name="address\[id\]"]:checked').size() == 1){
    $('input[name="address\[id\]"]:checked').trigger('click');
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

  $("#checkout_credits_use_credits").change(function() {
    $("#cart-box #credits_used").hide();
    $("#cart-box #total").hide();
    $("#cart-box #total_billet").hide();
    $("#cart-box #total_debit").hide();
    $("#cart-box #billet_discount_cart").hide();
    $.ajax({
      url: '/pagamento',
      type: 'PUT',
      dataType: 'json',
      data: {
        cart: {
          use_credits: $(this).attr('checked') == 'checked'
        },
      freight_price: $("#freight_price").text()
      }
    }).done(function(data){
      var value = $("#freight_price").data('freight_price');
      freight_value = value == undefined ? 0 : parseFloat(value);
      var total = add(data.total, freight_value);


      $('#credits_used').text(formatReal(data.credits_discount));
      $('#total').text(formatReal(total));
      $('#total_billet').text(formatReal(add(data.total_billet, freight_value)));
      $('#total_debit').text(formatReal(add(data.total_debit, freight_value)));
      $('#debit_discount_value').text(formatReal(data.debit_discount));
      $('#billet_discount_value').text(formatReal(data.billet_discount));


      updateCreditCardSettlementsValue($('#checkout_payment_payments'), total, false);

    });
  });

  // ABOUT CREDITS MODAL
  $("div.box-step-three .more_credits").click(function(){
    $("#overlay-campaign").show();
    $("#about_credits").fadeIn();
  });

  $("div.box-step-three  button").click(function(){
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

  var debit = $(".box-debito span");
  $(debit).click(function(){  
    debit.removeClass("selected");
    var bank = $(this).data('bank').toLowerCase();
    $(".box-debito input:checked").removeAttr("checked");

    $("#checkout_payment_bank_" + bank).attr('checked','checked');
    $(this).addClass("selected");
  });

  $("form.edit_cart_item").submit(function() {
    retrieve_freight_price($("#checkout_address_zip_code").val(),null);
    return true;
  });
});

add = function(str1, str2) {
  return parseFloat(str1) + parseFloat(str2);
}

formatReal = function(value) {
  return "R$ " + parseFloat(value).toFixed(2).replace(/\./, ',');
}
