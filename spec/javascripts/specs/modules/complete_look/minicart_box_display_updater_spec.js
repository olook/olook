describe("MinicartBoxDisplayUpdater", function() {

  describe("#name", function() {
    it("should be called UPDATE_MINICART_BOX_DISPLAY", function(){
      expect(MinicartBoxDisplayUpdater.name).toEqual("UPDATE_MINICART_BOX_DISPLAY");
    });
  });

  describe("#facade", function() {
    describe("when the cart is empty", function() {
      it("must show the empty cart box",function(){
        setFixtures("<div class='empty_minicart' style='display:none;'></div>");
        MinicartBoxDisplayUpdater.facade();
        JasmineAjaxHelper.expectCartDisplayProperty($('.empty_minicart'),"display","block", "the empty minicart didn't fade in");
      });

      it("must not indicate that there are products inside the cart",function(){
        setFixtures("<div class='cart_related product_added'></div>");
        MinicartBoxDisplayUpdater.facade();
        expect($('.product_added').length).toEqual(0);
      });

      it("erases the minicart price",function(){
        setFixtures("<div class='minicart_price'>fsaddfsaafdsdfsa</div>");
        MinicartBoxDisplayUpdater.facade();
        expect($('.minicart_price').html()).toEqual("");        
      });

      it("must disable the submit button",function(){
        setFixtures("<div class='js-minicartItem'></div><div class='js-addToCartButton disabled' disabled='disabled'></div>");
        MinicartBoxDisplayUpdater.facade();
        expect($('.js-addToCartButton').attr("disabled")).toEqual(undefined);
        expect($('.disabled').length).toEqual(0);        
      });
    });

    describe("when the cart isn't empty", function() {
      it("enables the submit button",function(){
        setFixtures("<div class='js-minicartItem'></div><div class='js-addToCartButton disabled' disabled='disabled'></div>");
        MinicartBoxDisplayUpdater.facade();
        expect($('.js-addToCartButton').attr("disabled")).toEqual(undefined);
        expect($('.disabled').length).toEqual(0);
      });
    });    

  });
});