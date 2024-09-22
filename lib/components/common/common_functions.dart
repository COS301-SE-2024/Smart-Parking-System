

int extractSlotsAvailable(String slots) {
  // Use a regular expression to match the first number
  RegExp regex = RegExp(r'^\d+');
  Match? match = regex.firstMatch(slots);
  
  if (match != null) {
    String number = match.group(0)!;
    return int.parse(number);
  }
  
  // Return a default value if no match is found
  return 0;
}

bool isValidString(String testString, String regexPatter) {
    // Define the regex pattern for a name
  String pattern = regexPatter;
  RegExp regex = RegExp(pattern);
  // Check if the strings match the regex pattern
  bool isValid = regex.hasMatch(testString);
  // Output if incorrect
  if(!isValid){return false;}
  // Output if correct
  return true;
}

// bool isValidInt() {

// }