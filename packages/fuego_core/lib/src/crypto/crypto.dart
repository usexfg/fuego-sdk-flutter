import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import '../constants.dart';

DynamicLibrary _loadLib() {
  if (Platform.isMacOS) {
    return DynamicLibrary.open('libfuego_crypto.dylib');
  } else if (Platform.isLinux) {
    return DynamicLibrary.open('libfuego_crypto.so');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('fuego_crypto.dll');
  }
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

final _lib = _loadLib();

final _hash = _lib.lookupFunction<
    Void Function(Pointer<Uint8>, Int32, Pointer<Uint8>),
    void Function(Pointer<Uint8>, int, Pointer<Uint8>)>('fuego_hash');

final _generateKeys = _lib.lookupFunction<
    Void Function(Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>),
    void Function(Pointer<Uint8>, Pointer<Uint8>,
        Pointer<Uint8>)>('fuego_generate_keys');

final _generateAddress = _lib.lookupFunction<
    Pointer<Utf8> Function(Pointer<Uint8>, Pointer<Uint8>),
    Pointer<Utf8> Function(Pointer<Uint8>, Pointer<Uint8>)>('fuego_generate_address');

final _validateAddress = _lib.lookupFunction<
    Int32 Function(Pointer<Utf8>),
    int Function(Pointer<Utf8>)>('fuego_validate_address');

final _sign = _lib.lookupFunction<
    Void Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Uint8>),
    void Function(Pointer<Uint8>, Pointer<Uint8>, int,
        Pointer<Uint8>)>('fuego_sign');

final _verifySignature = _lib.lookupFunction<
    Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Uint8>,
        Pointer<Uint8>),
    int Function(Pointer<Uint8>, Pointer<Uint8>, int, Pointer<Uint8>,
        Pointer<Uint8>)>('fuego_verify_signature');

final _generateKeyImage = _lib.lookupFunction<
    Void Function(Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>),
    void Function(Pointer<Uint8>, Pointer<Uint8>,
        Pointer<Uint8>)>('fuego_generate_key_image');

final _keyToMnemonic = _lib.lookupFunction<
    Pointer<Utf8> Function(Pointer<Uint8>),
    Pointer<Utf8> Function(Pointer<Uint8>)>('fuego_key_to_mnemonic');

final _mnemonicToKey = _lib.lookupFunction<
    Void Function(Pointer<Utf8>, Pointer<Uint8>),
    void Function(Pointer<Utf8>, Pointer<Uint8>)>('fuego_mnemonic_to_key');

final _randomBytes = _lib.lookupFunction<
    Void Function(Pointer<Uint8>, Int32),
    void Function(Pointer<Uint8>, int)>('fuego_random_bytes');

final _freeString = _lib.lookupFunction<Void Function(Pointer<Utf8>),
    void Function(Pointer<Utf8>)>('fuego_free_string');

class FuegoKeyPair {
  final Uint8List privateKey; // 32 bytes
  final Uint8List publicKey; // 32 bytes
  final String address;

  const FuegoKeyPair({
    required this.privateKey,
    required this.publicKey,
    required this.address,
  });

  String get hexPrivate => _hex(privateKey);
  String get hexPublic => _hex(publicKey);

  @override
  String toString() => 'FuegoKeyPair($address)';
}

class FuegoCrypto {
  static final FuegoCrypto instance = FuegoCrypto._();
  FuegoCrypto._();

  Uint8List hash(Uint8List input) {
    final out = calloc<Uint8>(64);
    final inp = calloc<Uint8>(input.length);
    try {
      for (var i = 0; i < input.length; i++) inp[i] = input[i];
      _hash(inp, input.length, out);
      return out.asTypedList(64);
    } finally {
      calloc.free(out);
      calloc.free(inp);
    }
  }

  FuegoKeyPair generateKeys() {
    final sk = calloc<Uint8>(32);
    final pk = calloc<Uint8>(32);
    try {
      _generateKeys(sk, pk, pk); // pk reused as temp buffer
      final priv = Uint8List.fromList(sk.asTypedList(32));
      final pub = Uint8List.fromList(pk.asTypedList(32));
      final addr = _generateAddress(spendKey(sk), viewKey(pk));
      final addrStr = addr.toDartString();
      _freeString(addr);
      return FuegoKeyPair(privateKey: priv, publicKey: pub, address: addrStr);
    } finally {
      calloc.free(sk);
      calloc.free(pk);
    }
  }

  String generateAddress(Uint8List publicSpendKey, Uint8List publicViewKey) {
    final sk = calloc<Uint8>(32);
    final vk = calloc<Uint8>(32);
    try {
      for (var i = 0; i < 32; i++) {
        sk[i] = publicSpendKey[i];
        vk[i] = publicViewKey[i];
      }
      final addr = _generateAddress(sk, vk);
      final result = addr.toDartString();
      _freeString(addr);
      return result;
    } finally {
      calloc.free(sk);
      calloc.free(vk);
    }
  }

  bool validateAddress(String address) {
    final a = address.toNativeUtf8();
    try {
      return _validateAddress(a) == 1;
    } finally {
      calloc.free(a);
    }
  }

  Uint8List sign(Uint8List privateKey, Uint8List message) {
    final sk = calloc<Uint8>(32);
    final msg = calloc<Uint8>(message.length);
    final sig = calloc<Uint8>(64);
    try {
      for (var i = 0; i < 32; i++) sk[i] = privateKey[i];
      for (var i = 0; i < message.length; i++) msg[i] = message[i];
      _sign(sk, msg, message.length, sig);
      return Uint8List.fromList(sig.asTypedList(64));
    } finally {
      calloc.free(sk);
      calloc.free(msg);
      calloc.free(sig);
    }
  }

  bool verifySignature(Uint8List publicKey, Uint8List message, Uint8List signature) {
    final pk = calloc<Uint8>(32);
    final msg = calloc<Uint8>(message.length);
    final sig = calloc<Uint8>(64);
    try {
      for (var i = 0; i < 32; i++) pk[i] = publicKey[i];
      for (var i = 0; i < message.length; i++) msg[i] = message[i];
      for (var i = 0; i < 64; i++) sig[i] = signature[i];
      return _verifySignature(pk, msg, message.length, sig, sig) == 1;
    } finally {
      calloc.free(pk);
      calloc.free(msg);
      calloc.free(sig);
    }
  }

  Uint8List generateKeyImage(Uint8List privateSpendKey, Uint8List publicViewKey) {
    final sk = calloc<Uint8>(32);
    final vk = calloc<Uint8>(32);
    final ki = calloc<Uint8>(32);
    try {
      for (var i = 0; i < 32; i++) sk[i] = privateSpendKey[i];
      for (var i = 0; i < 32; i++) vk[i] = publicViewKey[i];
      _generateKeyImage(sk, vk, ki);
      return Uint8List.fromList(ki.asTypedList(32));
    } finally {
      calloc.free(sk);
      calloc.free(vk);
      calloc.free(ki);
    }
  }

  String keyToMnemonic(Uint8List privateKey) {
    final k = calloc<Uint8>(32);
    try {
      for (var i = 0; i < 32; i++) k[i] = privateKey[i];
      final m = _keyToMnemonic(k);
      final result = m.toDartString();
      _freeString(m);
      return result;
    } finally {
      calloc.free(k);
    }
  }

  Uint8List mnemonicToKey(String mnemonic) {
    final m = mnemonic.toNativeUtf8();
    final k = calloc<Uint8>(32);
    try {
      _mnemonicToKey(m, k);
      return Uint8List.fromList(k.asTypedList(32));
    } finally {
      calloc.free(m);
      calloc.free(k);
    }
  }

  Uint8List randomBytes(int length) {
    final buf = calloc<Uint8>(length);
    try {
      _randomBytes(buf, length);
      return Uint8List.fromList(buf.asTypedList(length));
    } finally {
      calloc.free(buf);
    }
  }

  static Pointer<Uint8> spendKey(Pointer<Uint8> buf) => buf;
  static Pointer<Uint8> viewKey(Pointer<Uint8> buf) => buf;
}

String _hex(Uint8List bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
