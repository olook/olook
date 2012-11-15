$(function() {
  $("div#shoe_size_filter span").live("click", function(e) {
    $(this).siblings(".sizes").toggle();
    e.stopPropagation();
  });

  $("html").live("click", function() {
    $("div#shoe_size_filter div.sizes").hide();
  });
});
