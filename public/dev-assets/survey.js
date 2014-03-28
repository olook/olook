$(document).ready(function() {
  init.index = 1;
  init.locked = false;

  init.carousel();
  init.bindActions();
  init.tracker();

  $('#survey').bind('keydown', 'tab',function (evt) {
    return false;
  });

  $('.about ul li').live('click', function() {
    $(this).parent('ul').find('li').removeClass('selected');
    $(this).addClass('selected');
  });

  $(".about").live("change", function(){
    var limitOfCheckedAnswers = 2;
    if ($('.about').find(":radio:checked").length == limitOfCheckedAnswers &&
      $(".about select[name='day']").val()  != 'Dia' &&
      $(".about select[name='month']").val()  != 'Mês' &&
      $(".about select[name='year']").val()  != 'Ano'){

        var birthdate = {
          day: $(".about select[name='day']").val(),
          month: $(".about select[name='month']").val(),
          year: $(".about select[name='year']").val()
        }
        $.get("/survey/check_date.json", birthdate, function(data) {
          if (data.message != null){
            $('.alert').html(data.message);
            $('.alert').parent().slideDown('1000', function() {
              $('.alert').parent().delay(5000).slideUp();
            });
            $(".about .buttons li").addClass("grey-button");
            $(".about .buttons li input").addAttr("disabled");
          }else{
            $(".about .buttons li").removeClass("grey-button");
            $(".about .buttons li input").removeAttr("disabled");
          }
        },"json");
    }else{
      $(".about .buttons li").addClass("grey-button");
    }
  });

  $('.colors .stars label').hover(function() {
    var elementID = $(this).parents('ol').attr('id');

    if ($('.colors .stars label').parents('#' + elementID).find('li').hasClass('click_star')) {
      $('.colors .stars label').parents('#' + elementID).find('li').removeClass('starred');
    }
    $(this).parent().addClass('starred').prevAll().addClass('starred');

  }, function() {
    var elementID = $(this).parents('ol').attr('id');

    if ($('.colors .stars label').parents('#' + elementID).find(':radio:checked').length == 1) {
        $('.colors .stars label').parents('#' + elementID).find('li').removeClass('starred');
        $('.colors .stars label').parents('#' + elementID).find('li.click_star').addClass('starred').prevAll().addClass('starred');
    }else{
      $('.colors .stars label').parents('#' + elementID).find('li').removeClass('starred');
    }
  });

  $('.colors div label').click(function() {
    var elementID = $(this).parents('ol').attr('id');

    $(this).parents('#' + elementID).find('li').removeClass('click_star')
    $(this).parent('li').addClass('click_star')
    $(this).parent().addClass('starred').prevAll().addClass('starred')


    if($('li.colors').find(':radio:checked').length == 4){
      $('#next_link').click();
    }
  });
});

init = {
  carousel : function() {
               $('#survey').jcarousel({
                 initCallback: init.mycarousel_initCallback,
                 itemFirstInCallback : {
                    onBeforeAnimation : init.lockScroll,
                    onAfterAnimation : init.showArrow
                 },
                 buttonPrevHTML : null,
                 scroll: 1
               });
             },

  lockScroll: function(instance, item, index, state) {
    init.locked = true;
  },

  unlockScroll: function(instance, item, index, state) {
    init.locked = false;
  },

  showArrow : function(instance, item, index, state) {
                $('#asynch-load').click();

                var tracker_index = Math.round(index / 2);
                $("#tracker > li").removeClass('selected');
                $("#tracker").find('li#' + tracker_index).addClass('selected');

                if(index == '1') {
                  $('.jcarousel-prev').css('display', 'none');
                }else{
                  $('.jcarousel-prev').css('display', 'block');
                }
                init.unlockScroll();
  },

  mycarousel_initCallback : function(carousel) {
                              $('.jcarousel-prev').css('display', 'block');
                              $('#next_link').bind('click', function() {
                                if (!init.locked) {
                                  var analytics_step = '/quiz/' + (init.index + 1);
                                  _gaq.push(['_trackPageview', analytics_step]);

                                  carousel.next();
                                  init.index++;
                                }
                                return false;
                              });

                              $('.jcarousel-prev').bind('click', function() {
                                if (!init.locked) {
                                  init.clearOptions( init.getCurrentPage(carousel) );

                                  carousel.prev();
                                  init.index--;

                                  init.clearOptions( init.getCurrentPage(carousel) );
                                }

                                return false;
                              });
                            },

  getCurrentPage : function(carousel) {
    var page_selector = carousel.get(init.index).selector;
    return $(page_selector.replace('>',''));
  },

  clearOptions : function(page) {
    page.find('li.selected').removeClass('selected');
    page.find('li.click_star').removeClass();
    page.find('li.starred').removeClass();
    page.find(':radio, :checkbox').attr('checked', false);
  },

  bindActions : function() {
                  $('.images .options > li').live('click', function(){

                    $(this).find('input').attr('checked', true);
                    $(this).addClass('selected');

                    $("#next_link").click();
                  });
  },

  tracker : function() {
              var info = '<p>Fotos: Reprodução<br />O uso de imagens de celebridades nesta pesquisa serve o propósito único de identificar o perfil de moda dos respondentes. As celebridades retratadas não estão associadas ou recomendam a Olook.</p>'
              var pages = $('.questions > li').length / 2;

              $('#survey').after("<ul id='tracker'>");

              for (var i = 1; i <= pages; i++)
                $("#tracker").append('<li id=' + i + '>' + i + '</li>');

              $('#tracker').after(info);
            }
};

