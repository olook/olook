/* 
  Hack to prevent closing the opener (we must close the opener only when 
  dealing with facebook login popup)
*/
var url=window.location.href;
if(window.opener && url.indexOf('utm_source') == -1 ) {
   window.opener.top.location = window.location.href;
   document.getElementsByTagName('body')[0].style.display='none';
   setTimeout(function(){
     window.close();
   },200)
}
