$(document).ready(function() {
  $("form.address_new_edit input[type='text']").live("keyup", function() {
    var limitOfInputs = 8;
    var notNullInputs = 0
    inputs = $("form.address_new_edit input[type='text']");
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
