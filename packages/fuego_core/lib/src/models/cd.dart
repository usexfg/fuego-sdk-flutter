import '../constants.dart';

class CdInfo {
  final String id;
  final String coin;
  final double amount;
  final double interestRate;
  final double interestEarned;
  final int maturityHeight;
  final int depositHeight;
  final int createdAt;
  final String txHash;
  final String status; // active, matured, claimed

  const CdInfo({
    required this.id,
    required this.coin,
    required this.amount,
    required this.interestRate,
    required this.interestEarned,
    required this.maturityHeight,
    required this.depositHeight,
    required this.createdAt,
    required this.txHash,
    required this.status,
  });

  factory CdInfo.fromJson(Map<String, dynamic> json) => CdInfo(
        id: json['id']?.toString() ?? json['cd_id']?.toString() ?? '',
        coin: json['coin'] as String? ?? 'HEAT',
        amount: _toDouble(json['amount']),
        interestRate: _toDouble(json['interest_rate']),
        interestEarned: _toDouble(json['interest_earned'] ?? json['interest']),
        maturityHeight: (json['maturity_height'] ?? json['maturityHeight'] ?? 0) as int,
        depositHeight: (json['deposit_height'] ?? json['depositHeight'] ?? 0) as int,
        createdAt: json['created_at'] as int? ?? 0,
        txHash: json['tx_hash']?.toString() ?? json['txHash']?.toString() ?? '',
        status: json['status'] as String? ?? 'active',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin': coin,
        'amount': amount,
        'interest_rate': interestRate,
        'interest_earned': interestEarned,
        'maturity_height': maturityHeight,
        'deposit_height': depositHeight,
        'created_at': createdAt,
        'tx_hash': txHash,
        'status': status,
      };

  bool get isMatured => status == 'matured';
  bool get isClaimed => status == 'claimed';
  bool get isActive => status == 'active';
  int get blocksRemaining => (maturityHeight - depositHeight).clamp(0, 999999999);
  double get daysRemaining => (blocksRemaining * avgBlockTime) / 86400;
  double get totalAtMaturity => amount + interestEarned;

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  @override
  String toString() => 'CdInfo($id, $amount $coin, $status)';
}

class CdCreateRequest {
  final String coin;
  final double amount;
  final int termEpochs;
  final int durationBlocks;

  const CdCreateRequest({
    required this.coin,
    required this.amount,
    required this.termEpochs,
    required this.durationBlocks,
  });

  Map<String, dynamic> toJson() => {
        'coin': coin,
        'amount': amount,
        'term_epochs': termEpochs,
        'duration_blocks': durationBlocks,
      };
}

class CdCreateResult {
  final String cdId;
  final String txHash;
  final String coin;
  final double amount;
  final int maturityAt;

  const CdCreateResult({
    required this.cdId,
    required this.txHash,
    required this.coin,
    required this.amount,
    required this.maturityAt,
  });

  factory CdCreateResult.fromJson(Map<String, dynamic> json) => CdCreateResult(
        cdId: json['cd_id']?.toString() ?? json['id']?.toString() ?? '',
        txHash: json['tx_hash']?.toString() ?? '',
        coin: json['coin'] as String? ?? 'HEAT',
        amount: CdInfo._toDouble(json['amount']),
        maturityAt: json['maturity_at'] as int? ?? 0,
      );
}
