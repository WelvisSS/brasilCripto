import 'dart:io';

import '../data/app_exceptions.dart';

String mapErrorToMessage(Object error) {
  if (error is RateLimitExceededException) {
    return 'Você excedeu o limite de requisições. Por favor, tente novamente mais tarde.';
  } else if (error is SocketException) {
    return 'Sem conexão com a internet. Verifique sua rede.';
  } else if (error is FetchDataException) {
    return 'Erro ao buscar dados. Por favor, tente novamente.';
  } else {
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}
