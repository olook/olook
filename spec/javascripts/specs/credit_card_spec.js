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

    it("displays message error for invalid credit card number", function() {
      loadFixtures("checkout_form.html");
      $("#checkout_payment_credit_card_number").validateCreditCardNumber();
      $("#checkout_payment_credit_card_number").val('123')
      $("#checkout_payment_credit_card_number").blur();
      expect($("#credit_card_error.span_error")).toHaveText('O número do cartão parece estranho. Pode conferir?');
    });

    it("removes message error for invalid credit card number", function() {
      loadFixtures("checkout_form.html");
      $("#checkout_payment_credit_card_number").validateCreditCardNumber();
      $("#checkout_payment_credit_card_number").val('4111.1111.1111.1111')
      $("#checkout_payment_credit_card_number").blur();
      expect($("#credit_card_error.span_error")).toHaveText('');
    });
  });

  describe(".installmentsNumberFor", function() {
    it("returns 6 for any value above 180", function() {
      expect(CreditCard.installmentsNumberFor(180)).toEqual(6);
      expect(CreditCard.installmentsNumberFor(280)).toEqual(6);
      expect(CreditCard.installmentsNumberFor(4000)).toEqual(6);
    });

    it("returns 1 for any value equals or above 30", function() {
      expect(CreditCard.installmentsNumberFor(30)).toEqual(1);
      expect(CreditCard.installmentsNumberFor(20)).toEqual(1);
    });
    
    it("returns 2 for any value between 60 and 89", function() {
      expect(CreditCard.installmentsNumberFor(60)).toEqual(2);
      expect(CreditCard.installmentsNumberFor(89)).toEqual(2);
    });    
    
    it("returns 4 for any value between 120 and 149", function() {
      expect(CreditCard.installmentsNumberFor(120)).toEqual(4);
      expect(CreditCard.installmentsNumberFor(149)).toEqual(4);
    });    

  });
});
