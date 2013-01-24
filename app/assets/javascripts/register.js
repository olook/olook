var masks = {
	cpf: function(){
		$("input.cpf").setMask({
	    mask: '999.999.999-99'
	  });
	},
	nasc: function(){
		$("input.nasc").setMask({
	    mask: '99/19/9999'
	  });
	} 
}

function cleanErrors(){
	var span_error = $(".span_error");
	var span_error_gender = $(".gender_fields .span_error").length;
	if (span_error.length > 0){
		$("input").keyup(function(){
			$(this).removeClass("input_error");
			$(this).next().fadeOut().delay(300).remove();
		});
	}else	if(span_error_gender == 1){
			$("#user_gender").one("change",function(){
					$("span.custom_select").removeClass("input_error");
					$(this).next().fadeOut().delay(300).remove();
			});	
	}
}

function changeSpan(){
	$("#user_gender").change(function(){
			txt = $("option:selected").val();
			if (txt == "0"){
				$("span.custom_select").text("").text("Mulher");
			}else if(txt == "1"){
				$("span.custom_select").text("").text("Homem");
			}else{
				$("span.custom_select").text("").text("Você é:");
			}
	});
}

$(function(){
	cleanErrors();
	changeSpan();
	masks.cpf();
	masks.nasc();
})

