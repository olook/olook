if(!olook) var olook = {};
olook.spy = function(selector){
  $(selector).click(function(e){
    e.preventDefault();
    var url = $(this).find('span.spy-text').data('url');
    $.ajax({
      url: url,
      cache: 'true',
      dataType: 'script',
      beforeSend: function() {
        var width = $(document).width(), height = $(document).height();
        $('#overlay-campaign').width(width).height(height).fadeIn();
        $('#ajax-loader').fadeIn();
      },
      success: function() {
        $('#ajax-loader').hide();
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
