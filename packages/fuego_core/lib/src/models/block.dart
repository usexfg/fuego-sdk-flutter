import '../constants.dart';

class Block {
  final int height;
  final String hash;
  final int timestamp;
  final int difficulty;
  final int txCount;
  final int size;

  const Block({
    required this.height,
    required this.hash,
    required this.timestamp,
    required this.difficulty,
    required this.txCount,
    required this.size,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        height: json['height'] as int,
        hash: json['hash'] as String,
        timestamp: json['timestamp'] as int,
        difficulty: json['difficulty'] as int,
        txCount: (json['tx_count'] ?? json['transactions_count'] ?? 0) as int,
        size: (json['block_size'] ?? json['size'] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
        'height': height,
        'hash': hash,
        'timestamp': timestamp,
        'difficulty': difficulty,
        'tx_count': txCount,
        'block_size': size,
      };

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  @override
  String toString() => 'Block($height, $hash)';
}

class SyncStatus {
  final int height;
  final int targetHeight;
  final bool synced;
  final double progress;

  const SyncStatus({
    required this.height,
    required this.targetHeight,
    required this.synced,
    required this.progress,
  });

  factory SyncStatus.fromJson(Map<String, dynamic> json) {
    final h = json['height'] as int;
    final th = json['target_height'] as int;
    return SyncStatus(
      height: h,
      targetHeight: th,
      synced: json['synced'] as bool? ?? (h >= th),
      progress: th > 0 ? h / th : 0,
    );
  }
}

class NetworkInfo {
  final int height;
  final String topBlockHash;
  final int difficulty;
  final int hashrate;
  final int peerCount;
  final int txCount;
  final int txPoolSize;

  const NetworkInfo({
    required this.height,
    required this.topBlockHash,
    required this.difficulty,
    required this.hashrate,
    required this.peerCount,
    required this.txCount,
    required this.txPoolSize,
  });

  factory NetworkInfo.fromJson(Map<String, dynamic> json) => NetworkInfo(
        height: json['height'] as int,
        topBlockHash: json['top_block_hash'] as String? ?? '',
        difficulty: json['difficulty'] as int? ?? 0,
        hashrate: json['hashrate'] as int? ?? 0,
        peerCount: json['incoming_connections_count'] as int? ?? 0,
        txCount: json['tx_count'] as int? ?? 0,
        txPoolSize: json['tx_pool_size'] as int? ?? 0,
      );
}
