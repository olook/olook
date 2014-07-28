if(!olook) var olook = {};

olook.closeNewModal = function(id, close_callback) {
  var $modal = $('#' + id);
  $modal.fadeOut(function(){
    $modal.remove();
  });
  $('#overlay-campaign').fadeOut(function(){
    $('#ajax-loader').show();
  });
  if(typeof close_callback === 'function') close_callback();
}

olook.newModal = function(content, a, l, background_color, close_callback, afterLoaded){
  var id = "new-modal-" + Date.now();
  var $modal = $('<div id="'+ id +'" class="modal"></div>');
  $modal.prependTo('body');

  if(/%$/.test(a)){
    var h = parseInt(a),
    height = h + '%';
    var mt = -parseInt((h/2));
    marginTop = mt + '%';
  } else if(/\d+/.test(a)) {
    var height = a + 'px';
    var mt = -parseInt((a/2)),
    marginTop = mt + 'px';
  } else {
    a = $("img", content).outerHeight()
    var height = a + 'px';
    var mt = -parseInt((a/2)),
    marginTop = mt + 'px';
  }

  if(/%$/.test(l)){
    var w = parseInt(l),
    width = w + '%';
    var ml = -parseInt((w/2));
    marginLeft = ml + '%';
  } else if(/\d+/.test(l)) {
    var width = l + 'px';
    var ml = -parseInt((l/2)),
    marginLeft = ml + 'px';
  } else {
    l = $("img", content).outerHeight()
    var width = l + 'px';
    var ml = -parseInt((l/2)),
    marginLeft = ml + 'px';
  }

  if(!background_color) background_color = "#000";

  $("#overlay-campaign")
  .css({"background-color": background_color, 'height' : $(document).height()})
  .fadeIn()
  .bind("click", function(){
    olook.closeNewModal(id, close_callback);
  });

  $('#ajax-loader').hide();
  $modal.html(content)
  .css({
    'height'      : height,
    'width'       : width,
    'top'         : '50%',
    'left'        : '50%',
    'margin-left' : marginLeft,
    'margin-top'  : marginTop,
    'position': 'fixed',
    'z-index': 10002
  }).append('<button type="button" class="close-new-modal" role="button">close</button>').delay(500).fadeIn().children().show();

  $(".close-new-modal, .js-close-modal, #" + id + " a.me").click(function(){
    olook.closeNewModal(id, close_callback);
  });

  if(typeof afterLoaded === 'function') afterLoaded();
  return id;
};

olook.addToCartModal = function(content, a, l, background_color){
  olook.newModal(content, a, l, background_color, null, function(){
    $('.close-new-modal').hide();
    $('.modal').css('background-color', 'rgba(255,255,255,0.7)');
    $("button.js-go_to_cart").click(function(){
      olookApp.publish('product:redirect_to_cart');
    });
  });
};

olook.showLoadingScreen = function(){
  $("#overlay-campaign").css({"background-color": '#FFF', 'height' : $(document).height()}).fadeIn();
};

olook.hideLoadingScreen = function(){
  $("#overlay-campaign").fadeOut();
};
