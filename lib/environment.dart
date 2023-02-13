/// Class responsavel por guarda e disponibilizar os variaveis de ambiente;
/// É necessario criar um objeto Environment e colocalo no inject_containe
/// Exemplo Environment environmentExemplo = Environment("SuaChaveHgBrasil");
class Environment {
  final String urlBase = "https://api.hgbrasil.com/finance/taxes";
  final String chave;
  late final String urlFinal;

  Environment(this.chave) {
    urlFinal = "$urlBase?key=$chave";
  }
}
