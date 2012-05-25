$(document).ready(function(){
	$.validator.addMethod("money", function (value, element) {
	   return this.optional(element) || value.match(/^\$?\d+(\.(\d{2}))?$/);
	}, "Please provide a valid money amount. For cents use two digits");
	$.validator.addMethod("transaction_limit", function(value, element) {
    return this.optional(element) || (parseFloat(value) <= 150);
}, "* Amount cannot exceed 150");
$('#create_credit_transaction').validate({
	rules:{
	    value:{
	    		money: true,
	    		transaction_limit: true,
	        required: true
	    }
	}
});
});


