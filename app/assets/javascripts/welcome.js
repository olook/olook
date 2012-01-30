$(document).ready(function() {
  $("section#painel a.bt_painel").live("click", function() {
    $("section#painel img.img_painel").slideToggle("slow");
  });
});
