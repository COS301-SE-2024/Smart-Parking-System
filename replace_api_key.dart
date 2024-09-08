// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() {
  // Get the API key from environment variables
  final apiKey = Platform.environment['API_KEY'];

  if (apiKey == null) {
    print('API_KEY environment variable is not set.');
    exit(1);
  }

  // Path to the google-services.json file
  const filePath = 'android/app/google-services.json';

  // Read the google-services.json file
  final file = File(filePath);
  final jsonString = file.readAsStringSync();

  // Parse the JSON data
  final config = jsonDecode(jsonString);

  // Replace the API key with the environment variable
  config['client'][0]['api_key'][0]['current_key'] = apiKey;

  // Convert the modified JSON back to a string
  final updatedConfig = jsonEncode(config);

  // Write the updated configuration back to the file
  file.writeAsStringSync(updatedConfig);

  print('API key replaced successfully.');
}