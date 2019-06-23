import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart';

class CryptoUtils {
  static Future<String> getSha1(File file) async {
    var ds = new DigestSink();
    var s = sha1.startChunkedConversion(ds);
    await for (var bytes in file.openRead()) {
      s.add(bytes);
    }

    s.close();
    return ds.value.toString();
  }
}
