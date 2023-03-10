import 'package:avistaouaprazo/core/util/admob/banner_ad_admob.dart';
import 'package:avistaouaprazo/core/util/input_formato.dart';
import 'package:avistaouaprazo/core/util/tipo_de_taxa.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_com_taxa_personalizada.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/domain/usecases/calcular_valor.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/bloc/vistaouprazo_bloc.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/pages/como_e_feito_o_calculo_page.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/pages/detalhes_page.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/pages/onde_vem_os_dados.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/widgets/result_display_widget.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/widgets/result_widget.dart';
import 'package:avistaouaprazo/features/vistaOuPrazo/presentation/widgets/text_field_money_widgets.dart';
import 'package:avistaouaprazo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VistaOuPrazo extends StatefulWidget {
  const VistaOuPrazo({super.key});

  @override
  State<VistaOuPrazo> createState() => _VistaOuPrazoState();
}

class _VistaOuPrazoState extends State<VistaOuPrazo> {
  List<Map<String, dynamic>> opcoesDeTaxa = [
    {'nome': 'Taxa Selic', 'taxa': TiposDeTaxas.selic},
    {'nome': 'Taxa cdi', 'taxa': TiposDeTaxas.cdi}
  ];

  String? valorDaCompra;
  int? parcelas;
  String? valorAVista;
  String? taxa;
  TipoDeTaxa? investimento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("A Vista ou a Prazo?"),
          centerTitle: true,
        ),
        drawer: menuLateral(context),
        body: BlocProvider(
            create: (_) => sl<VistaOuPrazoBloc>(),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const BannerAdAdMob(),
                    TextFieldMoneyWidget(
                      hintText: "Valor da compra",
                      labelText: "Informe o valor da Compra a prazo",
                      onChanged: (valor) => valorDaCompra = valor,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "N?? de Parcelas",
                          labelText: "Informe o n??mero de parcelas"),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onChanged: (valor) {
                        if (valor.isEmpty) {
                          parcelas = null;
                        } else {
                          parcelas = int.parse(valor);
                        }
                      },
                    ),
                    TextFieldMoneyWidget(
                      hintText: "Valor a vista",
                      labelText: "Informe o valor da compra a vista",
                      onChanged: (valor) => valorAVista = valor,
                    ),
                    DropdownButtonFormField(
                        hint: const Text(
                          "Escolha a taxa de rendimento?",
                          overflow: TextOverflow.fade,
                        ),
                        items: List<DropdownMenuItem>.from(opcoesDeTaxa.map(
                            (e) => DropdownMenuItem(
                                value: e['taxa'], child: Text(e['nome'])))),
                        onChanged: (valor) {
                          investimento = valor;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Defina sua taxa"),
                                  content: TextField(
                                    controller:
                                        TextEditingController(text: taxa),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: "Taxa",
                                        labelText: "Informe sua taxa"),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      MoneyFormat(),
                                      LengthLimitingTextInputFormatter(5),
                                    ],
                                    onChanged: (valor) {
                                      if (valor.length >= 3) {
                                        taxa = valor;
                                      } else {
                                        taxa = null;
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                            setState(() {});
                          },
                          child: const Text(
                            "Usar taxa personalizada",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(taxa == null
                            ? ""
                            : "Taxa pesonalizada Aplicada: $taxa"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<VistaOuPrazoBloc, VistaOuPrazoState>(
                      builder: (context, state) {
                        if (state is VistaOuPrazoInitial) {
                          return ResultDisplayWidget(
                              child: const Text(
                                  "Adicone os valores, depois v?? em calcular!"),
                              onPressed: () {
                                verificarEnviarDados(context);
                              });
                        }

                        if (state is FazendoCalculoState) {
                          return ResultDisplayWidget(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            onPressed: () {},
                          );
                        }

                        if (state is FalhaNoCalculoState) {
                          return ResultDisplayWidget(
                              child: Text(
                                state.falhaMensagem,
                                style: const TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                verificarEnviarDados(context);
                              });
                        }

                        if (state is CalculoConcluidoState) {
                          return ResultDisplayWidget(
                              child: Column(
                                children: [
                                  const Text("A melhor op????o ??"),
                                  ResultWidget(
                                    tipoResultado: state.resultado.qualMelhor,
                                    resultado: state.resultado,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetalhesPage(
                                                              resultado: state
                                                                  .resultado),
                                                    ));
                                              },
                                              child: const Text(
                                                  "Veja mais detalhes")))
                                    ],
                                  ),
                                  const Text(
                                    "Os valores aqui calculados se aproximas da realidades, e podem haver varia????es, a depender de mundan??as de taxas",
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              onPressed: () {
                                verificarEnviarDados(context);
                              });
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            )));
  }

  void verificarEnviarDados(BuildContext context) {
    if (taxa == null) {
      verificarEnviarDadosPadrao(context);
    } else {
      verificarEnviarDadosPersonalizados(context);
    }
  }

  void verificarEnviarDadosPadrao(BuildContext context) {
    if (valorAVista == null ||
        valorDaCompra == null ||
        parcelas == null ||
        investimento == null) {
      context.read<VistaOuPrazoBloc>().add(DadosInvalidosEvent());
    } else {
      context.read<VistaOuPrazoBloc>().add(CalcularComTaxaPadraoEvent(
          CalcularValorParametro(
              valorDaCompra: valorDaCompra!,
              valorVista: valorAVista!,
              parcelas: parcelas!,
              tipoDeTaxa: investimento!)));
    }
  }

  void verificarEnviarDadosPersonalizados(BuildContext context) {
    if (valorAVista == null ||
        valorDaCompra == null ||
        parcelas == null ||
        taxa == null) {
      context.read<VistaOuPrazoBloc>().add(DadosInvalidosEvent());
    } else {
      context.read<VistaOuPrazoBloc>().add(CalcularComTaxaPersonalizadaEvent(
          CalcularComTaxaPersonalizadaParametro(
              valorDaCompra: valorDaCompra!,
              valorVista: valorAVista!,
              parcelas: parcelas!,
              taxa: taxa!)));
    }
  }

  Widget menuLateral(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 100),
        children: [
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text("Como ?? feito o calculo?"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ComoEFeitoOCalculo()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_exploration),
            title: const Text("De onde vem os dado?"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OndeVemOsDados()));
            },
          )
        ],
      ),
    );
  }
}
