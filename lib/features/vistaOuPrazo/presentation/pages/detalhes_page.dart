import 'package:avistaouaprazo/core/util/admob/banner_ad_admob.dart';
import 'package:avistaouaprazo/core/util/admob/interstitial_ad_admob.dart';
import 'package:avistaouaprazo/core/util/tipo_resutado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/entities/resultado.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/widgets/result_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetalhesPage extends StatefulWidget {
  final Resultado resultado;
  const DetalhesPage({super.key, required this.resultado});

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  late TipoResultado tipoResultadoSet;
  late List<CartesianPreco> historicoAVista;
  late List<CartesianPreco> historicoAPrazo;
  late InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    tipoResultadoSet = widget.resultado.qualMelhor;
    historicoAVista = createList(widget.resultado.historicoAvista);
    historicoAPrazo = createList(widget.resultado.historicoAPrazo);
    InterstitialAdAdmob.loadInterstitial(
        onAdLoaded: (ad) => interstitialAd = ad);
  }

  @override
  void dispose() async {
    super.dispose();
    interstitialAd != null ? await interstitialAd!.show() : () {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A Vista ou a Prazo?"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const BannerAdAdMob(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFF0029FF), width: 2))),
                        child: ResultWidget(
                            tipoResultado: TiposDeResultados.aVista,
                            resultado: widget.resultado),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xFF00FF47), width: 2))),
                        child: ResultWidget(
                            tipoResultado: TiposDeResultados.aPrazo,
                            resultado: widget.resultado),
                      ),
                    ),
                  ],
                ),
              ),
              SfCartesianChart(
                series: <ChartSeries>[
                  LineSeries<double, int>(
                      name: "À Vista",
                      dataSource: widget.resultado.historicoAvista,
                      xValueMapper: (double valor, index) => index,
                      yValueMapper: (double valor, _) => valor,
                      color: const Color(0xFF0029FF),
                      width: 2),
                  LineSeries<double, int>(
                    name: "A Prazo",
                    dataSource: widget.resultado.historicoAPrazo,
                    xValueMapper: (double valor, index) => index,
                    yValueMapper: (double valor, _) => valor,
                    color: const Color(0xFF00FF47),
                    width: 2,
                  ),
                ],
                primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.simpleCurrency(
                        decimalDigits: 0, locale: "pt-br")),
                legend: Legend(
                    padding: 19,
                    isVisible: true,
                    position: LegendPosition.bottom,
                    title: LegendTitle(
                        text: "Rendimento ao longo dos meses",
                        alignment: ChartAlignment.center)),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<CartesianPreco> createList(List<double> lista) {
    List<CartesianPreco> newLista = [];
    for (int i = 0; i < lista.length; i++) {
      newLista.add(CartesianPreco(mes: i, valor: lista[i]));
    }
    return newLista;
  }
}

class CartesianPreco {
  int mes;
  double valor;

  CartesianPreco({required this.mes, required this.valor});
}
