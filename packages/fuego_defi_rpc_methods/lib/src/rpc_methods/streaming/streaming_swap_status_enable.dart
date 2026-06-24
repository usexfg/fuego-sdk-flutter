import 'package:fuego_defi_framework/fuego_defi_framework.dart';
import 'package:fuego_defi_rpc_methods/src/internal_exports.dart';
import 'package:fuego_defi_types/fuego_defi_type_utils.dart';

import 'streaming_common.dart';

/// stream::swap_status::enable
class StreamSwapStatusEnableRequest extends BaseRequest<
    StreamEnableResponse<SwapStatusEvent>, GeneralErrorResponse> {
  StreamSwapStatusEnableRequest({required String rpcPass, this.clientId})
    : super(
        method: 'stream::swap_status::enable',
        rpcPass: rpcPass,
        mmrpc: RpcVersion.v2_0,
      );

  final int? clientId;

  @override
  JsonMap toJson() => super.toJson().deepMerge({
    'params': {if (clientId != null) 'client_id': clientId},
  });

  @override
  StreamEnableResponse<SwapStatusEvent> parse(JsonMap json) =>
      StreamEnableResponse<SwapStatusEvent>.parse(json);
}


