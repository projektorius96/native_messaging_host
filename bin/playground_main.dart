import 'dart:io' as dart_io;
import 'package:native_messaging_host/native_messaging_host.dart'
    as package_nmh;


void main() {
  package_nmh.initHost();
}

// Graceful termination on Ctrl+C (SIGINT)
final sig = dart_io.ProcessSignal.sigint.watch()
  ..listen((signal) {
    dart_io.exit(0);
  });