import 'package:flutter/material.dart';

class OndeVemOsDados extends StatefulWidget {
  const OndeVemOsDados({super.key});

  @override
  State<OndeVemOsDados> createState() => _OndeVemOsDadosState();
}

class _OndeVemOsDadosState extends State<OndeVemOsDados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("De onde vem os dados?"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Text(texto),
      ),
    );
  }
}

String texto =
    """Os nossos dado vem direto do sistema HG Brasil - Utilizamos sua API HG Finance.
    
    Esses valores ficam armazenados no seu dispositivo, e são atualizados acada 30 dias""";
