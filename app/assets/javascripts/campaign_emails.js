var w = document.body.scrollWidth + 20,
h = document.body.scrollHeight + 20,
ml = -(w/2), mt = -(h/2);

if($("#ab_t").val() == null) {
  if($(".box-remember.success").length > 0){
    parent.top.$("#modal-campaign").css({
      "width"  	  : w +"px",
      "height" 	  : h +"px",
      "margin-top"  : mt+"px",
      "margin-left" : ml+"px",
      "overflow"	  : "hidden"	
    }).delay(250).fadeIn();
  }else if($(".box-cadastro").length > 0){
    parent.top.$("#modal-campaign").css({
      "width"  	  : w +"px",
      "height" 	  : h +"px",
      "margin-top"  : mt+"px",
      "margin-left" : ml+"px"
    }).delay(250).fadeIn();
  }else if($(".box-continue").length > 0){
    parent.top.$("#modal-campaign").css({
      "width"  	  : w +"px",
      "height" 	  : h +"px",
      "margin-top"  : mt+"px",
      "margin-left" : ml+"px"
    }).delay(200).fadeIn();
  }else{
    parent.top.$("#modal-campaign").css({
      "width"  	  : w +"px",
      "height" 	  : h +"px",
      "margin-top"  : mt+"px",
      "margin-left" : ml+"px"
    }).delay(200).fadeIn();
  }
}


function autoResize(id){
  var newheight;
  var newwidth;

  if(document.getElementById){
    newheight=document.getElementById(id).contentWindow.document.body.scrollHeight;
    newwidth=document.getElementById(id).contentWindow.document.body.scrollWidth;
  }

  document.getElementById(id).height= (newheight) + "px";
  document.getElementById(id).width= (newwidth) + "px";
}
var flag;
function checkEmail(e) {
  var email = $('#campaign_email_email').val();
  var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  if (!filter.test(email) || email === 'seunome@email.com.br' || email === 'Informe seu email aqui'){
    e.preventDefault();
    $('.error').fadeIn();
    email.focus;
    return flag=false;
  }else{
    $('.error').fadeOut('fast');
    $("#campaign_email").submit();
    return flag=true;
  }
}

$(function(){
  $('#campaign_email_email').focus(function(){
    if($(this).val() == 'seunome@email.com.br' || $(this).val() == 'Informe seu email aqui')
      $(this).val('');
  }).focusout(function(){
    if($(this).val() == '')
      $(this).val('seunome@email.com.br')
  });

  $('.bt-enviar').bind("click", function(e){
    checkEmail(e);
  })

  $(".close, .btn-continue, .close_pink").on("click", function(){
    parent.top.$("#modal-campaign,#overlay-campaign").fadeOut();
    parent.top.criaCookieAB("ms1","1", 200);

    if(typeof parent.top.showCartSummary == 'function') {
      parent.top.showCartSummary();
    } else if(typeof parent.top.o == 'object' && typeof parent.top.o.cartShow == 'function') {
      parent.top.o.cartShow();
    }
    // _gaq.push(['_trackEvent', 'Modal', 'Close', '']);
    if($(".dont_show").is(":checked")){
      parent.top.dontShow();
    }
  })


  $("input[type=submit]").click(function(){
    _gaq.push(['_trackEvent', 'Modal', 'Submit', '', , true]);
    if(flag==true )
      parent.top.$("#modal-campaign").fadeOut();
    if($(".dont_show").is(":checked")){
      parent.top.dontShow();
    }
  })

});
