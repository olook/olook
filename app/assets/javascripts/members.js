(function changeImg(){
  $("#user-info li a.fidelidade_desativado").click(function(e){
    var h;
    $("section.banner").length > 0 ? h = $("#post-to-wall").offset().top - 380 : h = $("#post-to-wall").offset().top - 280;
        
    $('html, body').animate({
      scrollTop: h
    }, 500, 'linear');
    $("#user-info ul").addClass("fixed");


    $(this).addClass("fidelidade");
    convide = $("#user-info li a.convide");
    if (!convide.hasClass("convide_desativado")){
      convide.addClass("convide_desativado");
    }
    
    $("#user-info li a.convide").on("click",function(e){
      $(this).removeClass("convide_desativado").off("click");
      fidelidade = $("#user-info li a.fidelidade_desativado");
      if (fidelidade.hasClass("fidelidade")){
        fidelidade.removeClass("fidelidade");
      }
      
      $('html, body, #user-info').animate({
        scrollTop: 0
      },{
        duration: 500,
        complete:function(){
          $('#user-info ul.fixed').removeClass("fixed");

        } 
      });

      e.preventDefault();
      e.stopPropagation();  
    });
    
    e.preventDefault();
    e.stopPropagation();
    
  });
})();


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

  $("section#post-to-wall a").live("click", function() {
    $("html, body").animate({
      scrollTop: 0
    }, 'slow');
  });

});
  $("#share-mail a.copy_link").zclip({
    path: "/assets/ZeroClipboard.swf",
    copy: function() { return $("section#share-mail input#link").val(); },
    afterCopy: function(){
      $("section#share-mail div.box_copy").fadeIn().delay(2000).fadeOut();
    }
  });
