$(document).ready(function() {
  $("section#address ol.addresses li.address_item p").live("click", function() {
    if($(this).parents("li").hasClass("add") == false) {
      lists = $(this).parents("ol").find("li");
      lists.find("input").attr('checked', false);
      lists.removeClass("selected");
      $(this).parent("li").find('input').attr('checked', true);
      $(this).parent("li").addClass('selected');
      return false;
    }
  });

  $("form#new_address input[type='text']").live("keyup", function() {
    var limitOfInputs = 8;
    var notNullInputs = 0
    inputs = $("form#new_address input[type='text']");
    $(inputs).each(function(index) {
      if($(this).val() != '' && $(this).parent('li').hasClass('complement') == false) {
        notNullInputs = notNullInputs + 1;
      }
    });
    if(notNullInputs == limitOfInputs) {
      $("section.sidebar input[type='submit']").removeAttr('disabled').removeClass('disabled');
    } else {
      $("section.sidebar input[type='submit']").addClass('disabled')
      $("section.sidebar input[type='submit']").attr('disabled', 'disabled');
    }
  });
});
