import 'dart:io' as io;
import 'dart:convert' as convert;
import 'package:native_messaging_host/native_messaging_host.dart';

void main(List<String> arguments) {

  io.stdin.listen((data) async {
    List<dynamic> charCodes = decodeMessage(data);
    List<int> charCodesInt = charCodes.cast<int>();
    Map decodedMessage = convert.jsonDecode(String.fromCharCodes(charCodesInt));
        /// DEV_NOTE # Reuse a structure that carries a message, just alternating the text value, e.g.:
        decodedMessage["text"] = "Hello from Dart";
    io.stdout.add(encodeMessage(decodedMessage));
    await io.stdout.flush();
  });

  io.ProcessSignal.sigint.watch().listen((signal) {
    io.exit(0);
  });

}
