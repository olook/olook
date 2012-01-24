$(document).ready(function() {
  StylistInit.slideProductAnchor();

  $("section#stylist div.profile a").live("click", function() {
    container_position = $("div#products").position().top;
    StylistInit.slideToProducts(container_position);
  });
});

StylistInit = {
  slideProductAnchor : function() {
    anchor = window.location.hash;
    container = $(anchor+"_container");
    if($(container).length > 0) {
      container_position = $(container).position().top;
      position = container_position - 10;
      $("html, body").animate({
        scrollTop: position
      }, 'slow');
    }
  },
  slideToProducts : function(container_position) {
    position = container_position - 40;
    $("html, body").animate({
      scrollTop: position
    }, 'fast');
  }
}
