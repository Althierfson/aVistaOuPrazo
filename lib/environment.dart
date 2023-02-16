/// id de teste padrão
const bannerAdmobIdTest = "ca-app-pub-3940256099942544/6300978111";

/// id de teste padrão
const interstitiaIdTest = "ca-app-pub-3940256099942544/1033173712";

// Class responsavel por guarda e disponibilizar os variaveis de ambiente;
/// É necessario criar um objeto Environment e colocalo no inject_containe
/// Exemplo Environment environmentExemplo = Environment("SuaChaveHgBrasil");
class Environment {
  /// URlbase para acesso a API HgBrasil
  final String urlBase = "https://api.hgbrasil.com/finance/taxes";

  /// Chave de acesso a API
  final String chave;

  /// Id para os anuncios de Banner
  /// Para teste deixe o valor padrão [ca-app-pub-3940256099942544/6300978111]
  /// Mude para a versão de lançamento
  String bannerAdmob;

  /// Id para os anuncios de Interstitial
  /// Para teste deixe o valor padrão [ca-app-pub-3940256099942544/1033173712]
  /// Mude para a versão de lançamento
  String interstitialAdmob;

  /// Gerando automaticamente é a junção entre [urlBase] e a [chave]
  late final String urlFinal;

  Environment(
      {required this.chave,
      this.bannerAdmob = bannerAdmobIdTest,
      this.interstitialAdmob = interstitiaIdTest}) {
    urlFinal = "$urlBase?key=$chave";
  }
}
