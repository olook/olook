describe("MinicartInputsUpdater", function() {
  
  describe("name", function() {
    expect(MinicartInputsUpdater.name).toEqual('UPDATE_MINICART_INPUTS');
  });

  describe("#facade", function() {

    beforeEach(function() {
      setFixtures(sandbox({id: 'minicart'}));
    });

    describe("when the cart is empty", function() {
      it("should have only 1 hidden field", function() {
        MinicartInputsUpdater.facade(1000, '3');
        expectHiddenFieldWithValue('3')
      });
    });

    describe("when cart already has one element", function() {
      beforeEach(function() {
        $('#minicart').append("<input type='hidden' id='variant_numbers_' name='variant_numbers[]' class='js-1001' value='1'>");
        expect($('.js-1001').size()).toEqual(1);
      });

      it("should exchange the previous one for the new one", function() {
        MinicartInputsUpdater.facade(1001, "2");
        expectHiddenFieldWithValue('2')
      });
      
    });   

    describe("when there is 2 different products in the cart", function() {
      
      beforeEach(function() {
        $('#minicart').append("<input type='hidden' id='variant_numbers_' name='variant_numbers[]' class='js-1002' value='1'>");
        $('#minicart').append("<input type='hidden' id='variant_numbers_' name='variant_numbers[]' class='js-1003' value='3'>");     
      });

      describe("and only the second is changed", function() {
        it("should update only the variant number of the last product", function() {
          expect($('.js-1003').val()).toEqual('3');
          MinicartInputsUpdater.facade(1003, "2");   
          expect($('.js-1003').val()).toEqual('2');
        });
      });
    });
  });

  expectHiddenFieldWithValue = function(value) {
    var hiddenField = $('#minicart input');
    expect(hiddenField.size()).toEqual(1);
    expect(hiddenField.attr('id')).toEqual('variant_numbers_');
    expect(hiddenField.attr('name')).toEqual('variant_numbers[]');
    expect(hiddenField.val()).toEqual(value);    
  }

});