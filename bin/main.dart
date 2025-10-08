import 'dart:io' as io;
import 'dart:typed_data' as typed_data;
import 'package:native_messaging_host/native_messaging_host.dart';

void main(List<String> arguments) {

  io.stdin.listen((data) async {

    // Optionally log the decoded message
    // captureStdin expects a List<int>, so if you want to log the raw bytes:
    captureStdin(data, framed: true);
    
    // Decode the incoming message (data: Uint8List) to a Dart object (Map/List/primitive)
    final Map<String, dynamic> decodedMessage = decodeMessage(typed_data.Uint8List.fromList(data));

    // If you want to log the decoded value as JSON:
    // captureStdin(utf8.encode(jsonEncode(decodedMessage)));

    // Mutate existing message
    decodedMessage['text'] = "Hello from Dart";

    // Encode the message to send back
    var encoded = encodeMessage(decodedMessage);

    io.stdout.add(encoded);

    // Flush to trigger OS-level respond
    await io.stdout.flush();

    // Clean up on SIGINT
    io.ProcessSignal.sigint.watch().listen((signal) {
      // If you opened a file handle, close it here...
      io.exit(0);
    });

  });

}