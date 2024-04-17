import 'dart:io' as io;
import 'dart:convert' as convert;

import 'package:native_messaging_host/native_messaging_host.dart';
import 'package:native_messaging_host/src/native_messaging_host_base.dart';
/* import 'dart:typed_data';
import 'package:native_messaging_host/src/native_messaging_host_base.dart'; */

void main(List<String> arguments) {
  // Define the path to the log file
  var logFilePath = 'main.log';

  // Create a File object for the log file
  var logFile = io.File(logFilePath);

  // Open the log file in write mode and create it if it doesn't exist
  var sink = logFile.openWrite(mode: io.FileMode.append);

  io.stdin.listen((data) async {
    List<dynamic> charCodes = decodeMessage(data);
    List<int> charCodesInt = charCodes.cast<int>();
    /// A.1 Write to file [PASSING]
    /* sink.write(String.fromCharCodes(charCodesInt)); */// [PASSING] , 1^decodeMessage had been implemented correctly
    /// A.2 Convert to Map and Write to file
    Map decodedMessage = convert.jsonDecode(String.fromCharCodes(charCodesInt));
        decodedMessage["text"] = "Hello from Dart"; // DEV_NOTE # reuse message, just alternating it
    
    /// DEV_NOTE # if encodedMessage correctly implemented, then effectively it should print correct result (1^decodedMessage had PASSED the test with no error before)
    /* sink.write(decodeMessage(encodeMessage(decodedMessage))); */
    /// Because above, the test passed, let's assume encodeMessage is implemented correctly
    io.stdout.add(encodeMessage(decodedMessage));
    await io.stdout.flush();
    /// Alternatively do as follows:
    // io.stdout.addStream(Stream.fromIterable([data])).then((_) async {
    //     await io.stdout.flush();
    // });
  });

  // Graceful termination on Ctrl+C (SIGINT), see [cont'd] below
  io.ProcessSignal.sigint.watch().listen((signal) {
    // Close the log file
    sink.close();

    // [cont'd]
    io.exit(0);
  });
}
