$(document).ready(function() {
  $("div#infos div.size ol li").live('click', function() {
    if($(this).hasClass("unavailable") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input").attr('checked', false);
      lists.removeClass("selected");
      $(this).find('input').attr('checked', true);
      $(this).addClass('selected');
      return false;
    }
  });
});
