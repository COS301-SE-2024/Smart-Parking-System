// ignore_for_file: avoid_print

import 'dart:io';

void main() {
  const filePath = 'web/index.html';
  final file = File(filePath);

  if (!file.existsSync()) {
    print('File not found: $filePath');
    return;
  }

  final apiKey = Platform.environment['API_KEY_WEB'];
  if (apiKey == null) {
    print('API_KEY_WEB environment variable not set.');
    return;
  }

  final content = file.readAsStringSync();
  final updatedContent = content.replaceAll('YOUR_API_KEY', apiKey);

  file.writeAsStringSync(updatedContent);
  print('Updated $filePath with API_KEY_WEB.');
}