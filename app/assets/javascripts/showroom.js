$(document).ready(function() {
  $("#showroom div.products_list a.more").toggle(function() {
    el = $(this).attr('rel');
    box = $(this).parents('.type_list').find("."+el);
    box.slideDown();
    },
    function() {
      el = $(this).attr('rel');
      box = $(this).parents('.type_list').find("."+el);
      box.slideUp();
    }
  );
});
