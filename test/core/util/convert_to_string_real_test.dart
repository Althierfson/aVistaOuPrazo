import 'package:avistaouaprazo/core/util/convert_to_string_real.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ConvertToStringReal convertToStringReal = ConvertToStringReal();
  test("Deve converte um decimal [12.38] para uma String [R\$ 12.38]", () {
    final result =
        convertToStringReal.fromDecimalToStringReal(Decimal.parse("12.38"));

    result.fold((l) {
      expect(1, 2);
    }, (r) {
      expect(r, "R\$ 12.38");
    });
  });

  test("Deve converte um double [12.38558] para uma Decimal [12.39]", () {
    final result = convertToStringReal.fromDoubleToDecimal(12.38558);

    result.fold((l) {
      expect(1, 2);
    }, (r) {
      expect(r, Decimal.parse("12.39"));
    });
  });

  test("Deve converte um String [12.38] para uma Decimal [12.39]", () {
    final result = convertToStringReal.fromStringToDecimal("12.38");

    result.fold((l) {
      expect(1, 2);
    }, (r) {
      expect(r, Decimal.parse("12.38"));
    });
  });

  test("Deve converte um Decimal [12.38] para uma double [12.39]", () {
    final result = convertToStringReal.fromDecimalToDouble(Decimal.parse("12.38"));

    result.fold((l) {
      expect(1, 2);
    }, (r) {
      expect(r,12.38);
    });
  });
}
