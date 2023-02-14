import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/pages/vista_ou_prazo_page.dart';
import 'package:avistaouaprazo/injection_container.dart' as di;
import 'package:avistaouaprazo/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupContainer();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    home: const VistaOuPrazo(),
  ));
}
