function criaCookie(chave, value) { 
	var expira = new Date(); 
	expira.setTime(expira.getTime() + 87600000); //expira dentro de 24h 
	document.cookie = chave + '=' + value + ';expira=' + expira.toUTCString(); 
	console.log(document.cookie)
} 
function lerCookie(chave) { 
	var ChaveValor = document.cookie.match('(^|;) ?' + chave + '=([^;]*)(;|$)'); 
	return ChaveValor ? ChaveValor[2] : null; 
}
$(function(){
	criaCookie("modalShow","sim")
	

	$("#overlay-campaign").delay(100).fadeIn();
	$("#modal-campaign").append('<iframe src="/campaign_emails/new" border="0" frameborder="0" height="100%" width="100%"></iframe>');

})

