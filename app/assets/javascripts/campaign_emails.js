function checkEmail() {
	var email = $('#campaign_email_email');
	var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	if (!filter.test(email.value) || email.value == "seunome@email.com.br" ) {
		$('.error').fadeIn();
		email.focus;
		return false;
	}
}

$(function(){
	$('#campaign_email_email').focus(function(){
		if($(this).val() == 'seunome@email.com.br')
			$(this).val('');
	}).focusout(function(){
		if($(this).val() == '')
			$(this).val('seunome@email.com.br')
	});
	
	$('.bt-enviar').click(function(){
	//	checkEmail();	
	})
});
