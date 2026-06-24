import 'package:fuego_defi_rpc_methods/fuego_defi_rpc_methods.dart';
import 'package:fuego_defi_types/fuego_defi_type_utils.dart';

class SyncStatusResponse {
  SyncStatusResponse({required this.state, this.additional})
    : assert(
        (state != TransactionSyncStatusEnum.inProgress &&
                state != TransactionSyncStatusEnum.error) ||
            additional != null,
        'additional must be present for InProgress and Error states',
      );

  factory SyncStatusResponse.fromJson(Map<String, dynamic> json) {
    return SyncStatusResponse(
      state: TransactionSyncStatusEnum.parse(json.value<String>('state')),
      additional:
          json.containsKey('additional_info')
              ? SyncStatusExtended.fromJson(
                json.value<JsonMap>('additional_info'),
              )
              : null,
    );
  }
  final TransactionSyncStatusEnum state;
  final SyncStatusExtended? additional;

  Map<String, dynamic> toJson() {
    return {
      'state': state.value,
      if (additional != null) 'additional_info': additional!.toJson(),
    };
  }
}
