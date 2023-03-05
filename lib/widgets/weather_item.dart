import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherItem extends StatelessWidget {
  final String icon;
  final String text;
  final String value;

  const WeatherItem({
    super.key,
    required this.icon,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: 24),
          const SizedBox(width: 8),
          Text('$text: $value'),
        ],
      ),
    );
  }
}
