var NewsletterSubscriber = (function(){
  function NewsletterSubscriber() {};

  var disableOkButton = function(){
    $('.js-subscribe').off('click')
  };

  var trackEvent = function(message){
    _gaq.push(['_trackEvent', 'FooterNewsletter', message, '', , true]);
  };

  var displayErrorMessage = function(){
    $('.js-success').fadeOut();    
    $('.js-error').fadeIn();
    trackEvent('Error');
  };

  var displaySuccessMessage = function(){
    $('.js-error').fadeOut();   
    $('.js-success').fadeIn();
    trackEvent('Success');            
  };

  var displayFeedbackMessage = function(status){
    if (status == "ok"){ 
      displaySuccessMessage();
      disableOkButton();
    } else {
     displayErrorMessage();
    }    
  };

  var subscribe = function(email){
    trackEvent("EmailSubmitted");
    $.post('/campaign_email_subscribe', {email: email}, function( data ) {
      displayFeedbackMessage(data.status);
    });
  };

  NewsletterSubscriber.prototype.facade = function(email){
    subscribe(email);
  };

  NewsletterSubscriber.prototype.config = function(){
    olookApp.subscribe('footer:newsletter:subscribe', this.facade, {}, this);
  };

  return NewsletterSubscriber;
})();