var NewsletterSubscriber = (function(){
  function NewsletterSubscriber() {};

  var boxClass = function(prefix){
    return ".js-"+prefix+"box";
  };

  var disableOkButton = function(prefix){
    $('.js-subscribe'+boxClass(prefix)).off('click')
  };

  var displayErrorMessage = function(prefix){
    $('.js-success'+boxClass(prefix)).fadeOut();
    $('.js-error'+boxClass(prefix)).fadeIn();
  };

  var displaySuccessMessage = function(prefix){
    $('.js-error'+boxClass(prefix)).fadeOut();
    $('.js-success'+boxClass(prefix)).fadeIn();
  };

  var subscribe = function(email,prefix){
    log_event('click', 'newsletter-'+prefix ,{value: 'email'});
    $.post('/campaign_email_subscribe', {email: email})
      .done(function(e) {
        log_event('action','newsletter-'+prefix,{value: 'email'});
        if(prefix == 'modal1' || prefix == 'modal2'){
          $('#modal button.close').click();
        }else{
          displaySuccessMessage(prefix);
          disableOkButton(prefix);
        }
      }).fail(function(data) {
        displayErrorMessage(prefix);
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
