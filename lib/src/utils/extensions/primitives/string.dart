class PercentEncode {
  static const Map<String, String> charMap = {
    "!": "%21",
    "#": "%23",
    "\$": "%24",
    "&": "%26",
    "'": "%27",
    "(": "%28",
    ")": "%29",
    "*": "%2A",
    "+": "%2B",
    ",": "%2C",
    "/": "%2F",
    ":": "%3A",
    ";": "%3B",
    "=": "%3D",
    "?": "%3F",
    "@": "%40",
    "[": "%5B",
    "]": "%5D",
  };

  static String encodeChar(String char) {
    return charMap[char] ?? char;
  }

  static String encodeString(String? string) {
    if (string == null) return '';
    if (string.isEmpty) return string;
    String result = '';
    for (final s in string.split('')) {
      result += encodeChar(s);
    }
    return result;
  }
}

extension StringReminder on String {
  String get todo => this;
  // String get todo => "$this [!]";
}

extension StringConverter on String {

  static final _pascalWordsRE = RegExp(r"(?<=[a-z])(?=[A-Z])");
  List<String> get splitWordsFromUppercase => split(_pascalWordsRE);

  
  String get variableNameToSpacedPascalCase {
    if(isEmpty) return "";
    final list = splitWordsFromUppercase;
    if(list.isEmpty) return "";
    return [
      for(final word in list)
        word.capitalizeFirst,
    ].join(" ");
  }
  
  String get capitalizeFirst {
    if(isEmpty) return this;
    String result = '';
    for(int i=0; i<length; i++){
      if(i == 0) {
        result += this[0].toUpperCase();
      } else {
        result += this[i].toLowerCase();
      }
    }
    return result;
  }
}
