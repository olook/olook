function criaCookie(chave, value) { 
	$.cookie(chave, value, { expires: 1, path: '/' });
} 

function lerCookie(chave) { 
  return $.cookie(chave);
}

$(function(){
	if(lerCookie("modalShow") == null){
		$("#overlay-campaign").delay(100).show();
		$("#modal-campaign").append('<iframe src="/campaign_emails/new" border="0" frameborder="0" height="100%" width="100%"></iframe>');
		window.setTimeout(function(){
				if($("#overlay-campaign").is(":visible"))
					criaCookie("modalShow","sim");
		},500)

	}
	$(document).bind("click", function(){
		$("#modal-campaign,#overlay-campaign").fadeOut();
	})
	$(document).keyup(function(e) {
	  if (e.keyCode == 27) { //ESC 
	   $("#modal-campaign,#overlay-campaign").fadeOut();
	  }  
	});
})