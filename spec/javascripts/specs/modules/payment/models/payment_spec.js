describe("Payment", function() {
  it("should exist", function() {
    expect(app.models.Payment).toBeDefined();
  });

  it("should contain a name", function() {
    var payment = new app.models.Payment({
    });
    expect(payment.get("name")).toBeDefined();
  });  
});
