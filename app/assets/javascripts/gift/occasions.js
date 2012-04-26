$(function() {
  initOccasion.fixSelects();

  $("input#recipient_name").autoGrowInput({
    comfortZone: 10,
    minWidth: 322,
    maxWidth: 600
  });

  $('select.custom_select').change(function() {
    p = $(this).parent();
    customSelect = $(this).siblings("span.select");

    selectWidth = $(customSelect).width();
    selectHeight = $(customSelect).height();
    $(p).css("width", selectWidth + 40);
    $(this).css("width", "100%");
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
