JasmineAjaxHelper = (function(){
  /**
   * @expectedValue: none or block
   * @message: Message to show when the expected value doesn't match
   */  
    return{
        expectCartDisplayProperty: function(element, property, expectedValue, message) {
            // Wait for fadeOut event finished
            waitsFor(function() {
                return (element.css(property) == expectedValue);
            }, message, 400);
            runs(function(){
                expect(element.css(property)).toEqual(expectedValue);
            });    
        }
    };
})();