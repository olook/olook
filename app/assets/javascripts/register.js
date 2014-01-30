//= require plugins/jquery.meio.mask.js

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
		$("input").focusin(function(){
			$(this).removeClass("input_error");
			$(this).parents('div').siblings('.span_error').first().fadeOut().delay(300).remove();
		});
	}
	if(span_error_gender === 1){
		$("select#user_gender").click(function(){
			$("span.custom_select").removeClass("input_error");
			$(this).parents('div').siblings('.span_error').fadeOut().delay(300).remove();
		});	
	}
}

function changeSpan(){
	txt = $("option:selected").val();
	if (txt == "0"){
		$("span.custom_select").text(" ").delay(100).text("Mulher");
	}else if(txt == "1"){
		$("span.custom_select").text(" ").delay(100).text("Homem");
	}else{
		$("span.custom_select").text(" ").delay(100).text("Selecione");
	}
}

$(function(){
	$("#user_gender").change(function(){changeSpan()})
	cleanErrors();
	changeSpan();
	masks.cpf();
	masks.nasc();
})

