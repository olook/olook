var FacebookStatsLogger = (function(){
  function FacebookStatsLogger(){ };

  var requestHash = {};

  var populateHash = function(request_hash){
    requestHash.handler = requestHash.handler || request_hash.handler;
    requestHash.valueHash = requestHash.valueHash || request_hash.valueHash;
  }

  var requestHashCompleted = function(){
    return(!StringUtils.isEmpty(requestHash.handler) && !StringUtils.isEmpty(requestHash.valueHash))
  }

  FacebookStatsLogger.prototype.config = function () {
    olookApp.subscribe('stats:log', this.facade, {}, this);
  };

  FacebookStatsLogger.prototype.facade = function (request_hash) {
    populateHash(request_hash);
    if(requestHashCompleted()){
      console.log('action: '+requestHash.handler+', '+requestHash.valueHash);
      log_event('action',requestHash.handler,requestHash.valueHash);
      requestHash = {};
    }
  };

  return FacebookStatsLogger;
})();
