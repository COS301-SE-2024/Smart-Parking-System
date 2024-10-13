import 'dart:io';

void main() async {
  // Path to your main.dart file
  const filePath = 'lib/main.dart';

  // Read the file
  final file = File(filePath);
  String content = await file.readAsString();

  // Replace the line with the GitHub secret
  final newContent = content.replaceAll(
    "apiKey: dotenv.env['API_KEY_WEB']!,",
    "apiKey: const String.fromEnvironment('API_KEY_WEB'),",
  );

  // Write the updated content back to the file
  await file.writeAsString(newContent);

  // ignore: avoid_print
  print('Env API key replaced successfully.');
}