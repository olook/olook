$(document).ready(function() {

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

  init.carousel();
  init.carouselValidates();
  init.dialog();
});

init = {
  carousel : function() {
               $('.questions').jcarousel({
                 scroll: 1,
                 itemFirstInCallback : {
                   onBeforeAnimation : init.clearSelectedItems,
                   onAfterAnimation : init.clearSelectedItems
                 }
               });
             },

  carouselValidates : function() {
                        $('.jcarousel-item li').live('change', function(){
                          elemtId = $(this).parents('li').attr('id');
                          carouselItem = $(this).parents('li');

                          if (carouselItem.hasClass('images')) {
                            $('.jcarousel-next').click();
                          };

                          if (carouselItem.hasClass('words') && $('#' + elemtId).find(":checkbox:checked").length == 3){
                            $('.jcarousel-next').click();
                          }

                          $(this).addClass('selected');
                        });

                        $('.about ul li').live('click', function() {
                          $(this).parent('ul').find('li').removeClass('selected');
                          $(this).addClass('selected');
                        });

                        $("#about").live("change", function(){
                          if ($('#about').find(":radio:checked").length == 2 &&
                              $("#about select[name='day']").val()  != 'Dia' &&
                              $("#about select[name='month']").val()  != 'Mês' &&
                              $("#about select[name='year']").val()  != 'Ano'){

                            $("#about .buttons li").removeClass("grey-button");
                          }else{
                            $("#about .buttons li").addClass("grey-button");
                          }
                        });
                      },

  clearSelectedItems : function(instance, item, index, state) {
                         el = $('#' + item.id);

                         if(state == 'prev'){
                           el.find('li.selected').removeClass('selected');
                           el.find('input[type=radio], input[type=checkbox]').attr('checked', false);
                         };

                         if(index == '1'){
                           $('.jcarousel-container .jcarousel-next').css('display', 'none');
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
