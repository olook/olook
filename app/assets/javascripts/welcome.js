$(document).ready(function() {
  $("section#painel a.bt_painel").live("click", function() {
    $("section#painel img.img_painel").slideToggle("slow", function() {
      if($(this).is(":visible") == true) {
        $("section#painel a.bt_painel").text("Fechar estilo");
        $("body").addClass("bg_changed");
      } else {
        $("section#painel a.bt_painel").text("Abrir estilo");
        $("body").removeClass("bg_changed");
      }
    });
  });
});
