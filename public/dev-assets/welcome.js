$(document).ready(function() {

  show_profile_big_image();

  $("section#painel a.bt_painel").live("click", function() {
    $("section#painel img.img_painel").slideToggle("slow", function() {
      if($(this).is(":visible") == true) {
        $("section#painel a.bt_painel").text("Fechar estilo");
      } else {
        $("section#painel a.bt_painel").text("Abrir estilo");
      }
    });
  });
});

show_profile_big_image = function() {
  container = $('#profile_quiz img');
  profile = container.attr('class');
  container.attr('src', 'http://cdn-app-staging-0.olook.com.br/assets/profiles/big_'+profile+'.jpg');
}
;
