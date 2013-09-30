describe("initProduct", function() {
    describe("#isEmpty", function(){
        it("returns true for an empty value", function() {
            expect(initProduct.isEmpty("")).toBeTruthy();
        });

        it("returns true for a null value", function() {
            expect(initProduct.isEmpty(null)).toBeTruthy();
        });

        it("returns true for an undefined value", function() {
            expect(initProduct.isEmpty(undefined)).toBeTruthy();
        });

        it("returns false for a non-empty value", function() {
            expect(initProduct.isEmpty("test")).toBeFalsy();
        });
    })
});
