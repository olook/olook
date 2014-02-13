$(document).ready(function() {
  $("div.press_release #top_container ul.tabs li a").live("click", function() {
    $(this).parents("ul.tabs").find("li a").removeClass("selected");
    $(this).addClass("selected");
    el = $(this).attr('rel');
    $("div.press_release div.content_tabs").hide();
    $("#"+el).show();
  });
});
