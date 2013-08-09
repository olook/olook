quiz = {} || null;
previous_button = { } || null;

previous_button = {
  back: function() {
    $(this).prev().parent().parent().parent().animate({ "margin-left": "850px" }, "slow" );
  }
}
quiz = {
  respond_question: function(el) {
    var el = $(el);
    el.on("click", function(){
      var context = $(this).parents('ol');
      $(this).parent().parent().addClass("current_question");
      context.find("li.selected").removeClass("selected");
      $(this).addClass("selected");
      $(this).find("input").attr("checked", "checked");
    });
  },

  finish: function() {
  $("li.check-input").on("click", function(){
    var context = $(this).parents('ol');
    context.find("li.selected").removeClass("selected");
    $(this).addClass("selected");
    $(this).find("input").attr("checked", "checked");
    });

  },

    next_question: function() {
      $("li.next-step-on-click").on("click", function(){
        $(".current_question").animate({ "margin-left": "-850px" }, "slow" );
        //$(".current_question:last").removeClass("current_question").next().addClass("current_question");
        $(this).parent().parent().removeClass("current_question").next().addClass("current_question");

        if ($(".last_step").hasClass("current_question")) {
            $(".end_quiz_button").show()
        };

      });
    },

    calculate_bar: function(el) {
     var el = $(el), questions = $(".step"), questions_count = questions.length;

     el.on("click", function(){
        for (i=0; i <= questions_count; i++) {
          if ($(questions[i]).hasClass("current_question")) {
            var percentage =  (i/questions_count) * 100
            $(".quiz_pink_bar").width(percentage.toString() + "%");
            switch(percentage){
              case(25):
                $(".start_quiz").show();
                $(".end_quiz").hide();
                $(".half_quiz").hide();
              break;
              case(50):
                $(".start_quiz").hide();
                $(".end_quiz").hide();
                $(".half_quiz").show();
              break;
             case(75):
                $(".start_quiz").hide();
               $(".half_quiz").hide();
               $(".end_quiz").show();
             break;
            }
          };
        }
      });
    }
}


$(function(){
  quiz.respond_question("li.next-step-on-click");
  quiz.next_question();
  quiz.finish();
  quiz.calculate_bar("li");
  $("#back").on("click", function(){
    var current_question = $(".current_question:last");
    var previous_question = $(".current_question:last").prev();
    $(".current_question").removeClass("current_question");
    previous_question.animate({ "margin-left": "0px" }, "slow" ).addClass("current_question");
    quiz.calculate_bar("#back");
    if (!$(".last_step").hasClass("current_question")) {
      $(".end_quiz_button").hide()
    };
  });
});
