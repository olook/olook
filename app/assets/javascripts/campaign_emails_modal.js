function criaCookieAB(chave, value, time) { 
	$.cookie(chave, value, { expires: time, path: '/' });
} 

function lerCookie(chave) { 
  return $.cookie(chave);
}

function stopProp(e) {
    if (!e) var e = window.event;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
}
function dontShow(){
	criaCookieAB("modalShow", "sim", 30);
	_gaq.push(['_trackEvent', 'Modal', 'Excluir', '']);
}

$(function(){
	if(lerCookie("modalShow") == null){
		$("#overlay-campaign").delay(100).show();
		$("#modal-campaign").append('<iframe src="/campaign_emails/new" border="0" frameborder="0" height="100%" width="100%"></iframe>');
		window.setTimeout(function(){
				if($("#overlay-campaign").is(":visible"))
					criaCookieAB("modalShow","sim", 1);
		},500)

	}
	$(document).one({
		click: function(e){
		//	$("#modal-campaign,#overlay-campaign").fadeOut();
			if($("#modal-campaign iframe").contents().find(".dont_show").is(":checked")){
				dontShow();
			}	
			_gaq.push(['_trackEvent', 'Modal', 'Close', '']);
			stopProp(e);
		}, 
		keyup: function(e) {
			if (e.keyCode == 27) { //ESC 
	   		$("#modal-campaign,#overlay-campaign").fadeOut();
			}
			if($("#modal-campaign iframe").contents().find(".dont_show").is(":checked")){
				dontShow();
			}
			_gaq.push(['_trackEvent', 'Modal', 'Close', '']);
			stopProp(e);
		}		
	})
	
})