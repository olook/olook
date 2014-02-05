if(!olook) var olook = {};

olook.youtubeParser = function(url) {
  var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
  var match = url.match(regExp);
  if(match&&match[7].length==11) {
    return match[7];
  } else {
    return false;
  }
};

olook.youtubePlayer = function(youtube_id) {
  return "<div style='width:791px;height:445px;'><iframe width='791' height='445' src='//www.youtube.com/embed/"+ youtube_id +"?rel=0&enablejsapi=1&autoplay=1&vq=large' frameborder='0'></iframe></div>";
};

// TODO: Refatorar com olook.newModal para extrair a funcionalidade comum e
// reduzir duplicação.
olook.videoModalBuild = function(content){
  var $modal = $("div#modal.promo-olook"),
  h = $(content).outerHeight(),
  w = $(content).outerWidth(),
  ml = -parseInt((w/2)),
  mt = -parseInt((h/2)),
  heightDoc = $(document).height(),
  _top = Math.max(0, (($(window).height() - h) / 2) + $(window).scrollTop()),
  _left=Math.max(0, (($(window).width() - w) / 2) + $(window).scrollLeft());

  $("#overlay-campaign").css({"background-color": "#000", 'height' : heightDoc}).fadeIn().bind("click", function(){
    _iframe = $modal.contents().find("iframe") || null;

    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("#modal").hide();
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
    _iframe = $modal.contents().find("iframe") || null;

    if (_iframe.length > 0){
      $(_iframe).remove();
    }

    $("#modal").hide();
    $("#overlay-campaign").fadeOut();
  });
};

olook.videoModal = function(selector) {
  $(selector).click(function(e) {
    var url = $(this).attr("rel");
    var title = $("<div>").append($(this).siblings(".video_description").clone()).remove().html();
    var youtube_id = olook.youtubeParser(url);

    content = olook.youtubePlayer(youtube_id);
    content += title;
    olook.videoModalBuild(content);
    e.preventDefault();
  });
};
