function search_delivery_time(cep){
  $.ajax({
    url:"shippings/"+cep,
    type: "GET",
    dataType: "json",
    success: function(data){
      $("#msg").text(data.message);
    },
    error: function(data){
      $("#msg").text("Nao achamos o seu CEP. Tente de novo");
    }
  })
}

$(function(){
  $(".enviar").click(
    function(){
      cep = $(".cep").val();
      search_delivery_time(cep);
    }
  )
})

