$(document).ready(function() {
  $("section#address ol.addresses li.address_item p").live("click", function() {
    if($(this).parents("li").hasClass("add") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input").attr('checked', false);
      lists.removeClass("selected");
      $(this).parent("li").find('input').attr('checked', true);
      $(this).parent("li").addClass('selected');
      return false;
    }
  });
});
