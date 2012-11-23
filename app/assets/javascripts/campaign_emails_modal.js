function criaCookie(chave, value) { 
	var expira = new Date(); 
	expira.setTime(expira.getTime() + 87600000); //expira dentro de 24h 
	document.cookie = chave + '=' + value + ';expira=' + expira.toString(); 
} 
function lerCookie(chave) { 
	var ChaveValor = document.cookie.match('(^|;) ?' + chave + '=([^;]*)(;|$)'); 
	return ChaveValor ? ChaveValor[2] : null; 
}
$(function(){
	if(lerCookie("modalShow") == null){
		$("#overlay-campaign").delay(100).fadeIn();
		$("#modal-campaign").append('<iframe src="/campaign_emails/new" border="0" frameborder="0" height="100%" width="100%"></iframe>');
		window.setTimeout(function(){
				if($("#overlay-campaign").is(":visible"))
					criaCookie("modalShow","sim");
		},500)

	}
})


