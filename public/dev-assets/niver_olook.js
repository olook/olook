$("#infografico ul li").each(function(){
    $(this).mouseover(function(){
        $("p", this).removeClass("only-number");
        $(".titulo, .frase, a", this).css("display", "block");
    }).mouseout(function(){
        $("p", this).addClass("only-number");
        $(".titulo, .frase, a", this).css("display", "none");
    })

})

$("#brasil li").each(function(){
	
	$(this).mouseover(function(){
		regiao = $(this).attr("id");
		$(this).addClass("hover").siblings().removeClass("hover");			
		$("."+regiao,"#frases").removeClass("dn").siblings().addClass("dn");
	}).mouseout(function(){
		regiao = $(this).attr("id");
		$(this).removeClass("hover");
		$("."+regiao,"#frases").addClass("dn");
		if(!$("#brasil li#sudeste").hasClass("hover")){
			$("#brasil li#sudeste").addClass("hover");
			$('#frases li.sudeste').removeClass("dn");
		}
	})
})
;
