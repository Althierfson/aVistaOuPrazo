import 'package:flutter/services.dart';

class MoneyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length >= 3) {
      if (newValue.text[newValue.text.length - 3] == ".") return newValue;

      String leftText = newValue.text.substring(0, newValue.text.length - 2);
      String rightText = newValue.text.substring(newValue.text.length - 2);

      String newText = "$leftText.$rightText";
      return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length));
    }
    return newValue;
  }
}
