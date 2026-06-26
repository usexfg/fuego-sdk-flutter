enum SwapState {
  initiated,
  keysExchanged,
  escrowFunded,
  presigsReady,
  ctrLocked,
  secretRevealed,
  xfgSpent,
  completed,
  refunded,
  failed,
  unknown,
}

extension SwapStateX on SwapState {
  String get name {
    switch (this) {
      case SwapState.initiated: return 'Initiated';
      case SwapState.keysExchanged: return 'Keys Exchanged';
      case SwapState.escrowFunded: return 'Escrow Funded';
      case SwapState.presigsReady: return 'Presigs Ready';
      case SwapState.ctrLocked: return 'Counterparty Locked';
      case SwapState.secretRevealed: return 'Secret Revealed';
      case SwapState.xfgSpent: return 'XFG Spent';
      case SwapState.completed: return 'Completed';
      case SwapState.refunded: return 'Refunded';
      case SwapState.failed: return 'Failed';
      case SwapState.unknown: return 'Unknown';
    }
  }

  bool get isComplete => this == SwapState.completed;
  bool get isFailed => this == SwapState.failed || this == SwapState.refunded;
  bool get isActive => !isComplete && !isFailed;

  static SwapState fromString(String s) {
    switch (s.toLowerCase()) {
      case 'initiated': return SwapState.initiated;
      case 'keys_exchanged': return SwapState.keysExchanged;
      case 'escrow_funded': return SwapState.escrowFunded;
      case 'presigs_ready': return SwapState.presigsReady;
      case 'ctr_locked': return SwapState.ctrLocked;
      case 'secret_revealed': return SwapState.secretRevealed;
      case 'xfg_spent': return SwapState.xfgSpent;
      case 'completed': return SwapState.completed;
      case 'refunded': return SwapState.refunded;
      case 'failed': return SwapState.failed;
      default: return SwapState.unknown;
    }
  }
}

class SwapInfo {
  final String swapId;
  final String counterpartyId;
  final String baseCoin;
  final String quoteCoin;
  final double baseAmount;
  final double quoteAmount;
  final double rate;
  final SwapState state;
  final int createdAt;
  final int? timelock;
  final String? txHash;
  final String? error;
  final Map<String, dynamic> raw;

  const SwapInfo({
    required this.swapId,
    required this.counterpartyId,
    required this.baseCoin,
    required this.quoteCoin,
    required this.baseAmount,
    required this.quoteAmount,
    required this.rate,
    required this.state,
    required this.createdAt,
    this.timelock,
    this.txHash,
    this.error,
    this.raw = const {},
  });

  factory SwapInfo.fromJson(Map<String, dynamic> json) => SwapInfo(
        swapId: json['swap_id']?.toString() ?? json['id']?.toString() ?? '',
        counterpartyId: json['counterparty_id']?.toString() ?? '',
        baseCoin: json['base_coin']?.toString() ?? json['base']?.toString() ?? '',
        quoteCoin: json['quote_coin']?.toString() ?? json['quote']?.toString() ?? '',
        baseAmount: _d(json['base_amount']),
        quoteAmount: _d(json['quote_amount']),
        rate: _d(json['rate']),
        state: SwapStateX.fromString(json['state']?.toString() ?? 'unknown'),
        createdAt: json['created_at'] as int? ?? 0,
        timelock: json['timelock'] as int?,
        txHash: json['tx_hash']?.toString(),
        error: json['error']?.toString(),
        raw: json,
      );

  static double _d(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  @override
  String toString() => 'SwapInfo($swapId, $baseCoin/$quoteCoin, $state)';
}

class SwapOrder {
  final String orderId;
  final String baseCoin;
  final String quoteCoin;
  final double baseAmount;
  final double price;
  final SwapState state;
  final bool isMine;

  const SwapOrder({
    required this.orderId,
    this.baseCoin = '',
    this.quoteCoin = '',
    this.baseAmount = 0,
    this.price = 0,
    this.state = SwapState.unknown,
    this.isMine = false,
  });

  factory SwapOrder.fromJson(Map<String, dynamic> json) => SwapOrder(
        orderId: json['uuid']?.toString() ?? json['order_id']?.toString() ?? '',
        baseCoin: json['coin']?.toString() ?? '',
        price: SwapInfo._d(json['price']),
        baseAmount: SwapInfo._d(json['base_max_volume'] ?? json['max_volume']),
        isMine: json['is_mine'] == true,
      );
}
