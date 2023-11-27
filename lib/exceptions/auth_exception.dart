class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "E-mail já cadastrado.",
    "OPERATION_NOT_ALLOWED": "Operação não permitida!",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Acceso bloqueado temporariamente. Tente mais tarder.",
    "EMAIL_NOT_FOUND": "E-mail inválido",
    "INVALID_PASSWORD": "senha inválida",
    "USER_DISABLED": "A conta do usuário foi desabilitada",
    "INVALID_LOGIN_CREDENTIALS": "E-mail ou seja inválido"
  };

  final String key;

  AuthException({required this.key});

  @override
  String toString() {
    return errors[key] ?? "Ocorreu um erro no processo de autenticação";
  }
}