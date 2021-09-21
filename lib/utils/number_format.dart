import 'package:intl/intl.dart';

class FormattedNumber{

  static String formatNumber(int number){

    var formatter = NumberFormat('###,000');
    return formatter.format(number);

  }

}