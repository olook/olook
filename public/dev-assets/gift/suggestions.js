$(function() {
  $("div#shoe_size_filter span").live("click", function(e) {
    $(this).siblings(".sizes").toggle();
    e.stopPropagation();
  });

  $("section#suggestions div.content ul li a").live("click", function(e) {
    var index = $(this).parent().index();
    $("section#suggestions div.content ul li").removeClass();
    $(this).parent().addClass("selected");
    console.log(index);
    if(index != 0) {
      var parent = $("section#suggestions div.content ul li")[index - 1];
      $(parent).addClass("no_border");
    } else {
      $("section#suggestions div.content ul li").removeClass("no_border");
    }
    $("section#suggestions_products").slideDown();
    var container_position = $("section#suggestions_products").offset().top - 40;
    initSuggestion.slideTo(container_position);
    e.preventDefault();
  });

  $("div.box.shoes ul li label").on("click", function(e) {
    $(this).next().attr("checked",true);
    $("div.box.shoes ul li").removeClass();
    $(this).parent().addClass("selected");
    e.preventDefault();
  });

  $("html").live("click", function() {
    $("div#shoe_size_filter div.sizes").hide();
  });

});

initSuggestion = {
  slideTo : function(container_position) {
    position = container_position -40;
    $("html, body").animate({
      scrollTop: position
    }, 'normal');
  }
}
;
