$(document).ready(function() {
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
