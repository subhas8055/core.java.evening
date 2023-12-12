import 'dart:typed_data';

import 'package:base32/base32.dart' as base32;
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:unvired_sdk/src/helper/framework_helper.dart';
import 'dart:math' as math;

class PassCodeGenerator {
  /** Default decimal passcode length */
  static final int _PASS_CODE_LENGTH = 6;

  /** Default passcode timeout period (in seconds) */
  static final int _INTERVAL = 30;

  /** The number of previous and future intervals to check */
  static final int _ADJACENT_INTERVALS = 5;

  static final int _PIN_MODULO = math.pow(10, _PASS_CODE_LENGTH).toInt();

  List<String> computePin(String? secret, String? feUserId) {
    var timeStamp = FrameworkHelper.getTimeStamp();
    if (secret == null || secret.length == 0) {
      return [timeStamp];
    }

    try {
      final Uint8List keyBytes = base32.base32.decode(secret.toUpperCase());
      var hmacSha1 = Hmac(sha1, keyBytes.toList()); // HMAC-SHA1
      feUserId = feUserId! + "~" + timeStamp;
      List<int> list = feUserId.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      Digest digest = hmacSha1.convert(bytes.toList());
      // Dynamically truncate the hash
      // OffsetBits are the low order bits of the last byte of the hash
      int offset =
          digest.bytes.toList()[digest.bytes.toList().length - 1] & 0xF;
      var result = 0;
      for (int i = 0; i < 4; ++i) {
        result = (result << 8) + digest.bytes[offset++];
      }

      int truncatedHash = result & 0x7FFFFFFF;
      int pinValue = truncatedHash % _PIN_MODULO;
      return [padOutput(pinValue), timeStamp];
    } catch (e) {
      Logger.logError("PassCodeGenerator", "computePin", e.toString());
      throw (e);
    }
  }

  String padOutput(int value) {
    String result = value.toString();
    for (int i = result.length; i < _PASS_CODE_LENGTH; i++) {
      result = "0" + result;
    }
    return result;
  }
}
