function criaCookie(chave, value) { 
	 var date = new Date();
	 var minutes = 30;
	 date.setTime(date.getTime() + (minutes * 60 * 1000));
	$.cookie(chave, value, { expires: date, path: '/' });
} 

function lerCookie(chave) { 
  return $.cookie(chave);
}

function delCookie(name){
	$.cookie(name, "", { expires: -1, path: '/' });
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

function maxShippingBox(){
	$("a.maximize").click(function(){
		$("#box-ship").animate({bottom: '0px'});
		delCookie("boxShip");
		$(this).remove();
	})
}

function animateBox(){
	$("#box-ship")
	.animate({bottom:'-44px'})
	.append('<a href="javascript:void(0);" class="maximize">Maximizar</a>');
	maxShippingBox();
}

$(function(){
	
	if(lerCookie("boxShip") == "sim"){
		animateBox();
	}
	
	$("#box-ship").fadeIn();
	$("#cep").setMask({
	   mask: '99999-999'
	 });
	 $(".buscar").click(function(){
	    cep = $("#cep").val().replace("-","");
	    search_delivery_time(cep);
	 })

	$(".close-ship").click(function(){
		animateBox();
		if(lerCookie("boxShip") == null)
			criaCookie("boxShip","sim");
	})		
})

