describe("MinicartDataUpdater", function() {

  describe("#name", function() {
    it("should be called UPDATE_MINICART_DATA", function(){
      expect(MinicartDataUpdater.name).toEqual("UPDATE_MINICART_DATA");
    });
  });


  describe("#facade", function() {
    describe("when an item is added",function(){
      describe("and a product doesn't exist in the minicart",function(){
        var html;
        beforeEach(function() {
          html = setFixtures("<li data-name='Nobuck Alto Olook' data-id='1' class='product' /><input id='total_price' name='total_price' value='' /><div class='cart_related' style='display:block;'><ul></ul></div>");
        });

        it("displays the product name in the minicart once",function(){
          MinicartDataUpdater.facade(["1","2","3"]);
          expect($('.js-minicartItem').length).toEqual(1);
        });

        it("updates the total price",function(){
          expect($('#total_price').val()).toEqual("");
          MinicartDataUpdater.facade(["1","2","3"]);          
          expect($('#total_price').val()).toEqual("2");
        });
      });

      describe("and the same product already exists in the minicart",function(){
        var html;        

        it("displays the product name in the minicart once",function(){
          html = setFixtures("<li data-name='Nobuck Alto Olook' data-id='1' class='product' /><input id='total_price' name='total_price' value='' /><div class='cart_related' style='display:block;'><ul><li class='js-minicartItem'>Nobuck Alto Olook</li></ul></div>");

          expect($('.js-minicartItem').length).toEqual(1);
          MinicartDataUpdater.facade(["1","2","3"]);
          expect($('.js-minicartItem').length).toEqual(1);
        });

        it("doesn't update the total price",function(){
          html = setFixtures("<li data-name='Nobuck Alto Olook' data-id='1' class='product' /><input id='total_price' name='total_price' value='2' /><div class='cart_related' style='display:block;'><ul><li class='js-minicartItem'>Nobuck Alto Olook</li></ul></div>");
          expect($('#total_price').val()).toEqual("2");
          MinicartDataUpdater.facade(["1","2","3"]);          
          expect($('#total_price').val()).toEqual("2");

        });

      });
    });
    describe("when an item is removed",function(){
      describe("and a product doesn't exist in the minicart",function(){
        var html;
        beforeEach(function() {
          html = setFixtures("<li data-name='Nobuck Alto Olook' data-id='1' class='product' /><li data-name='Nobuck Alto Olook 2' data-id='2' class='product' /><input id='total_price' name='total_price' value='2' /><div class='cart_related' style='display:block;'><ul><li class='js-minicartItem'>Nobuck Alto Olook</li></ul></div>");
        });

        it("Doesn't change the minicart item length",function(){
          expect($('.js-minicartItem').length).toEqual(1);
          MinicartDataUpdater.facade(["2","2",""]);
          expect($('.js-minicartItem').length).toEqual(1);
        });

        it("updates the total price",function(){
          expect($('#total_price').val()).toEqual("2");
          MinicartDataUpdater.facade(["2","2",""]);          
          expect($('#total_price').val()).toEqual("2");
        });
      });

      describe("and a product exists in the minicart",function(){
        var html;
        beforeEach(function() {
          html = setFixtures("<li data-name='Nobuck Alto Olook' data-id='1' class='product' /><li data-name='Nobuck Alto Olook 2' data-id='2' class='product' /><input id='total_price' name='total_price' value='2' /><div class='cart_related' style='display:block;'><ul><li class='js-minicartItem'>Nobuck Alto Olook</li></ul></div>");
        });

        it("Doesn't change the minicart item length",function(){
          expect($('.js-minicartItem').length).toEqual(1);
          MinicartDataUpdater.facade(["1","2",""]);
          expect($('.js-minicartItem').length).toEqual(0);
        });

        it("updates the total price",function(){
          expect($('#total_price').val()).toEqual("2");
          MinicartDataUpdater.facade(["1","2",""]);          
          expect($('#total_price').val()).toEqual("0");
        });
      });      

    });
  });

});