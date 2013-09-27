describe("initProduct", function() {
    describe("#validSize", function(){
        it("return true for a number", function() {
            expect(initProduct.validateSize("34")).toBeTruthy();
        });

        it("return true for 'selecionar'", function() {
            expect(initProduct.validateSize("selecionar")).toBeFalsy();
        });
    })
});
