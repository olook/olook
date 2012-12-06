function shipping(cep){
	$.ajax({
		url:"shippings/"+cep+".json",
		type: "GET",
		success: function(data){
			$("#msg").text(data.message);
		}
	})
}

$(function(){
	$("#overlay-campaign").delay(100).fadeIn();
	$("#modal-campaign").append('<iframe src="/campaign_emails/new" border="0" frameborder="0" height="100%" width="100%"></iframe>');

	$(".enviar").click(function(){
		cep = $(".cep").val();
		shipping(cep);
	})

})

