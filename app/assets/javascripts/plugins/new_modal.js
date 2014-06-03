if(!olook) var olook = {};

olook.newModal = function(content, a, l, background_color, close_callback){
  var $modal = $("div#modal.promo-olook"),
  h = a > 0 ? a : $("img",content).outerHeight(),
  w = l > 0 ? l : $("img",content).outerWidth(),
  ml = -parseInt((w/2)),
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()),
  _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());
  background_color = background_color || "#000";

  $("#overlay-campaign").css({"background-color": background_color, 'height' : heightDoc}).fadeIn().bind("click", function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("button.close").remove();
    $modal.fadeOut();
    $(this).fadeOut();
    close_callback();
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

  }).append('<button type="button" class="close" role="button">close</button>').delay(500).fadeIn().children().show();


  $("button.close, #modal a.me").click(function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("button.close").remove();
    $modal.fadeOut();
    $("#overlay-campaign").fadeOut();
    close_callback();
  })

};

olook.addToCartModal = function(content, a,close_callback){
  var $modal = $("div#modal.promo-olook"),
  h = a > 0 ? a : $("img",content).outerHeight(),
  w = "100%",
  ml = 0,
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  background_color = background_color || "#000";

  $("#overlay-campaign").css({"background-color": background_color, 'height' : heightDoc}).fadeIn().bind("click", function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }
    
    $modal.fadeOut();
    $(this).fadeOut();
    close_callback();
  });

  $("#overlay-campaign").html("");

  $modal.html(content)
  .css({
    'height'        : h+"px",
    'width'         : w,
    'top'           : '50%',
    'left'          : 0,
    'margin-left'   : ml,
    'margin-top'    : mt,
    'border-bottom' : '1px solid #000',
    'background'    : 'none',
    'background'    : 'rgba(255,255,255,0.7)'

  }).delay(500).fadeIn().children().show();


  $("button.js-close_modal, #modal a.me").click(function(){
    _iframe = $modal.contents().find("iframe");
    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $modal.fadeOut();
    $("#overlay-campaign").fadeOut();
    close_callback();
  });

  $("button.js-go_to_cart").click(function(){
    olookApp.publish('product:redirect_to_cart');
  });

};

olook.showLoadingScreen = function(){
  $("#overlay-campaign").css({"background-color": '#FFF', 'height' : $(document).height()}).fadeIn();
};

olook.hideLoadingScreen = function(){
  $("#overlay-campaign").fadeOut();
};
