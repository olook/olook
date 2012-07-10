$(function() {
  $("div#container_picture .product-map").draggable({
    cancel: 'p',
    containment: "parent",
    stop: function() {
      $.ajax({
        context: this,
        type: 'PUT',
        url: '/admin/lookbooks/' + $(this).data('lookbook_id') + '/images/' + $(this).data('image_id') + '/lookbook_image_maps/' + $(this).data('id'),
        data: {
          lookbook_image_map: {
            coord_y: $(this).css("top"),
            coord_x: $(this).css("left")
          }
        }
      }).done(function() {
        $(this).find("p:not('.confirm')").hide();
        $(this).append("<p class='confirm'>Salvo</p>");
        $(this).find("p.confirm").stop().animate({
          opacity: 0
        }, 3000, function() {
          $(this).remove();
          $(".product-map p").show();
        });
      });
    }
  });

  $('#product_result').hide();

  $("#product_name").autocomplete({
    source: '/admin/product_autocomplete',
    minLength: 2,
    select: function(event, ui) {
      $(this).value = ui.item.name;
      $('#lookbook_image_map_product_id').val(ui.item.id);
      $('#product_result img').attr('src', ui.item.image);
      $('#product_result span').text(ui.item.name);
      $('#product_result').show();
    }
  }).data( "autocomplete" )._renderItem = function(ul, item) {
    return $("<li></li>").data("item.autocomplete", item).append( "<a id='prod_" + item.id + "'><img src='" + item.image + "' width='50' height='50'/> " + item.name + "</a>").appendTo(ul);
  }

  $(document).on('ajax:success', '.delete-map', function() {
    $(this).closest('tr').fadeOut();
  });

   $("#new_lookbook_image_map").bind("ajax:success", function(event, data, status, xhr) {
      $("#container_picture").append(data);
    }).bind("submit", function(event, data, status, xhr){
      $('#product_result').hide();
    });
});
