import 'package:fuego_defi_framework/fuego_defi_framework.dart';
import 'package:fuego_defi_rpc_methods/src/internal_exports.dart';
import 'package:fuego_defi_types/fuego_defi_type_utils.dart';

import 'streaming_common.dart';

/// stream::tx_history::enable
class StreamTxHistoryEnableRequest
    extends
        BaseRequest<
          StreamEnableResponse<TxHistoryEvent>,
          GeneralErrorResponse
        > {
  StreamTxHistoryEnableRequest({
    required String rpcPass,
    required this.coin,
    this.clientId,
  }) : super(
         method: 'stream::tx_history::enable',
         rpcPass: rpcPass,
         mmrpc: RpcVersion.v2_0,
       );

  final String coin;
  final int? clientId;

  @override
  JsonMap toJson() => super.toJson().deepMerge({
    'params': {'coin': coin, if (clientId != null) 'client_id': clientId},
  });

  @override
  StreamEnableResponse<TxHistoryEvent> parse(JsonMap json) =>
      StreamEnableResponse<TxHistoryEvent>.parse(json);
}
