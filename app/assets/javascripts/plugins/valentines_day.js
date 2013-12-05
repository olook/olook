/**** TO VALENTINES DAY ****/
function showAlert(){
  $("html, body").animate({ scrollTop: 0 }, "slow");
  $('#error-messages').css("height", "40px").slideDown('1000', function() {
    $('p.alert', this).text("Por favor, antes de pedir, selecione o tamanho do produto");
  }).delay(5000).slideUp();
}

function getSize(){
  if(window.location.href.indexOf('size') > 0){
    var size = window.location.href.slice(window.location.href.indexOf('size')).split('=');
    $("div.line.size ol li.size_"+size[1]).addClass("selected").find("input[type='radio']").prop('checked', true);
  }
}
/**** END TO VALENTINES DAY ****/