import 'dart:io' as dart_io;
import 'dart:convert' as dart_convert;
import 'dart:typed_data' as dart_buffer;

/// The `captureStdin` will capture stream and write to file as String 
dart_io.IOSink captureStdin(List<int> charCodesInt, {String outdir = 'log.jsonl'}){
  // Open the log file in write mode and create it if it doesn't exist
  final sink = dart_io.File(outdir).openWrite(mode: dart_io.FileMode.append);
  sink.writeln(String.fromCharCodes(charCodesInt));

  return sink;
}

/// Native Messaging Host encoding implementation, hence `encodeMessage`
encodeMessage(jsonString) {
  /// DEV_NOTE # Encode the JSON string to UTF-8
  final encodedJson = dart_convert.jsonEncode(jsonString);

  /// DEV_NOTE # Calculate the message length
  final messageLength = encodedJson.length;

  /// DEV_NOTE # Allocate a buffer for the entire message (including the 32-bit prefix)
  final buffer = dart_buffer.Uint8List(4 + messageLength);

  /// DEV_NOTE # Write the message length as a 32-bit little endian integer
  buffer.buffer
      .asByteData()
      .setInt32(0, messageLength, dart_buffer.Endian.little);

  /// DEV_NOTE # Copy the encoded JSON into the buffer starting from the offset
  buffer.setAll(4, encodedJson.codeUnits);

  return buffer;
}

/// Native Messaging Host decoding implementation, hence `decodeMessage`
decodeMessage(buffer) {
  /// DEV_NOTE # Read message length via getInt32 view
  final messageLength =
      buffer.buffer.asByteData().getInt32(0, dart_buffer.Endian.host);

  /// DEV_NOTE # Hard-coded offset
  final offset = 4;

  /// DEV_NOTE # Get the payload without the 32-bit prefix
  final payload = buffer.sublist(offset, messageLength + offset);

  /// DEV_NOTE # Decode the payload from UTF-8 to a String
  final jsonString = dart_convert.jsonDecode(payload.toString());

  return jsonString;
}
