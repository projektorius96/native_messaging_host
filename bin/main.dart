import 'dart:io' as dart_io;
import 'package:native_messaging_host/src/native_messaging_host_base.dart';

void main(List<String> arguments) {
  // Define the path to the log file
  var logFilePath = 'main.log';

  // Create a File object for the log file
  var logFile = dart_io.File(logFilePath);

  // Open the log file in write mode and create it if it doesn't exist
  var sink = logFile.openWrite(mode: dart_io.FileMode.append);

  dart_io.stdin.listen((data) {
    sink.addStream(
        Stream.fromIterable([data])
    );
  });

  // Graceful termination on Ctrl+C (SIGINT), see [cont'd] below
  dart_io.ProcessSignal.sigint.watch().listen((signal) {
    // Close the log file
    sink.close();

    // [cont'd]
    dart_io.exit(0);
  });
}
