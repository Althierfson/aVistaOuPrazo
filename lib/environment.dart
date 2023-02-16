/// Class responsavel por guarda e disponibilizar os variaveis de ambiente;
/// É necessario criar um objeto Environment e colocalo no inject_containe
/// Exemplo Environment environmentExemplo = Environment("SuaChaveHgBrasil");
class Environment {
  /// URlbase para acesso a API HgBrasil
  final String urlBase = "https://api.hgbrasil.com/finance/taxes";

  /// Chave de acesso a API
  final String chave;

  /// Gerando automaticamente é a junção entre [urlBase] e a [chave]
  late final String urlFinal;

  Environment(this.chave) {
    urlFinal = "$urlBase?key=$chave";
  }
}
