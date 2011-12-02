$(document).ready(function() {
  $('.import-dropdown').hide();
  $("#import-contacts .gmail").click(function(event){
    event.preventDefault();
    $(".import-dropdown > span").removeClass();
    $("#import-contacts .import-dropdown").show();
    var email_provider = $(this).attr('class');
    $("#email_provider").val(email_provider);
    $(".import-dropdown > span").addClass(email_provider);
  });

  $('.import-dropdown a').live('click', function(event){
    event.preventDefault();
    $(this).parent().hide();
  });

  $(document).bind('keydown', 'esc',function () {
    $('.import-dropdown').hide();
    return false; 
  });

  $('#invite_list input#select_all').click(function() {
    $(this).parents('form').find('#list :checkbox').attr('checked', this.checked);
  });

  $('nav.invite ul li a').live('click', function () {
    cl = $(this).attr('class');
    $('#'+cl).slideto({ highlight: false });
  });

  if($("#showroom").length > 0) {
    anchor = window.location.hash;
    $(anchor+"_container").slideto({ highlight: false });
  }
  $('nav.menu ul.product_anchors li a').click(function() {
    cl = $(this).parent("li").attr("class");
    $("#"+cl+"_container").slideto({ highlight: false });
  });
});

