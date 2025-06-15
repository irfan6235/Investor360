import 'package:intl/intl.dart';

String formatNumber(double number) {
  if (number >= 10000000) {
    return '\u20B9${(number / 10000000).toStringAsFixed(2)}Cr';
  } else if (number >= 100000) {
    return '\u20B9${(number / 100000).toStringAsFixed(2)}L';
  } else if (number >= 1000) {
    return '\u20B9${(number / 1000).toStringAsFixed(2)}k';
  } else {
    return '\u20B9${number.toStringAsFixed(2)}';
//    return number.toStringAsFixed(2);
  }
}


String formatNumberWithCommas(double number) {
  final formatter = NumberFormat('#,##0.00'); // Adjust format as needed
  return formatter.format(number);
}
String formatNumberWithCommasHoldinDetails(double number) {
  final formatter = NumberFormat('#,##0.000'); // Adjust format as needed
  return formatter.format(number);
}
