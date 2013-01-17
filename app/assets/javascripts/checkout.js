function stopProp(e) {
    if (!e) var e = window.event;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
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
		}
  });
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
    },
    success: function(){
      $("#freight_price").delay(300).fadeIn();
    }
  });
}
$(function() {
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
