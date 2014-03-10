describe("MinicartFadeOutManager", function() {

  describe("#config", function() {
    beforeEach(function(){
      olookApp = jasmine.createSpyObj('olookApp', ['subscribe']);
    });
    it("should call subscribe in channel minicart:update:fadeout", function(){
      var obj = new MinicartFadeOutManager();
      obj.config();
      expect(olookApp.subscribe).toHaveBeenCalledWith("minicart:update:fadeout", obj.facade, {}, obj);
    });
  });

  describe("#facade", function() {
    var html;
    beforeEach(function() {
      html = setFixtures("<input id='total_price' name='total_price' /><div class='cart_related' style='display:block;'></div>");
    });

    it("fades out when there is no element on the cart and variantNumber is provided", function(){
      new MinicartFadeOutManager().facade({variantNumber: 123});
      JasmineAjaxHelper.expectCartDisplayProperty($('.cart_related'),"display",'none', "The element won't ever be shown");
    });

    it("doesn't fade out when there is no element in the list but variantNumber is not provided", function(){
      new MinicartFadeOutManager().facade({variantNumber:''});
      JasmineAjaxHelper.expectCartDisplayProperty($('.cart_related'),"display",'block', "The element won't ever be shown");
    });

    it("doesn't fade out when there's an element in the list", function(){
      html.append(sandbox({class: 'js-minicartItem'}))

      new MinicartFadeOutManager().facade({variantNumber:123});
      JasmineAjaxHelper.expectCartDisplayProperty($('.cart_related'),"display",'block', "The element won't ever be shown");

    });
  });
});
