function search_delivery_time(cep){
  $.ajax({
    url:"shippings/"+cep,
    type: "GET",
    dataType: "json",
    success: function(data){
      $("#msg").text(data.message).removeClass("error");
			$("#box-ship form label").text("Pesquise outro CEP:")
    },
    error: function(data){
      $("#msg").text("Ops, não encontramos este CEP...").addClass("error");
			$("#box-ship form label").text("Vamos tentar mais uma vez? CEP:")
    }
  })
}

$(function(){
	$("#cep").setMask({
    mask: '99999-999'
  });

  $(".buscar").click(function(){
      cep = $("#cep");
      search_delivery_time(cep.val().replace("-",""));
			cep.val('').focus();
    })
  $(".close").click(function(){
		$("#box-ship").fadeOut();
	})		
})

