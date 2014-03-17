//= require_tree ../modules/footer_newsletter
$(document).ready(function() {
  new NewsletterSubscriber().config();

   $('a.sac').click(function(ev){
    window.open('http://olook.neoassist.com/?action=neolive&th=sac&scr=request&ForcaAutenticar=1',
    'Continue_to_Application','width=650,height=500');
    ev.preventDefault();
    return false;
  });
  $('a.moda').click(function(ev){
    window.open('http://olook.neoassist.com/?action=neolive&th=moda&scr=request&ForcaAutenticar=1',
    'Continue_to_Application','width=650,height=500');
    ev.preventDefault();
    return false;
  });
  $('a.email').click(function(ev){
    window.open('http://olook.neoassist.com/?action=new',
    'Continue_to_Application','width=650,height=700');
    ev.preventDefault();
    return false;
  });
  $('a.trade').click(function(ev){
    window.open('http://olook.neoassist.com/?th=troca&action=new',
    'Continue_to_Application','width=650,height=800,scrollbars=1');
    ev.preventDefault();
    return false;
  });

  $('.js-newsletter.js-footerbox').focus(function() {
    var input = $(this);
    if (input.val() == input.attr('default_value')) {
      input.val('');
    }
  }).blur(function() {
    var input = $(this);
    if (input.val() == '' || input.val() == input.attr('default_value')) {
      input.val(input.attr('default_value'));
    }
  }).blur();

  $('.js-newsletter.js-middlebox').focus(function() {
    var input = $(this);
    if (input.val() == input.attr('default_value')) {
      input.val('');
    }
  }).blur(function() {
    var input = $(this);
    if (input.val() == '' || input.val() == input.attr('default_value')) {
      input.val(input.attr('default_value'));
    }
  }).blur();

  $('.js-subscribe.js-footerbox').click(function() {
    $('.js-newsletter.js-footerbox').each(function() {
      var input = $(this);
      if (input.val() == input.attr('default_value')) {
        input.val('');
      }
      olookApp.publish("footer:newsletter:subscribe", input.val(),".js-footerbox");
    })
  });

  $('.js-newsletter.js-footerbox').keypress(function(key){
    if(key.which == 13) {
      $('.js-subscribe.js-footerbox').click();
    }
  });

  $('.js-subscribe.js-middlebox').click(function() {
    $('.js-newsletter.js-middlebox').each(function() {
      var input = $(this);
      if (input.val() == input.attr('default_value')) {
        input.val('');
      }
      olookApp.publish("middle:newsletter:subscribe", input.val(),".js-middlebox");
    })
  });

  $('.js-newsletter.js-middlebox').keypress(function(key){
    if(key.which == 13) {
      $('.js-subscribe.js-middlebox').click();
    }
  });    

});

