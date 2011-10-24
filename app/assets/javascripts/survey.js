$(document).ready(function() {

  init.carousel();
  init.bindActions();
  init.dialog();
  index = parseInt($("#id_first_question").val());

  function popupCenter(url, width, height, name) {
    var left = (screen.width/2)-(width/2);
    var top = (screen.height/2)-(height/2);

    return window.open(url, name, "menubar=no,toolbar=no,status=no,width=" + width + ",height=" + height + ",toolbar=no,left=" + left + ",top=" + top);

  }

  $("a.fbpopup").click(function(e) {
    e.stopPropagation();
    e.preventDefault();

    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    return false;
  });

  $('.about .question li').live('click', function() {
    $(this).parent('ul').find('li').removeClass('selected');
    $(this).addClass('selected');
  });

  $(".about").live("click", function(){
    var limitOfCheckedAnswers = 2;
    if ($('.about').find(":radio:checked").length == limitOfCheckedAnswers &&
      $(".about select[name='day']").val()  != 'Dia' &&
      $(".about select[name='month']").val()  != 'Mês' &&
      $(".about select[name='year']").val()  != 'Ano'){

      $(".about .buttons li").removeClass("grey-button");
      $('.jcarousel-next').click();

    }else{
      $(".about .buttons li").addClass("grey-button");
    }
  });


});

init = {
  carousel : function() {
               $('.questions').jcarousel({
                 initCallback: init.mycarousel_initCallback,
                 scroll: 1
               });
             },

  mycarousel_initCallback : function(carousel) {
    $('#next_link').bind('click', function() {
      elemtId = "#question_" + index;
      carouselItem = $("#question_" + index);

      if (carouselItem.hasClass('images')) {
        carousel.next();
        index++;
      };

      if (carouselItem.hasClass('words') && $(elemtId).find(":checkbox:checked").length == 3){
        carousel.next();
        index++;
      }
    return false;
    });

    $('.jcarousel-prev').bind('click', function() {
        carousel.prev();
        index--;
        el = $("#question_" + index);
        el.find('li.selected').removeClass('selected');
        el.find('input[type=radio], input[type=checkbox]').attr('checked', false);
        return false;
    });
  },

  bindActions : function() {
    if($.browser.webkit == true) {
      $('.jcarousel-item li').live('change', function(){
        $(this).addClass('selected');
        $("#next_link").click();
      });
    }else {
      $('.jcarousel-item li').live('click', function(){
        $(this).addClass('selected');
        $("#next_link").click();
      });
    }
  },

  dialog : function(){
            $('a.trigger').live('click', function(e){
              el = $(this).attr('href');

              $(this).parents('#session').find('#' + el).toggle('open');
              $(this).parents('body').addClass('dialog-opened')

              e.preventDefault();

              $('#sign-in-dropdown').live('click',function(e) {
                if($('body').hasClass('dialog-opened')) {
                  e.stopPropagation();
                }
              })

              $('body.dialog-opened').live('click', function(e){
                if($('#sign-in-dropdown').is(':visible')){
                  $('#sign-in-dropdown').toggle();
                  $(this).removeClass('dialog-opened');
                  e.stopPropagation();
                }
              });
            });
           }

};
