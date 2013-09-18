if(!olook) var olook = {};
olook.spy = function(selector){
  $(selector).click(function(e){
    e.preventDefault();
    var url = $(this).data('url');
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
