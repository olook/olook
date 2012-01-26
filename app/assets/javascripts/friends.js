$(document).ready(function() {
  $("a.all_friends").live("click", function() {
    $("div#invite_friends div.list_mask").toggleClass("full", "");
  });
});
