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
$(function(){
  function share_profile_result(profile, url) {
    var obj = {
      method: 'feed',
      caption: url,
      picture: "cdn.olook.com.br/assets/socialmedia/facebook/profiles/facebook_" + profile + ".jpg",
      link: url,
      description: 'Repondi o style quiz da Olook e descobri o meu estilo. Agora vou receber dicas das Stylists! Responda também e tenha uma vitrine personalizada #ficaadica'
    };

    FB.ui(obj);
  }

  $("#facebook_share_profile, #facebook_share").on("click", function(){
    var url = $(this).data('url');
    var user_profile = $(this).data('profile');
    switch(user_profile) {
      case "sexy":
        profile = "sexy";
      break;
      case "chic":
        profile = "elegante";
      break;
      case "moderna":
        profile = "fashion"
      break;
      default:
        profile = "casual"
    };
    share_profile_result(profile, url);
  });
});
