olook = o = {} || null;

$(function(){
  o.init();
})

olook = o = {
  init: function(){
      o.menu();  
  },
  
  menu: function(){
    var $el, leftPos, newWidth, $magicLine = $("ul.default_new li#bar"), w = $("ul.default_new li .selected").outerWidth(), l = $("ul.default_new li .selected").position().left;

    $magicLine
    .width(w - 40)
    .css("left", l + 19)
    .data("origLeft", l + 19)
    .data("origWidth", w - 40);

    if($("ul.default_new li a").hasClass("selected")){
      $magicLine.fadeIn();
    }
    $("ul.default_new li").find("a").hover(function() {
        $el = $(this);
        leftPos = $el.position().left + 19;
        newWidth = $el.parent().width() - 40;

        if(!$magicLine.is(":visible")){
          $magicLine.fadeIn();
        }
        $magicLine.stop().animate({
            left: leftPos,
            width: newWidth
        });
    }, function() {
        $magicLine.stop().animate({
            left: $magicLine.data("origLeft"),
            width: $magicLine.data("origWidth")
        });
    });
  },
  
  newModal : function(content){
    var $modal = $("div#modal.promo-olook"), h = $(content).outerHeight(), w = $(content).outerWidth(), ml = -parseInt((w/2)), mt = -parseInt((h/2)), 
    heightDoc = $(document).height(), _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()), _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());

    $("#overlay-campaign").css({"background-color": "#000", 'height' : heightDoc}).fadeIn().bind("click", function(){
      _iframe = $modal.contents().find("iframe");
      console.log(_iframe);
      if (_iframe.length > 0){
        $(_iframe).remove();
      }
       $modal.fadeOut();
       $(this).fadeOut();
    });

    $modal.html(content)
    .css({
       'height'      : h,
       'width'       : w,
       'top'         : _top,
       'left'        : _left,
       /*'margin-left' : ml,
       'margin-top'  : mt*/
    })
   .append('<button type="button" class="close" role="button">close</button>')
   .delay(500).fadeIn().children().fadeIn();

   $("#modal button.close, #modal a.me").click(function(){
     _iframe = $modal.contents().find("iframe");
     console.log(_iframe);
     if (_iframe.length > 0){
       $(_iframe).remove();
     }
      $modal.fadeOut();
      $("#overlay-campaign").fadeOut();
   })

  }
  
}