$(function() {
  $('#product_result').hide();
  function log( message ) {
    $("<div/>").text( message ).prependTo("#log");
    $("#log").scrollTop(0);
  }

  $("#product_name").autocomplete({
    source: '/admin/product_autocomplete',
    minLength: 2,
    select: function(event, ui) {
      log(ui.item ? "Selected: " + ui.item.name + " aka " + ui.item.id : "Nothing selected, input was " + this.value);
      $(this).value = ui.item.name;
      $('#lookbook_image_map_product_id').val(ui.item.id);
      $('#product_result img').attr('src', ui.item.image);
      $('#product_result span').text(ui.item.name);
      $('#product_result').show();
    }
  }).data( "autocomplete" )._renderItem = function(ul, item) {
    return $("<li></li>").data("item.autocomplete", item).append( "<a id='prod_" + item.id + "'><img src='" + item.image + "' width='50' height='50'/> " + item.name + "</a>").appendTo(ul);
  }
});
