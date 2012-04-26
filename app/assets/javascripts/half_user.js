$(function() {
  $("#container_forms > p a").live("click", function(e) {
    $(this).parent().hide();
    $("#container_forms form.login").show();
    e.preventDefault();
  });
});
