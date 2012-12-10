function criaCookie(chave, value) { 
	 var date = new Date();
	 var minutes = 30;
	 date.setTime(date.getTime() + (minutes * 60 * 1000));
	$.cookie(chave, value, { expires: date, path: '/' });
} 

function lerCookie(chave) { 
  return $.cookie(chave);
}

function search_delivery_time(cep){
  $.ajax({
    url:"/shippings/"+cep,
    type: "GET",
    dataType: "json",
    success: function(data){
      $("#msg").html(data.message).removeClass("error");
      $("#box-ship form label").text("Pesquise outro CEP:")
    },
    error: function(data){
      $("#msg").text("Ops, não encontramos este CEP...").addClass("error");
			$("#box-ship form label").text("Vamos tentar mais uma vez? CEP:")
    }
  })
}


if(lerCookie("boxShip") == null){
	$("#box-ship").fadeIn();
	$("#cep").setMask({
	   mask: '99999-999'
	 });
	 $(".buscar").click(function(){
	    cep = $("#cep").val().replace("-","");
	    search_delivery_time(cep);
	 })
}
$(".close-ship").click(function(){
		$("#box-ship").fadeOut();
		criaCookie("boxShip","sim");
})		


