class NumberToWords {
  static const _ones = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static const _tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety',
  ];

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static String _threeDigits(int n) {
    final buffer = StringBuffer();
    if (n >= 100) {
      buffer.write('${_ones[n ~/ 100]} Hundred ');
      n %= 100;
    }
    if (n >= 20) {
      buffer.write('${_tens[n ~/ 10]} ');
      n %= 10;
      if (n > 0) buffer.write('${_ones[n]} ');
    } else if (n > 0) {
      buffer.write('${_ones[n]} ');
    }
    return buffer.toString().trim();
  }
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static String intToWords(int n) {
    if (n == 0) return 'Zero';
    final parts = <String>[];
    if (n >= 1000000) {
      parts.add('${_threeDigits(n ~/ 1000000)} Million');
      n %= 1000000;
    }
    if (n >= 1000) {
      parts.add('${_threeDigits(n ~/ 1000)} Thousand');
      n %= 1000;
    }
    if (n > 0) {
      parts.add(_threeDigits(n));
    }
    return parts.join(' ');
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static String amountToWords(double amount) {
    final dollars = amount.floor();
    final cents = ((amount - dollars) * 100).round();
    final dollarWords = intToWords(dollars);
    final dollarLabel = dollars == 1 ? 'Dollar' : 'Dollars';
    if (cents == 0) {
      return 'USD $dollarWords $dollarLabel Only';
    }
    final centWords = intToWords(cents);
    final centLabel = cents == 1 ? 'Cent' : 'Cents';
    return 'USD $dollarWords $dollarLabel and $centWords $centLabel Only';
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
}
