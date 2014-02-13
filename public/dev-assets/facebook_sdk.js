$(document).ready(function() {
  $.ajax({
    url: '//connect.facebook.net/pt_BR/all.js',
    cache: true,
    dataType: 'script',
    success: function(){
      FB.init({
        appId: 188195317939978,
        channelUrl: window.location.protocol + '//' + window.location.host + '/channel.html',
        xfbml: true
      });
      if(( typeof olook === 'object' || typeof olook === 'function' ) && typeof olook.facebookCallbacks === 'function'){
        olook.facebookCallbacks();
      }
    }
  });
});
