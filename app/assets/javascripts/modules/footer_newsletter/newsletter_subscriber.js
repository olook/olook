var NewsletterSubscriber = (function(){
  function NewsletterSubscriber() {};

  var disableOkButton = function(){
    $('.js-subscribe').off('click')
  };

  var displayErrorMessage = function(){
    $('.js-success').fadeOut();    
    $('.js-error').fadeIn();
    _gaq.push(['_trackEvent', 'FooterNewsletter', 'Error', '', , true]);    
  };

  var displaySuccessMessage = function(){
    $('.js-error').fadeOut();   
    $('.js-success').fadeIn();
    _gaq.push(['_trackEvent', 'FooterNewsletter', 'Success', '', , true]);            
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