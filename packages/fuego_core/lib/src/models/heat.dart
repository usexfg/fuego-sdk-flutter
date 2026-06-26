import '../constants.dart';

class HeatMetrics {
  final double totalSupply;
  final double burned;
  final double price;
  final double marketCap;

  const HeatMetrics({
    required this.totalSupply,
    required this.burned,
    required this.price,
    required this.marketCap,
  });

  factory HeatMetrics.fromJson(Map<String, dynamic> json) => HeatMetrics(
        totalSupply: _d(json['total_supply']),
        burned: _d(json['burned']),
        price: _d(json['price']),
        marketCap: _d(json['market_cap']),
      );

  static double _d(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}

class HeatBurnRequest {
  final double amount; // in XFG
  final String address;

  const HeatBurnRequest({required this.amount, required this.address});

  Map<String, dynamic> toJson() => {
        'amount': (amount * atomicPerCoin).round(),
        'address': address,
      };
}

class HeatBurnResult {
  final String txHash;
  final double heatReceived;
  final double xfgBurned;

  const HeatBurnResult({
    required this.txHash,
    required this.heatReceived,
    required this.xfgBurned,
  });

  factory HeatBurnResult.fromJson(Map<String, dynamic> json) => HeatBurnResult(
        txHash: json['tx_hash'] as String? ?? '',
        heatReceived: HeatMetrics._d(json['heat_received']),
        xfgBurned: HeatMetrics._d(json['xfg_burned']),
      );
}

class HeatProof {
  final String proof;
  final String merkleRoot;
  final int blockHeight;

  const HeatProof({
    required this.proof,
    required this.merkleRoot,
    required this.blockHeight,
  });

  factory HeatProof.fromJson(Map<String, dynamic> json) => HeatProof(
        proof: json['proof'] as String? ?? '',
        merkleRoot: json['merkle_root'] as String? ?? '',
        blockHeight: json['block_height'] as int? ?? 0,
      );
}
