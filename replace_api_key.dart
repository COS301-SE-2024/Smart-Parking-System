// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() {
  // Get the API key from environment variables
  final apiKey = Platform.environment['API_KEY'];
  final mapsapiKey = Platform.environment['MAPS_API_KEY'];

  if (apiKey == null) {
    print('API_KEY environment variable is not set.');
    exit(1);
  }

  // Path to the google-services.json file
  const googleServicesFilePath = 'android/app/google-services.json';

  // Read the google-services.json file
  final googleServicesFile = File(googleServicesFilePath);
  final googleServicesJsonString = googleServicesFile.readAsStringSync();

  // Parse the JSON data
  final googleServicesConfig = jsonDecode(googleServicesJsonString);

  // Replace the API key with the environment variable
  googleServicesConfig['client'][0]['api_key'][0]['current_key'] = apiKey;

  // Convert the modified JSON back to a string
  final updatedGoogleServicesConfig = jsonEncode(googleServicesConfig);

  // Write the updated configuration back to the file
  googleServicesFile.writeAsStringSync(updatedGoogleServicesConfig);

  print('API key replaced successfully in google-services.json.');

  // Path to the strings.xml file
  const stringsFilePath = 'android/app/src/main/res/values/strings.xml';

  // Read the strings.xml file
  final stringsFile = File(stringsFilePath);
  final stringsXmlString = stringsFile.readAsStringSync();

  // Replace the placeholders with the environment variable
  final updatedStringsXmlString = stringsXmlString
      .replaceAll('<string name="MAPS_API_KEY"></string>', '<string name="MAPS_API_KEY">$mapsapiKey</string>');

  // Write the updated strings.xml back to the file
  stringsFile.writeAsStringSync(updatedStringsXmlString);

  print('API keys replaced successfully in strings.xml.');
}