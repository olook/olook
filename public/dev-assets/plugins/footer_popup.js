var NewsletterSubscriber = (function(){
  function NewsletterSubscriber() {};

  var boxClass = function(prefix){
    return ".js-"+prefix+"box";
  };

  var disableOkButton = function(prefix){
    $('.js-subscribe'+boxClass(prefix)).off('click')
  };

  var trackEvent = function(message,prefix){
    _gaq.push(['_trackEvent', prefix.capitalize()+'Newsletter', message, '', , true]);
  };

  var displayErrorMessage = function(prefix){
    $('.js-success'+boxClass(prefix)).fadeOut();    
    $('.js-error'+boxClass(prefix)).fadeIn();
    trackEvent('Error', prefix);
  };

  var displaySuccessMessage = function(prefix){
    $('.js-error'+boxClass(prefix)).fadeOut();   
    $('.js-success'+boxClass(prefix)).fadeIn();
    trackEvent('Success', prefix);            
  };

  var displayFeedbackMessage = function(status,prefix){
    if (status == "ok"){ 
      displaySuccessMessage(prefix);
      disableOkButton(prefix);
    } else {
     displayErrorMessage(prefix);
    }    
  };

  var subscribe = function(email,prefix){
    trackEvent("EmailSubmitted", prefix);
    $.post('/campaign_email_subscribe', {email: email}, function( data ) {
      displayFeedbackMessage(data.status, prefix);
    });
  };

  NewsletterSubscriber.prototype.facade = function(email, prefix){
    subscribe(email, prefix);
  };

  NewsletterSubscriber.prototype.config = function(){
    olookApp.subscribe('newsletter:subscribe', this.facade, {}, this);
  };

  return NewsletterSubscriber;
})();
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

  var prepareForEmailInput = function(prefix) {
    $('.js-newsletter.js-'+prefix+'box').each(function() {
      var input = $(this);
      if (input.val() == input.attr('default_value')) {
        input.val('');
      }
      olookApp.publish("newsletter:subscribe", input.val(),prefix);
    })
  };

  var clickOnReturnKey = function(key, prefix){
    if(key.which == 13) {
      $('.js-subscribe.js-'+prefix+'box').click();
    }
  };

  $('.js-subscribe.js-footerbox').click(function(){
    prepareForEmailInput("footer");
  });

  $('.js-subscribe.js-middlebox').click(function(){
    prepareForEmailInput("middle");
  });  

  $('.js-newsletter.js-footerbox').keypress(function(key){
    clickOnReturnKey(key,"footer");
  });

  $('.js-newsletter.js-middlebox').keypress(function(key){
    clickOnReturnKey(key,"middle");
  });    

});

