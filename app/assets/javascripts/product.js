$(document).ready(function() {
  $("div#pics_suggestions ul#thumbs li a").live("click", function() {
    thumb_url = $(this).find('img').attr("src").split("thumb_");
    domain = thumb_url[0];
    new_image = thumb_url[1];
    full_image = $("div#pics_suggestions div#full_pic a img");
    full_image.attr("src", domain+new_image);
    return false;
  });

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
