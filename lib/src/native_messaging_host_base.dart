import 'dart:io' as dart_io;
import 'dart:convert' as dart_convert;
import 'dart:typed_data' as typed_data;

/// Capture and write a readable JSON line to disk.
/// If [framed] is true the first 4 bytes are treated as the 32-bit little-endian
/// length prefix and will be stripped before decoding as UTF-8.
dart_io.IOSink captureStdin(List<int> bytes,
    {String outdir = 'log.jsonl', bool framed = false}) {
  final sink = dart_io.File(outdir).openWrite(mode: dart_io.FileMode.append);

  try {
    List<int> payload = bytes;
    if (framed && bytes.length > 4) {
      payload = bytes.sublist(4); // strip 4-byte length prefix
    }
    final String text = dart_convert.utf8.decode(payload);
    sink.writeln(text);
  } catch (e) {
    // If decoding fails, write a short binary marker and the byte length
    sink.writeln('<<binary ${bytes.length} bytes>>');
  }

  return sink;
}

/// Native Messaging Host encoding implementation
typed_data.Uint8List encodeMessage(dynamic data) {
  // Convert the Dart object to JSON string, then to UTF-8 bytes
  final String jsonString = dart_convert.jsonEncode(data);
  final typed_data.Uint8List encodedJson =
      typed_data.Uint8List.fromList(dart_convert.utf8.encode(jsonString));

  final int messageLength = encodedJson.length;
  const int offset = 4;
  final typed_data.Uint8List buffer = typed_data.Uint8List(offset + messageLength);

  // Write 32-bit little-endian length prefix
  buffer.buffer.asByteData().setInt32(0, messageLength, typed_data.Endian.little);

  // Copy payload bytes directly
  buffer.setRange(offset, offset + messageLength, encodedJson);

  return buffer;
}

/// Native Messaging Host decoding implementation
/// Expects a framed buffer (4-byte little-endian length prefix + payload).
dynamic decodeMessage(typed_data.Uint8List data) {
  if (data.length < 4) {
    throw ArgumentError('Data too short to contain a 4-byte length prefix');
  }

  // Read 32-bit little-endian length
  final int messageLength =
      data.buffer.asByteData().getInt32(0, typed_data.Endian.little);

  const int offset = 4;
  final int end = offset + messageLength;

  if (data.length < end) {
    throw ArgumentError(
        'Incomplete payload: expected $messageLength bytes, have ${data.length - offset}');
  }

  final typed_data.Uint8List payload = data.sublist(offset, end);

  // Decode payload bytes as UTF-8 then parse JSON
  final String jsonText = dart_convert.utf8.decode(payload);
  final dynamic result = dart_convert.jsonDecode(jsonText);

  return result;
}