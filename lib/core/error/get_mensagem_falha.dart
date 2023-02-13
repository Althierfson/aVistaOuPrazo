import 'package:avistaouaprazo/core/error/falhas.dart';

String getMensagemFalha(Falha falha) {
  switch (falha.runtimeType) {
    case SemInternt:
      return "Você não tem acesso a internt.";
    case ConvertFalha:
      return "Falha interna! Tente mais tarde.";
    case CachedFalha:
      return "Falha ao acessar dados salvos! Tente mais tarde.";
    case AcessoAPIFalha:
      return "Falha ao acesso dados remotos! Tente mais tarde.";
    case ImpossivelBuscarTaxasFalha:
      return "Não foi possivel buscar dados! Tente mais tarde.";
    default:
      return "Erro inesperado! Tente mais tarde.";
  }
}
