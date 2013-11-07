$(document).ready(function() {
    // $(".subtitle_site").click(function() {
    //     $(this).find("ul").first().show("slow");
    //     $(this).removeClass("active");
    //     $(".active").hide();
    // });
    // $(".bt_back").click(function() {
    //     $(".question_box").hide("slow");
    //     $(".subtitle_site").addClass("active");
    //     $(".active").show();
    // });
    // $(".question").click(function() {
    //     $(this).find(".answer").find("p").show()
    // });

  function showFirstUl(el) {
    el = $(el);
    el.siblings('li').hide();
    var firstUl = el.children();
    firstUl.show();
    firstUl.children("li.question").show();
  }
  $('ul.click_show_child li.question, ul.click_show_child li.subtitle_site.active').click(function(e){
    e.stopPropagation();
    showFirstUl(this);
  });
  $('.bt_back').click(function(e){
    e.preventDefault();
    $('ul.click_show_child').children('li').show().find('ul.question_box, .answer').hide();
  });
});
// $(".subtitle_site").children("#funcionamento").find(".teste").show()