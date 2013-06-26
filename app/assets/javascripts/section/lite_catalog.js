var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 600;
  filter.sliderRange(start_position, final_position);
  filter.showSelectBoxText();
  filter.spy();
  filter.hideShow();
}
filter.parseURL = function() {
  var l = window.location;
  filter.baseURL = l.protocol + '//' + l.host + l.pathname;
  filter.searchURL = l.search;
  var s = l.search;
  s = s.replace(/^\?/, '').split('&');
  filter.searchQuery = {};
  $.each(s, function(idx, item) {
    var h = item.split('=');
    if(h[1] && h[0]) filter.searchQuery[h[0]] = h[1]
  });
}
filter.mountURL = function(othermaps) {
  if(!filter.searchURL) filter.parseURL();
  if(!othermaps) othermaps = {};

  var url = filter.baseURL;
  var query = $.extend(true, {}, filter.searchQuery, othermaps);
  url = url + '?' + $.param(query);
  return url;
}
filter.sliderRange = function(start_position, final_position){
  $("#slider-range").slider({
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
        window.location = filter.mountURL({preco: (ui.values[ 0 ]+'-'+ui.values[ 1 ])});
      }
  });

  $("#min-value").val("R$ " + $("#slider-range").slider("values", 0));
  $("#max-value").val("R$ " + $("#slider-range").slider("values", 1));
  $("#min-value-label").text($("#min-value").val());
  $("#max-value-label").text($("#max-value").val());
}
filter.showSelectBoxText = function(){
  $(".custom_select").each(function(){
    $(this).change(function(){
      txt = $('option:selected', this).text();
      $(this).prev().children("span").text(txt);
    })
  })
}
filter.spy = function(){
  $("p.spy").each(function(){
    $(this).on({
      click: function(e){
        $.ajax({
          url: $('span', this).data('url'),
          cache: 'true',
          dataType: 'script',
          beforeSend: function() {
            var width = $(document).width(), height = $(document).height();
            $('#overlay-campaign').width(width).height(height).fadeIn();
            $('#ajax-loader').fadeIn();
          },
          complete: function() {
            $('#ajax-loader').hide();
          }
        });
        e.stopPropagation();
        e.preventDefault();
      },
      mouseover: function() {
        var backside_image = $(this).next().children("img").attr('data-backside-picture');
        $(this).next().children("img").attr('src', backside_image);
      },
      mouseout: function() {
        var product_image = $(this).next().children("img").attr('data-product');
        $(this).next().children("img").attr('src', product_image);
      }
    });
  });
}
filter.hideShow = function(){
  $(".title-category").each(function(){
    $(this).on("click", function(){
      $(this).toggleClass("close").next().slideToggle();
    })
  })
}


$(filter.init);
