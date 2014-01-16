describe("MinicartFadeOutManager", function() {

  describe("#name", function() {
    it("should be called FADE_OUT_MINICART", function(){
      expect(MinicartFadeOutManager.name).toEqual("FADE_OUT_MINICART");
    });
  });

  describe("#facade", function() {
    var html;
    beforeEach(function() {
      html = setFixtures("<input id='total_price' name='total_price' /><div class='cart_related' style='display:block;'></div>");
    });
  
    it("fades out when there is no element on the cart and variantNumber is provided", function(){
      MinicartFadeOutManager.facade(123);
      expectCartDisplayPropertyIs('none', "The element won't ever be hidden");
    });
    
    it("doesn't fade out when there is no element in the list but variantNumber is not provided", function(){
      MinicartFadeOutManager.facade();
      expectCartDisplayPropertyIs('block', "The element won't ever be shown");
    });

    it("doesn't fade out when there's an element in the list", function(){
      html.append(sandbox({class: 'js-minicartItem'}))

      MinicartFadeOutManager.facade(123);
      expectCartDisplayPropertyIs('block', "The element won't ever be shown");
    });
  });

  /**
   * @expectedValue: none or block
   * @message: Message to show when the expected value doesn't match
   */  
  expectCartDisplayPropertyIs = function(expectedValue, message) {
      // Wait for fadeOut event finished
      waitsFor(function() {
        return ($('.cart_related').css("display") == expectedValue);
      }, message, 400);
      runs(function(){
        expect($('.cart_related').css("display")).toEqual(expectedValue);
      });    
  }
});