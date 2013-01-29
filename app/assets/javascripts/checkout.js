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
	card: function(){
		$("input.credit_card_number").setMask('9999999999999999999')
	}	
}


function retrieve_freight_price(zip_code) {
  $.ajax({
    url: '/shippings/' + zip_code,
    type: 'GET',
    beforeSend: function(){
      $("#freight_price").hide();
      $("#delivery_time").hide();
      $("#total").hide();
      $("#total_billet").hide();
    },
    success: function(){
      $("#freight_price").delay(200).fadeIn();
      $("#delivery_time").delay(200).fadeIn();
      if($("#checkout_payment_method_billet").is(":checked")){
        $("#total_billet").delay(200).fadeIn();
      } 
      else {
        $("#total").delay(200).fadeIn();
      }
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

var helpLeft2 = 0;
function setButton(){
	el = $("#cart-box").height();
	h = el + 120;
	$("#new_checkout .send_it").css("top", h).fadeIn();
 	
	if($('input.send_it').size() > 0)
		return helpLeft2 = $('input.send_it').offset().left;
}


$(function() {
	masks.card();
	setButton();
	
	var msie6 = $.browser == 'msie' && $.browser.version < 7;
	if(!msie6 && $('.box-step-three').length == 1) {
		var helpLeft = $('.box-step-three').offset().left; 

		$(window).scroll(function(event) {
			var y = $(this).scrollTop();
			if(y >= 170) {
				$('div.box-step-three').addClass('fixed').css({'left' : helpLeft, 'top' : '0'});
				$('input.send_it').addClass('fixed').css('left', helpLeft2);
			} else {
				$('.box-step-three, input.send_it').removeClass('fixed').css({"left" : "", "top" : ""})
			}
		});
	}
	
	
  $("div.box-step-two #checkout_credits_use_credits").change(function() {
    $("#cart-box #credits_used").hide();
    $("#cart-box #total").hide();
    $("#cart-box #total_billet").hide();
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
		click: function(){

			$("#about_credits,#overlay-campaign").fadeOut();
		}
	});	 
	$(document).keyup(function(e) {
			if (e.keyCode == 27) { //ESC 
	   		$("#about_credits,#overlay-campaign").fadeOut();
			}
	});

	//SHOW TOTAL 
	function showTotal(){
		if($("div.billet").is(":visible")){
			$("span#total").fadeOut('fast');
			$("span#total_billet").delay(200).fadeIn();
		}else{
			$("span#total_billet").fadeOut('fast');
			$("span#total").delay(200).fadeIn();
		}
	}

	// SHOW PAYMENT TYPE
	(function showPaymentType(){
		var payment_type_checked = $(".payment_type input:checked");
		$(".payment_type").siblings('div').hide();
		elem=$(payment_type_checked).val();			
    $("div."+elem).show();
		showTotal();
	})();
	
	var payment_type = $(".payment_type input");
	$.each(payment_type,function(){
	    $(this).click(function(){
	        $(".payment_type").siblings('div').hide();
	        elem=$(this).val();			
	        $("div."+elem).show();
					showTotal();
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
//SCROLLTOP WHEN NEW ADDRESS IS CLICKED
$('#checkout_address a').click(function(e) {
	$("html, body").animate({scrollTop: 0}, 'fast');
  e.preventDefault();
});

$("form.edit_cart_item").submit(function() {
    retrieve_freight_price($("#checkout_address_zip_code").val(),null);  
    return true;
});
