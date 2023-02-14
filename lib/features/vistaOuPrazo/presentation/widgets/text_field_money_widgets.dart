import 'package:avistaouaprazo/core/util/input_formato.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldMoneyWidget extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function(String?) onChanged;
  const TextFieldMoneyWidget(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(hintText: hintText, labelText: labelText),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        MoneyFormat()
      ],
      onChanged: (valor) {
        if (valor.length >= 3) {
          onChanged(valor);
        } else {
          onChanged(null);
        }
      },
    );
  }
}
