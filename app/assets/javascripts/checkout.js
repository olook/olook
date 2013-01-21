function stopProp(e) {
    if (!e) var e = window.event;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
}
function maskTel(tel){
	ddd  = $(tel).val().substring(1, 3);
	dig9 = $(tel).val().substring(5, 6);
	if(ddd == "11" && dig9 == "9")
		$(tel).setMask("(99) 99999-9999");
  else
   	$(tel).setMask("(99) 9999-9999");	  
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
		}).focus(function(){
		    $(tel).unsetMask();
		}).focusout(function() {
			maskTel(tel);
		});
	},
	card: function(){
		$("input.credit_card_number").setMask('9999999999999999999')
	}	
}
function retrieve_freight_price(zip_code, address_id) {
  $.ajax({
    url: '/freight_price',
    type: 'POST',
    data: {
      zip_code: zip_code,
      address_id: address_id
    },
    beforeSend: function(){
      $("#freight_price").fadeOut();
      $("#delivery_time").fadeOut();
    },
    success: function(){
      $("#freight_price").delay(300).fadeIn();
      $("#delivery_time").delay(300).fadeIn();
    }
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

$(function() {
	masks.card();
	
  $("div.box-step-two #checkout_credits_use_credits").change(function() {
    $.ajax({
      url: '/sacola',
      type: 'PUT',
      data: {
        cart: {
          use_credits: $(this).attr('checked') == 'checked'
        }
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
		click: function(e){

			$("#about_credits,#overlay-campaign").fadeOut();
			stopProp(e);
		}
	});	 
	$(document).keyup(function(e) {
			if (e.keyCode == 27) { //ESC 
	   		$("#about_credits,#overlay-campaign").fadeOut();
				stopProp(e);
			}
	});

	// SHOW PAYMENT TYPE
	(function showPaymentType(){
		var payment_type_checked = $(".payment_type input:checked");
		$(".payment_type").siblings('div').hide();
		elem=$(payment_type_checked).val();			
    $("div."+elem).show();
	})();
	
	var payment_type = $(".payment_type input");
	$.each(payment_type,function(){
	    $(this).click(function(){
	        $(".payment_type").siblings('div').hide();
	        elem=$(this).val();			
	        $("div."+elem).show();
	    });
	});
	
	//SELECT CARD
	var cards = $("ol.cards li span");
	$.each(cards, function(){
		$(this).bind('click',function(){
			$("ol.cards li span, .box-debito .debit_bank_Itau").removeClass("selected").siblings("input:checked").removeAttr("checked");
			$(this).addClass("selected").siblings("input").attr('checked','checked');
		});
	});
	
	var debit = $(".box-debito span.debit_bank_Itau");
	$(debit).click(function(){
		$(this).addClass("selected").siblings("input").attr('checked','checked');
		$("ol.cards li input:checked").removeAttr("checked");
		$("ol.cards li span").removeClass("selected");
	});
	
});

$("form.edit_cart_item").submit(function() {
    retrieve_freight_price($("#checkout_address_zip_code").val(),null);  
    return true;
});