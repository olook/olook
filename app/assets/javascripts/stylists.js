$(document).ready(function() {
  $("section#stylist div.profile a").live("click", function() {
    container_position = $("div#products").position().top;
    StylistInit.slideToProducts(container_position);
  });
});

StylistInit = {
  slideToProducts : function(container_position) {
    position = container_position - 40;
    $("html, body").animate({
      scrollTop: position
    }, 'fast');
  }
}
