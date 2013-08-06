quiz = {} || null;
previous_button = { } || null;

previous_button = {
  back: function() {
    $(this).prev().parent().parent().parent().animate({ "margin-left": "850px" }, "slow" );
  }
}
quiz = {
    respond_question: function(el, context) {
        el = $(el);
          el.on("click", function(){
                $(this).parent().parent().addClass("current_question")
                $("ol li.selected", context).removeClass("selected")
                $(this).addClass("selected")
                $(this).find("input").attr("checked", "checked");
                $(".current_question").animate({ "margin-left": "-850px" }, "slow" );
                $(this).parent().parent().removeClass("current_question").next().addClass("current_question")
            })
    }
}
$(function(){
    quiz.respond_question("li", ".current_question");
    $("#back").on("click", function(){
        $(".current_question").removeClass("current_question").prev().addClass("current_question")
        $(".current_question").animate({ "margin-left": "0px" }, "slow" );
    });
});
