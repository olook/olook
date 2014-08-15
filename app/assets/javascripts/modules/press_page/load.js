//= require modules/press_page/period_submitter
//= require plugins/jquery.urlparam

new PeriodSubmitter().config();

if(jQuery.hasUrlParam('period') || jQuery.hasUrlParam('page')){
	setTimeout(function() {
		var anchorHash = 'articles';
		var pos = $('#'+anchorHash).position();
		window.scrollTo(0,pos.top);
	}, 100);
}
