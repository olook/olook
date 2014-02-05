describe("StringUtils", function() {
    describe("#isEmpty", function(){
        it("returns true for an empty value", function() {
            expect(StringUtils.isEmpty("")).toBeTruthy();
        });

        it("returns true for a null value", function() {
            expect(StringUtils.isEmpty(null)).toBeTruthy();
        });

        it("returns true for an undefined value", function() {
            expect(StringUtils.isEmpty(undefined)).toBeTruthy();
        });

        it("returns false for a non-empty value", function() {
            expect(StringUtils.isEmpty("test")).toBeFalsy();
        });
    })
});
