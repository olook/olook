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
	criaCookieAB("ms", "1", 1);
	_gaq.push(['_trackEvent', 'Modal', 'Excluir', '', , true]);
}

$(function(){

	if(show_modal == "1"){
		$("#overlay-campaign").delay(100).show();
		$("#modal-campaign").append('<iframe src="/campaign_emails/new" border="0" frameborder="0" height="100%" width="100%"></iframe>');
		window.setTimeout(function(){
				if($("#overlay-campaign").is(":visible"))
					criaCookieAB("ms","1", 1);
		},500)

	}
	$(document).one({
		click: function(e){
		//	$("#modal-campaign,#overlay-campaign").fadeOut();
			if($("#modal-campaign iframe").contents().find(".dont_show").is(":checked")){
				dontShow();
			}
			_gaq.push(['_trackEvent', 'Modal', 'Close', '', , true]);
			stopProp(e);
		},
		keyup: function(e) {
			if (e.keyCode == 27) { //ESC
	   		$("#modal-campaign,#overlay-campaign").fadeOut();
			}
			if($("#modal-campaign iframe").contents().find(".dont_show").is(":checked")){
				dontShow();
			}
			_gaq.push(['_trackEvent', 'Modal', 'Close', '', , true]);
			stopProp(e);
		}
	})

})
