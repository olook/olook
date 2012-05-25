$(function() {
  initOccasion.fixSelects();

  $("input#recipient_name").autoGrowInput({
    comfortZone: 10,
    minWidth: 320,
    maxWidth: 650
  });

  $('select.custom_select').change(function() {
    p = $(this).parent();
    customSelect = $(this).siblings("span.select");

    selectWidth = $(customSelect).width();
    selectHeight = $(customSelect).height();
    $(p).css("width", selectWidth + 40);
    $(this).css("width", "100%");
  });

  $('#occasion_gift_occasion_type_id').change(function() {
    index = $('#occasion_gift_occasion_type_id').val();
    var occasion = $.grep(occasions, function(n, i){
      return n.id == parseInt(index);
    });
    occasionObj = occasion[0];
    $("#occasion_day").val(occasionObj.day).change();
    $("#occasion_month").val(occasionObj.month).change();
    $("#recipient_gift_recipient_relation_id").val(occasionObj.gift_recipient_relation_id).change();
  });
});

initOccasion = {
  fixSelects : function() {
    $('select.custom_select').each(function() {
      p = $(this).parent();
      customSelect = $(this).siblings("span.select");

      selectWidth = $(customSelect).width();
      selectHeight = $(customSelect).height();
      $(p).css("width", selectWidth + 40);
      $(this).css("width", "100%");
    });
  }
}
