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
