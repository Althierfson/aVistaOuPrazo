import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:flutter/material.dart';

// Constantes
Map<TipoResultado, String> mensagens = {
  TiposDeResultados.aVista: "Pagar a Vista",
  TiposDeResultados.aPrazo: "Pagar a Prazo",
};

class ResultWidget extends StatefulWidget {
  final TipoResultado tipoResultado;
  final Resultado resultado;
  const ResultWidget(
      {super.key, required this.tipoResultado, required this.resultado});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  late String? mensagem;
  late String valor;
  late Color color;

  @override
  void initState() {
    super.initState();
    setEstado();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            mensagem ?? "",
            style: TextStyle(
                color: color, fontSize: 48, fontWeight: FontWeight.w900),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Ao fim dos meses você terá o produto e"),
          const SizedBox(
            height: 20,
          ),
          Text(
            valor,
            style: TextStyle(
                color: color, fontSize: 48, fontWeight: FontWeight.w900),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void setEstado() {
    mensagem = mensagens[widget.tipoResultado];

    if (widget.tipoResultado == TiposDeResultados.aVista) {
      valor = widget.resultado.produtoMaisLucroAVista;
      color = const Color(0xFF0029FF);
    } else {
      valor = widget.resultado.produtoMaisLucroAPrazo;
      color = const Color(0xFF00FF47);
    }
  }
}
