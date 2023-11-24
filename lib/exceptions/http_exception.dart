class HttpExceptionNew implements Exception {
  final String msg;
  final int statusCode;

  HttpExceptionNew({
    required this.msg,
    required this.statusCode,
  });

  @override
  String toString() {
    return msg;
  }
}
