$(function () {
  $("div#calendar ul#months li a").live("click", function(event) {
    $("div#calendar ul#months li a").removeClass("selected");
    $(this).addClass("selected");
    event.preventDefault();
  });
});
