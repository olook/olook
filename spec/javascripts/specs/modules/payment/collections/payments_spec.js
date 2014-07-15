describe("Payment", function() {
  it("should set the URL to the payment types collection URL", function() {
    var collection = new app.collections.Payments();
    expect(collection.url).toEqual(app.server_api_prefix + "/payment_types");
  });
});