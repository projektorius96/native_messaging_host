import 'dart:convert' as dart_convert;
import 'dart:typed_data' as dart_buffer;

// void initHost() {
//   /* TRANFORMERS : alternatives A & B respectively */
//   /// [alternative A] : the code below is meant to transform stdin to human-readable text
//   // stdin.listen((data) {
//   //   Stream<List<int>> byteStream =
//   //       Stream.fromIterable([data]);
//   //   byteStream.transform(dart_convert.utf8.decoder).listen((txt) {
//   //     print(txt/* .runes.string */);
//   //   });
//   // });
//   /* === */
//   /// [alternative B] : the code below is meant to transform stdin to human-readable text
//   // dart_io.stdin.transform(dart_convert.utf8.decoder).listen((txt) {
//   //   print(txt/* .runes.string */);
//   // });
// }

encodeMessage(jsonString) {
  // Encode the JSON string to UTF-8
  final encodedJson = dart_convert.jsonEncode(jsonString);

  // Calculate the message length
  final messageLength = encodedJson.length;

  // Allocate a buffer for the entire message (including the 32-bit prefix)
  final buffer = dart_buffer.Uint8List(4 + messageLength);

  // Write the message length as a 32-bit little endian integer
  buffer.buffer
      .asByteData()
      .setInt32(0, messageLength, dart_buffer.Endian.little);

  // Copy the encoded JSON into the buffer starting from the offset
  /* buffer.setRange(4, buffer.length, encodedJson.codeUnits); */// or simply do as follows:..
  buffer.setAll(4, encodedJson.codeUnits);

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
  final jsonString = dart_convert.jsonDecode(payload.toString());

  return jsonString;
}
