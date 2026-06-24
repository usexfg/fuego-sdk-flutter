import 'package:equatable/equatable.dart';
import 'package:fuego_defi_rpc_methods/fuego_defi_rpc_methods.dart';
import 'package:fuego_defi_types/fuego_defi_type_utils.dart';

class AuthOptions extends Equatable {
  const AuthOptions({
    required this.derivationMethod,
    this.allowWeakPassword = false,
    this.privKeyPolicy = const PrivateKeyPolicy.contextPrivKey(),
  });

  factory AuthOptions.fromJson(JsonMap json) {
    return AuthOptions(
      derivationMethod:
          DerivationMethod.parse(json.value<String>('derivation_method')),
      allowWeakPassword: json.valueOrNull<bool>('allow_weak_password') ?? false,
      privKeyPolicy: PrivateKeyPolicy.fromLegacyJson(
        json.valueOrNull<dynamic>('priv_key_policy'),
      ),
    );
  }

  final DerivationMethod derivationMethod;
  final bool allowWeakPassword;
  final PrivateKeyPolicy privKeyPolicy;

  JsonMap toJson() {
    return {
      'derivation_method': derivationMethod.toString(),
      'allow_weak_password': allowWeakPassword,
      'priv_key_policy': privKeyPolicy.toJson(),
    };
  }

  @override
  List<Object?> get props =>
      [derivationMethod, allowWeakPassword, privKeyPolicy];
}
