import 'package:encrypt/encrypt.dart';

class EncryptUtils {
  static final _key = Key.fromUtf8('trash_app_2021_secret_key_encode');
  static final _iv = IV.fromUtf8('trash%?app2021#?');

  static String encryptData(String text) {
    final e = Encrypter(AES(_key, mode: AESMode.cbc));
    final encryptedData = e.encrypt(text, iv: _iv);
    return encryptedData.base64;
  }

  static String decryptData(String text) {
    try {
      final e = Encrypter(AES(_key, mode: AESMode.cbc));
      final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: _iv);
      return decryptedData;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
