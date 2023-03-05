import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension StringExtensions on String {
  Widget get getWeatherSvg {
    if (this == 'Rain') {
      return SvgPicture.asset('assets/svgs/rainy.svg');
    } else if (this == 'Clouds') {
      return SvgPicture.asset('assets/svgs/cloudy.svg');
    } else if (this == 'Clear') {
      return SvgPicture.asset('assets/svgs/sunny.svg');
    } else {
      return SvgPicture.asset('assets/svgs/generic.svg');
    }
  }
}
