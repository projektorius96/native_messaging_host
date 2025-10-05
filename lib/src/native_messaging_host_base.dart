import 'dart:io' as dart_io;
import 'dart:convert' as dart_convert;
import 'dart:typed_data' as typed_data;

/// The `captureStdin` will capture stream and write to file as String 
dart_io.IOSink captureStdin(List<int> charCodesInt, {String outdir = 'log.jsonl'}){
  // Open the log file in write mode and create it if it doesn't exist
  final sink = dart_io.File(outdir).openWrite(mode: dart_io.FileMode.append);
  sink.writeln(String.fromCharCodes(charCodesInt));

  return sink;
}

/// Native Messaging Host encoding implementation, hence `encodeMessage`
encodeMessage(data) {
  
  // Encodes the [data] as UTF-8 represented by `Uint8List` view. 
  final typed_data.Uint8List encodedJson = dart_convert.utf8.encode(data);

  // DEV_NOTE # Calculate the message length
  final messageLength = encodedJson.length;

  /// DEV_NOTE # Hard-coded offset equivalent to the length of the message
  final offset = 4;

  // DEV_NOTE # Allocate a buffer for the entire message (including the 32-bit prefix)
  final buffer = typed_data.Uint8List(offset + messageLength);

  // DEV_NOTE # Write the message length as a 32-bit little endian integer
  buffer.buffer
      .asByteData()
      .setInt32(0, messageLength, typed_data.Endian.little);

  // DEV_NOTE # Copy the encoded JSON into the buffer starting from the offset
  buffer.setAll(offset, encodedJson.toString().codeUnits);

  return buffer;

}

/// Native Messaging Host decoding implementation, hence `decodeMessage`
decodeMessage(data) {

  /// DEV_NOTE # Read message length via getInt32 view
  final messageLength =
      data.buffer.asByteData().getInt32(0, typed_data.Endian.host);

  /// DEV_NOTE # Hard-coded offset equivalent to the length of the message
  final offset = 4;

  /// DEV_NOTE # Get the payload without the 32-bit prefix
  final payload = data.sublist(offset, messageLength + offset);

  /// DEV_NOTE # Decode the payload from UTF-8 to a String
  final jsonString = dart_convert.jsonDecode(payload.toString());

  return jsonString;

}
