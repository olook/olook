if(!visualization_mode) var visualization_mode = "product";
if(!olook) var olook = {};
olook.changePictureOnhover = function(selector, hover_picture) {
  if(!hover_picture){
    hover_picture = 'backside-picture';
  } else {
    hover_picture = 'hover';
  }
  $(selector).mouseenter(function() {
    var it;
    if($(this).is('img')){
      it = $(this);
    }else{
      it = $(this).children('img:first');
    }
    if(!it.data('original')){
      it.data('original', it.attr('src'));
    }
    it.attr('src', it.data(hover_picture));
  }).mouseleave(function() {
    var it;
    if($(this).is('img')){
      it = $(this);
    }else{
      it = $(this).children('img:first');
    }
    it.attr('src', it.data('original'));
  });
};
if(!olook) var olook = {};
olook.spy = function(selector){
  $(selector).click(function(e){
    e.preventDefault();
    var url = $(this).data('url');
    if(_gaq){
      var source = url.match(/from=(\w+)/);
      if(source){
        source = source[1];
      } else {
        source = 'Product';
      }
      _gaq.push(['_trackEvent', source, 'clickOnSpyProduct', url.replace(/\D/g, '')]);
    }
    $.ajax({
      url: url,
      cache: 'true',
      dataType: 'html',
      beforeSend: function() {
        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();
        $('#ajax-loader').fadeIn();
      },
      success: function(dataHtml) {
        $('#ajax-loader').hide();

        initQuickView.inQuickView = true;

        if($("div#quick_view").size() == 0) {
          $("body").prepend("<div id='quick_view'></div>");
        }

        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();

        var script = $(dataHtml).find('script:first').attr('src');

        $('#quick_view')
        .html(dataHtml)
        .css("top", $(window).scrollTop()  + 35)
        .fadeIn(100);

        $('#quick_view ol.colors li a').attr('data-remote', true);
        $("ul.social li.email").hide();


        $('#close_quick_view, #overlay-campaign').on("click", function() {
          $('#quick_view, #overlay-campaign').fadeOut(300);
        });
        if(typeof initProduct !== 'undefined') {
          initProduct.loadAddToCartForm();
        } else {
          $.getScript(script);
          $.getScript(script);
        }

        accordion();
        delivery();
        guaranteedDelivery();

        load_first_image();
        load_all_other_images();

        if (typeof initSuggestion != 'undefined') {
          initSuggestion.checkIfProductIsAlreadySelected();
        }
        initQuickView.productZoom();

        try{
          FB.XFBML.parse();
        }catch(ex){}
      },
      error: function() {
        window.location = url;
      }
    });
  }).mouseover(function() {
    var img = $(this).parent(".product").find("img");
    img.attr('src', img.data('backside-picture'));
  }).mouseout(function() {
    var img = $(this).parent(".product").find("img");
    img.attr('src', img.data('product'));
  });
};
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

  }).append('<button type="button" class="close" role="button">close</button>').delay(500).fadeIn().children().show();


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

olook.showLoadingScreen = function(){
  $("#overlay-campaign").css({"background-color": '#FFF', 'height' : $(document).height()}).fadeIn();
};

olook.hideLoadingScreen = function(){
  $("#overlay-campaign").fadeOut();
};




$(function(){
  olook.init();
  olook.spy('.spy');
});

o = olook;

$(function(){
  new ImageLoader().load('look_thumbnail');
  olook.changePictureOnhover('.async');
});
