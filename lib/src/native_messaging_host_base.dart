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

    final decodedMessage = decodeMessage(data/* encodeMessage(data) */);

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

encodeMessage(message) {
  // Encode the message to JSON string
  final jsonString = dart_converter.jsonEncode(message);

  // hard-coded offset
  final offset = 4;

  // Allocate a buffer with space for message length and data
  final bufferLength = jsonString.length + offset;
  final buffer = dart_buffer.Uint8List(bufferLength);

  // Explicitly write message length at idiomatic buffer[index:=0] with 32-bit host endian (most likely little endian)
  buffer.buffer
      .asByteData()
      .setUint32(0, jsonString.length, dart_buffer.Endian.host);

  // Copy encoded data to the buffer
  buffer.setAll(offset, jsonString.codeUnits);

  return buffer;
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
