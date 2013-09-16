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
});
