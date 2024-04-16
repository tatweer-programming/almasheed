class NumbersManager {
  static String engNumberToArabic(String number) {
    Map numbers = {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    };
    numbers.forEach((key, value) => number = number.replaceAll(key, value));
    return number;
  }
}
