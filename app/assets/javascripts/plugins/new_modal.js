if(!olook) var olook = {};

olook.newModal = function(content, a, l, backgroud_color){
  var $modal = $("div#modal.promo-olook"),
  h = a > 0 ? a : $("img",content).outerHeight(),
  w = l > 0 ? l : $("img",content).outerWidth(),
  ml = -parseInt((w/2)),
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()),
  _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());
  backgroud_color = backgroud_color || "#000";

  $("#overlay-campaign").css({"background-color": backgroud_color, 'height' : heightDoc}).fadeIn().bind("click", function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("button.close").remove();
    $modal.fadeOut();
    $(this).fadeOut();
  });

  $modal.html(content)
  .css({
    'height'      : h+"px",
    'width'       : w+"px",
    'top'         : '50%',
    'left'        : '50%',
    'margin-left' : ml,
    'margin-top'  : mt,
    'border-bottom': '1px solid #000'

  })
  .append('<button type="button" class="close" role="button">close</button>')
  .delay(500).fadeIn().children().show();



  $("button.close, #modal a.me").click(function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("button.close").remove();
    $modal.fadeOut();
    $("#overlay-campaign").fadeOut();
  })

};
