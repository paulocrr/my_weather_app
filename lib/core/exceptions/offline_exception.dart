class OfflineException implements Exception {
  final String message;

  const OfflineException({this.message = ''});

  @override
  String toString() => message;
}
