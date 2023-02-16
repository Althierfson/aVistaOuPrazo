import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/pages/vista_ou_prazo_page.dart';
import 'package:avistaouaprazo/injection_container.dart' as di;
import 'package:avistaouaprazo/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupContainer();
  MobileAds.instance.initialize();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    home: const VistaOuPrazo(),
  ));
}
