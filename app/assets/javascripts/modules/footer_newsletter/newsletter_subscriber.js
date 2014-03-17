var NewsletterSubscriber = (function(){
  function NewsletterSubscriber() {};

  var disableOkButton = function(boxClass){
    $('.js-subscribe'+boxClass).off('click')
  };

  var trackEvent = function(message,boxClass){
    _gaq.push(['_trackEvent', 'FooterNewsletter', message, '', , true]);
  };

  var displayErrorMessage = function(boxClass){
    $('.js-success'+boxClass).fadeOut();    
    $('.js-error'+boxClass).fadeIn();
    trackEvent('Error');
  };

  var displaySuccessMessage = function(boxClass){
    $('.js-error'+boxClass).fadeOut();   
    $('.js-success'+boxClass).fadeIn();
    trackEvent('Success');            
  };

  var displayFeedbackMessage = function(status,boxClass){
    if (status == "ok"){ 
      displaySuccessMessage(boxClass);
      disableOkButton(boxClass);
    } else {
     displayErrorMessage(boxClass);
    }    
  };

  var subscribe = function(email,boxClass){
    trackEvent("EmailSubmitted", boxClass);
    $.post('/campaign_email_subscribe', {email: email}, function( data ) {
      displayFeedbackMessage(data.status, boxClass);
    });
  };

  NewsletterSubscriber.prototype.facade = function(email, boxClass){
    subscribe(email, boxClass);
  };

  NewsletterSubscriber.prototype.config = function(){
    olookApp.subscribe('footer:newsletter:subscribe', this.facade, {}, this);
    olookApp.subscribe('middle:newsletter:subscribe', this.facade, {}, this);
  };

  return NewsletterSubscriber;
})();