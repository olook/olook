var FacebookStatsLogger = (function(){
  function FacebookStatsLogger(){
    this.requestHash = {}
  };

  var populateHash = function(it,request_hash){
    it.requestHash.handler = it.requestHash.handler || request_hash.handler;
    it.requestHash.valueHash = it.requestHash.valueHash || request_hash.valueHash;
  }

  var requestHashCompleted = function(it){
    return(!StringUtils.isEmpty(it.requestHash.handler) && !StringUtils.isEmpty(it.requestHash.valueHash))
  }

  FacebookStatsLogger.prototype.config = function () {
    olookApp.subscribe('stats:log', this.facade, {}, this);
  };

  FacebookStatsLogger.prototype.facade = function (request_hash) {
    populateHash(this,request_hash);
    if(requestHashCompleted(this)){
      console.log('action: '+this.requestHash.handler+', '+this.requestHash.valueHash);
      log_event('action',this.requestHash.handler,this.requestHash.valueHash);
      requestHash = {};
    }
  };

  return FacebookStatsLogger;
})();
