// Abstract ApiClient

import 'dart:async';

import 'package:fuego_defi_rpc_methods/fuego_defi_rpc_methods.dart';
import 'package:fuego_defi_types/fuego_defi_type_utils.dart';

// ignore: one_member_abstracts
abstract class ApiClient {
  FutureOr<JsonMap> executeRpc(JsonMap request);
  // String get rpcPass;

  // FutureOr<void> stop();
  // FutureOr<bool> isInitialized();
}

// extension KomodoDefiRpcMethodsExtension on ApiClient {
//   KomodoDefiRpcMethods get rpc => KomodoDefiRpcMethods(this);
// }

class ApiClientMock implements ApiClient {
  @override
  Future<JsonMap> executeRpc(JsonMap request) async {
    return <String, dynamic>{};
  }

  // @override
  // String get rpcPass => '';

  // @override
  // Future<void> stop() async {}

  // @override
  // bool isInitialized() {
  //   return true;
  // }
}

extension KomodoDefiRpcMethodsExtension on ApiClient {
  KomodoDefiRpcMethods get rpc => KomodoDefiRpcMethods(this);
}
