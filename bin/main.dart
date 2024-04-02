import 'dart:io' as dart_io;

import 'package:native_messaging_host/src/native_messaging_host_base.dart';
/* import 'dart:convert' as dart_converter; */
/* import 'package:native_messaging_host/src/native_messaging_host_base.dart'; */

void main(List<String> arguments) {
  // Define the path to the log file
  var logFilePath = 'main.log';

  // Create a File object for the log file
  var logFile = dart_io.File(logFilePath);

  // Open the log file in write mode and create it if it doesn't exist
  var sink = logFile.openWrite(mode: dart_io.FileMode.append);

  dart_io.stdin.listen((data) {
    /* IGNORE */
      /* sink.addStream(
              Stream.fromIterable([data])
      ); */
      /* logFile.writeAsString(String.fromCharCodes(decodeMessage(data).toString().codeUnits)); */// # [123, 34, 116, 101, 120, 116, 34, 58, 34, 72, 101, 108, 108, 111, 34, 125]
    /* IGNORE */

    // DEV_NOTE # somewhy String.fromCharCodes forces Chrome to exit native messaging host with Error: Native host has exited.
    sink.write( /* String.fromCharCodes( */ decodeMessage(data) /* ) */ ) ; /* [123, 34, 116, 101, 120, 116, 34, 58, 34, 72, 101, 108, 108, 111, 34, 125] */// yet in JavaScript String.fromCharCodes([123, 34, 116, 101, 120, 116, 34, 58, 34, 72, 101, 108, 108, 111, 34, 125]) returns expected "{text: 'Hello'}"
    /* dart_io.stdout.write(encodeMessage( String.fromCharCodes( [123, 34, 116, 101, 120, 116, 34, 58, 34, 72, 101, 108, 108, 111, 34, 125] ) )); */// exits Native messaging host with Error: Native host has exited.
  });

  // Graceful termination on Ctrl+C (SIGINT), see [cont'd] below
  dart_io.ProcessSignal.sigint.watch().listen((signal) {
    // Close the log file
    sink.close();

    // [cont'd]
    dart_io.exit(0);
  });
}