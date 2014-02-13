if(!olook) var olook = {};
olook.customSelect = function(selector){
  var setText = function(e) {
    if(!e)
      var it = $(this)
    else
      var it = $(e);

    var txt = it.find('option:selected').text();
    it.prev().children("span").text(txt);
  }
  var els = $(selector).change(setText);
  for (var i = 0, l = els.length; i < l; i ++) {
    var el = els[i];
    setText(el);
  }
}
;
if(!olook) var olook = {};
olook.slider = function(selector, start_position, final_position){
  olook.slider.parseURL = function() {
    var l = window.location;
    olook.slider.baseURL = l.protocol + '//' + l.host + l.pathname;
    olook.slider.searchURL = l.search;
    var s = l.search;
    s = s.replace(/^\?/, '').split('&');
    olook.slider.searchQuery = {};
    $.each(s, function(idx, item) {
      var h = item.split('=');
      if(h[1] && h[0]) olook.slider.searchQuery[h[0]] = h[1]
    });
  }
  olook.slider.mountURL = function(othermaps) {
    if(!olook.slider.searchURL) olook.slider.parseURL();
    if(!othermaps) othermaps = {};

    var url = olook.slider.baseURL;
    var query = $.extend(true, {}, olook.slider.searchQuery, othermaps);
    url = url + '?' + $.param(query);
    return url;
  }
  $(selector).slider({
      range: true,
      min: 0,
      max: 600,
      values: [ isNaN(start_position) ? 0 : start_position, isNaN(final_position) ? 600 : final_position ],
      slide: function( event, ui ) {
        $("#min-value").val("R$ " + ui.values[ 0 ]);
        $("#max-value").val("R$ " + ui.values[ 1 ]);
        $("#min-value-label").text("R$ " + ui.values[ 0 ]);
        $("#max-value-label").text("R$ " + ui.values[ 1 ]);
      },

      stop: function(event,ui){
        window.location = olook.slider.mountURL({preco: (ui.values[ 0 ]+'-'+ui.values[ 1 ])});
      }
  });

  $("#min-value").val("R$ " + $("#slider-range").slider("values", 0));
  $("#max-value").val("R$ " + $("#slider-range").slider("values", 1));
  $("#min-value-label").text($("#min-value").val());
  $("#max-value-label").text($("#max-value").val());
}
;
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





var brands = {} || null;
brands = {
  init: function(){
    if(typeof start_position == 'undefined') start_position = 0;
    if(typeof final_position == 'undefined') final_position = 600;
    olook.slider('#slider-range', start_position, final_position);
    olook.customSelect('.filter select');
    olook.spy('p.spy');
    olook.changePictureOnhover('.async');
    brands.showSelectUl();
    brands.hideSelectUlOnBodyClick();
  },
  showSelectUl: function(){
    $("span.txt-filter").click(function(event){
      $(this).parent().siblings().find("ul, .tab_bg").hide();
      $(this).parent().siblings().find("span.txt-filter.clicked").removeClass("clicked");
      $(this).toggleClass('clicked').siblings().toggle();
      event.stopPropagation();
    });
  },
  hideSelectUlOnBodyClick: function(){
    $("html").click(function(){
      if($(".filter ul").is(":visible")){
        $(".filter ul:visible, .filter .tab_bg:visible").hide();
        $(".filter span.txt-filter.clicked").removeClass("clicked");
      }
    });
  }
}
$(function() {
  brands.init();
  $(".container-imgs ul").carouFredSel({
    auto: {
      duration: 1000
    },
    prev : {
      button : ".anterior",
      key : "left"
    },
    next : {
      button : ".proximo",
      key : "right"
    }
  });
});

