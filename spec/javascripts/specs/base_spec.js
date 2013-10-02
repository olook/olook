/**
  * Formatter está definido em /common/base.js
  *
  */

describe("Formatter", function() {
  describe(".toCurrency", function() {
    it("returns 'R$ 4,00' for '4'", function() {
      expect(Formatter.toCurrency(4)).toEqual('R$ 4,00');
    });

    it("returns 'R$ 138,95' for '138.9542'", function() {
      expect(Formatter.toCurrency(138.9542)).toEqual('R$ 138,95');
    });

    xit("returns 'R$ 8.138,95' for '8138.9542'", function() {
      expect(Formatter.toCurrency(8138.9542)).toEqual('R$ 8.138,95');
    });
  });
});
