if(!visualization_mode) var visualization_mode = "product";
if(!olook) var olook = {};
olook.changePictureOnhover = function(selector) {
  $(selector).mouseenter(function() {
    // debugger;
    var it = $(this).children().first();
    it.attr('src', it.data('backside-picture'));
  }).mouseleave(function() {
    var it = $(this).children().first();
    it.attr('src', it.data(visualization_mode));
  });
};
