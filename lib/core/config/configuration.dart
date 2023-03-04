import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Configuration {
  static const envFileName = '.env';
  static final baseUrl = dotenv.env['URL']!;
  static final apiKey = dotenv.env['API_KEY']!;
}
