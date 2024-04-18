import 'dart:io' as io;
import 'dart:convert' as convert;
import 'package:native_messaging_host/native_messaging_host.dart';

void main(List<String> arguments) {

  io.stdin.listen((data) async {
    List<dynamic> charCodes = decodeMessage(data);
    List<int> charCodesInt = charCodes.cast<int>();

    /// DEV_NOTE # Let's capture original messsage's value of ["text"] sent by [chrome.runtime.sendNativeMessage] to default [./main.log]
    captureStdin(charCodesInt);

    /// DEV_NOTE # Let's reuse a structure that carries a message, just alternating the ["text"] value, as follows:
    Map decodedMessage = convert.jsonDecode(String.fromCharCodes(charCodesInt));
        decodedMessage["text"] = "Hello from Dart";
    io.stdout.add(encodeMessage(decodedMessage));
    await io.stdout.flush();
  });

  io.ProcessSignal.sigint.watch().listen((signal) {
    io.exit(0);
  });

}
