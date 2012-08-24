$(document).ready(function(){
	var orderNumberController = function(element){
		element = element || $("#operation");

		if($(element).val().match(/:order/)){
			$('.order_number').show();
		}else{
			$('#ordem_number').val('')
			$('.order_number').hide();
		}
	}

	orderNumberController.call(window);

	$.validator.addMethod("money", function (value, element) {
	   return this.optional(element) || value.match(/^\$?\d+(\.(\d{2}))?$/);
	}, "Please provide a valid money amount. For cents use two digits");

	$.validator.addMethod("transaction_limit", function(value, element) {
		max_value = $("#operation").val()=='invite' ? 10 : 150;
    return this.optional(element) || (parseFloat(value) <= max_value);
	}, "* Amount cannot exceed the max value.");

	$.validator.addMethod("transaction_minimun_limit", function(value, element) {
    return this.optional(element) || (parseFloat(value) > 0);
	}, "* Amount must be greater than 0.00");

	$("#operation").on('change',function(e){
		orderNumberController.call(window, this);
	})

	$('#create_credit_transaction').validate({
		rules:{
				operation:{required: true},
				method:{required: true},
		    value:{
		    		money: true,
		    		transaction_limit: true,
		        required: true,
		        transaction_minimun_limit: true
		    }
		}
	});
});


