if(!modal) var modal = {};

modal.show = function(content){
  console.log("showing!");
  var modalWindow = $("div#modal.promo-olook"),
  h = $(content).outerHeight(),
  w = $(content).outerWidth(),
  ml = -parseInt((w/2)),
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()),
  _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());

  $("#overlay-campaign").css({"background-color": "#000", 'height' : heightDoc}).fadeIn().bind("click", function(){
   _iframe = modalWindow.contents().find("iframe") || null;

    if (_iframe.length > 0){
      $(_iframe).remove();
    }

     $("#modal").hide();
     $(this).fadeOut();
  });

  modalWindow.html(content)
  .css({
     'height'      : h,
     'width'       : w,
     'top'         : _top,
     'left'        : _left
  })
 .append('<button type="button" class="close" role="button">close</button>')
 .delay(500).fadeIn().children().fadeIn();

 $("#modal button.close, #modal a.me").click(function(){
   _iframe = modalWindow.contents().find("iframe") || null;

   if (_iframe.length > 0){
     $(_iframe).remove();
   }

    $("#modal").hide();
    $("#overlay-campaign").fadeOut();
 })

}