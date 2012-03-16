$(document).ready(function() {
  $("#my_account ul.shoes_size li label").live("click", function() {
    $(this).parents("ul.shoes_size").find("li").removeClass("selected");
    $(this).parent().addClass("selected");
  });
});
