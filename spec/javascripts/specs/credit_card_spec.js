describe("CreditCard", function() {
  describe(".validateNumber", function() {
    it("return true for '4111.1111.1111.1111'", function() {  
      expect(CreditCard.validateNumber("4111.1111.1111.1111")).toBeTruthy();
    });

    it("return true for '4111111111111111'", function() {  
      expect(CreditCard.validateNumber("4111.1111.1111.1111")).toBeTruthy();
    });   

    it("return false for '0000000000000001'", function() {
      expect(CreditCard.validateNumber("0000000000000001")).toBeFalsy();
    });

    it("return false for '0000.0000.0000.0001'", function() {
      expect(CreditCard.validateNumber("0000000000000001")).toBeFalsy();
    });
  });
});
