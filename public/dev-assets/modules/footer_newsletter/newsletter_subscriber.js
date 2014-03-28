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
