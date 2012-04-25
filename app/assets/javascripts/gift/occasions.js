$(function() {
  initOccasion.fixSelects();

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
