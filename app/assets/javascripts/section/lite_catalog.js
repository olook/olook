var filter = {};
filter.init = function(){
  if(typeof start_position == 'undefined') start_position = 0;
  if(typeof final_position == 'undefined') final_position = 400;
  filter.sliderRange(start_position, final_position);
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
        $("input#price").val(ui.values[ 0 ]+'-'+ui.values[ 1 ]);
      }
  });

  $("#min-value").val("R$ " + $("#slider-range").slider("values", 0));
  $("#max-value").val("R$ " + $("#slider-range").slider("values", 1));
  $("#min-value-label").text($("#min-value").val());
  $("#max-value-label").text($("#max-value").val());
}
$(filter.init);
