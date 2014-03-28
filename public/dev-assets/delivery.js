$(document).ready(function() {
  $("section#areas select#region").change(function() {
    target = $("select option:selected").val();
    target_position = $("#"+target).position().top;
    position = target_position - 40;
    $("html, body").animate({
      scrollTop: position
    }, 'fast');
  });
});
