import 'package:avistaouaprazo/core/util/admob/banner_ad_admob.dart';
import 'package:flutter/material.dart';

class ComoEFeitoOCalculo extends StatefulWidget {
  const ComoEFeitoOCalculo({super.key});

  @override
  State<ComoEFeitoOCalculo> createState() => _ComoEFeitoOCalculoState();
}

class _ComoEFeitoOCalculoState extends State<ComoEFeitoOCalculo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Como é feito o calculo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const BannerAdAdMob(),
              Text(texto),
            ],
          ),
        ),
      ),
    );
  }
}

String texto =
    """Os cálculos são feitos baseados nos seguintes fatores: tempo em dias que o dinheiro ficara investido; taxa de juros; preço do produto a vista; preço do produto a prazo; numero de parcelas.

Com isso para calculamos o rendimento (R) teremos a seguinte fórmula:

R = ( VI * taxa * P ) / 365

R = Rendimento; VI = Valor Investido; taxa = taxa de juros; p = Período de investimento em dias;

Agora, para calculamos o rendimento a vista, simplesmente aplicamos esse calculo com os valores correspondentes, então;

RA = R;

RA = Rendimento a vista; R = Calculo de rendimento;

E por fim, para determinarmos o rendimento a prazo, precisaremos fazer o cálculo (R) mês a mês, o número de meses será determinado pelo número de parcelas:

RM = R;
VR = VP + RM - Parcela;

RM = Rendimento no Mês; R = Calculo de rendimento; VR = Valor restante; Parcela = Valor das Parcelas;

Com essa sequência de cálculos, temos o valor que sobrou após o rendimento e pagamento da primeira parcela.

Agora repetimos os cálculos até passamos por todos as parcelas:

RM = R (R agora Recebe o VR calculado anteriormente)
VR = VP + RM - Parcela;

E Seguimos nessa sequência, onde a cada mês o valor que usamos para calcular o investimento é o valor VR, que é, o valor calculado após o rendimento e subtração das parcelas.

Dessa forma podem determinar qual é a melhor opção, a vista ou a prazo.

Esse calculo não considera, inflação monetária, cashback ou pontuações do cartão de crédito.""";
