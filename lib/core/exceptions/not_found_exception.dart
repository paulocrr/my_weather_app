class NotFoundException implements Exception {
  final String message;

  const NotFoundException({this.message = ''});

  @override
  String toString() => message;
}
