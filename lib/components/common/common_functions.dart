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