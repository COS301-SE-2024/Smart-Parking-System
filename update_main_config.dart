import 'dart:io';

void main() {
  const filePath = 'lib/main.dart';
  final file = File(filePath);

  if (!file.existsSync()) {
    return;
  }

  final lines = file.readAsLinesSync();
  final buffer = StringBuffer();

  for (var i = 0; i < lines.length; i++) {
    if (i >= 1 && i <= 62) {
      buffer.writeln('// ${lines[i]}');
    } else if (i >= 66 && i <= 130) {
      buffer.writeln(lines[i].replaceFirst('// ', ''));
    } else {
      buffer.writeln(lines[i]);
    }
  }

  file.writeAsStringSync(buffer.toString());
}