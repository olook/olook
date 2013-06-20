var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 400;
  filter.sliderRange(start_position, final_position);
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
$(filter.init);
