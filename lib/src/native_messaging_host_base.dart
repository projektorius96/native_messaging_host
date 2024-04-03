import 'dart:io' as dart_io;
import 'dart:convert' as dart_converter;
import 'dart:typed_data' as dart_buffer;

printExact(s) {
  return print(s.replaceFirst('\n', ''));
}

/// HOW TO USE:
/// run command: dart run main.dart and keep pressing Enter to mock inbound chunks
void initHost() {
  /// herein [data] comes from Chromium as an idiomatic encodeMessage(Uint32LE)
  dart_io.stdin.listen((data) {
    /* IGNORE */
    /* dart_buffer.Uint8List d = data;
      print(Stream.fromIterable(d)); */
    /* IGNORE */

    final decodedMessage = decodeMessage(data /* encodeMessage(data) */);

    print(decodedMessage);
  });

  /// [alternative A] : the code below is meant to transform stdin to human-readable text
  // stdin.listen((data) {
  //   Stream<List<int>> byteStream =
  //       Stream.fromIterable([data]);
  //   byteStream.transform(dart_converter.utf8.decoder).listen((txt) {
  //     print(txt/* .runes.string */);
  //   });
  // });

  /// [alternative B] : the code below is meant to transform stdin to human-readable text
  // dart_io.stdin.transform(dart_converter.utf8.decoder).listen((txt) {
  //   print(txt/* .runes.string */);
  // });
}

encodeMessage(mapLiteral) {
  // Convert the map to a JSON string
  String jsonMessage = dart_converter.jsonEncode(mapLiteral);

  // Get the length of the message in bytes
  int messageLength = jsonMessage.length;

  // Ensure the message does not exceed the maximum size
  if (messageLength > 1048576) {
    throw ArgumentError('Message exceeds maximum size of 1 MB');
  }

  // Convert the message length to bytes using native byte order (little-endian on Windows)
  final lengthBytes = dart_buffer.ByteData(4);
    lengthBytes.setInt32(0, messageLength, dart_buffer.Endian.host);

  // Convert the JSON message string to UTF-8 encoded bytes
  List<int> utf8Bytes = dart_converter.utf8.encoder.convert(jsonMessage);

  // Combine the length bytes and UTF-8 encoded message bytes
  dart_buffer.Uint8List message = dart_buffer.Uint8List(4 + messageLength);
    message.setRange(0, 4, lengthBytes.buffer.asUint8List());
    message.setRange(4, 4 + messageLength, utf8Bytes);

  return message;
}

decodeMessage(buffer) {
  // Read message length with letting Dart VM itself to decide what Endian to use with respect tho host (most likely little endian)
  final messageLength =
      buffer.buffer.asByteData().getInt32(0, dart_buffer.Endian.host);

  // hard-coded offset
  final offset = 4;

  // Get the payload without the 32-bit prefix
  final payload = buffer.sublist(offset, messageLength + offset);

  // Decode the payload from UTF-8 to a string
  final jsonString = dart_converter.jsonDecode(payload.toString());

  return jsonString;
}
