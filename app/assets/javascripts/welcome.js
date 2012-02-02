$(document).ready(function() {
  $("section#painel a.bt_painel").live("click", function() {
    $("section#painel img.img_painel").slideToggle("slow", function() {
      if($(this).is(":visible") == true) {
        $("body").addClass("bg_changed");
      } else {
        $("body").removeClass("bg_changed");
      }
    });
  });
});
