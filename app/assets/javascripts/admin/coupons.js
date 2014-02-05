function validation (condition, conditioned) {
	if (condition){
		$(conditioned).attr('checked', false).val("")
	}
	else {
		$(conditioned).attr('checked', true)
	}
}

$(document).ready(function(){
	condition = ($("#coupon_unlimited").attr('checked')) ? true : false;
	validation( condition , "#coupon_remaining_amount" );

	condition = ($("#coupon_remaining_amount").val() != "") ? true : false;
	validation( condition , "#coupon_unlimited" );

	$("#coupon_remaining_amount").keyup(function(){
		condition = ($(this).val() != "") ? true : false;
		validation( condition , "#coupon_unlimited" );
	})
	$("#coupon_unlimited").change(function(){
		condition = ($(this).attr('checked')) ? true : false;
		validation( condition , "#coupon_remaining_amount" );
	});

});
