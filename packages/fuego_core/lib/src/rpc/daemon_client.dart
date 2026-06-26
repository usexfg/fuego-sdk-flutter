import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/block.dart';
import '../models/transaction.dart';

class FuegoDaemonClient {
  final String host;
  final int port;
  final http.Client _http;

  FuegoDaemonClient({
    this.host = '127.0.0.1',
    this.port = defaultRpcPort,
    http.Client? client,
  }) : _http = client ?? http.Client();

  Uri get _uri => Uri(scheme: 'http', host: host, port: port, path: '/json_rpc');

  Future<Map<String, dynamic>> _call(String method, [Map<String, dynamic>? params]) async {
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'id': 'fuego_core',
      'method': method,
      if (params != null) 'params': params,
    });
    final resp = await _http.post(_uri,
        headers: {'Content-Type': 'application/json'}, body: body);
    if (resp.statusCode != 200) {
      throw FuegoRpcException('HTTP ${resp.statusCode}: ${resp.body}');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    if (data.containsKey('error') && data['error'] != null) {
      throw FuegoRpcException(data['error'].toString());
    }
    return (data['result'] as Map<String, dynamic>?) ?? {};
  }

  // ---- Node / Network ----

  Future<NetworkInfo> getInfo() async {
    final r = await _call('get_info');
    return NetworkInfo.fromJson(r);
  }

  Future<int> getBlockCount() async {
    final r = await _call('get_block_count');
    return r['count'] as int? ?? r['block_count'] as int? ?? 0;
  }

  Future<Block> getBlock({int? height, String? hash}) async {
    final params = <String, dynamic>{};
    if (height != null) params['height'] = height;
    if (hash != null) params['hash'] = hash;
    final r = await _call('get_block', params);
    return Block.fromJson(r);
  }

  // ---- Wallet ----

  Future<int> getBalance() async {
    final r = await _call('get_balance');
    return (r['balance'] ?? r['unlocked_balance'] ?? 0) as int;
  }

  Future<String> getAddress() async {
    final r = await _call('get_address');
    return r['address'] as String? ?? '';
  }

  Future<String> sendTransaction(SendTransactionRequest req) async {
    final r = await _call('transfer', req.toJson());
    return r['tx_hash'] as String? ?? '';
  }

  Future<List<FuegoTransaction>> getTransactions({int count = 20}) async {
    final r = await _call('get_transfers', {'in': true, 'out': true, 'pending': true, 'count': count});
    final txs = <FuegoTransaction>[];
    for (final entry in ['in', 'out', 'pending']) {
      final list = r[entry] as List<dynamic>?;
      if (list == null) continue;
      for (final t in list) {
        txs.add(FuegoTransaction.fromJson({
          ...(t as Map<String, dynamic>),
          'direction': entry == 'in' ? 'in' : entry == 'out' ? 'out' : 'pending',
        }));
      }
    }
    txs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return txs;
  }

  // ---- Mining ----

  Future<void> startMining({int threads = 1, String? address}) async {
    try {
      await _call('start_mining', {
        'threads_count': threads,
        if (address != null) 'miner_address': address,
      });
    } catch (_) {
      // Mining not available on mainnet
    }
  }

  Future<void> stopMining() async {
    try {
      await _call('stop_mining');
    } catch (_) {}
  }

  Future<Map<String, dynamic>> getMiningStatus() async =>
      await _call('mining_status');

  // ---- Peer info ----

  Future<int> getPeerCount() async {
    final r = await _call('get_connections');
    return (r['connections'] as List<dynamic>?)?.length ?? 0;
  }

  void dispose() => _http.close();
}

class FuegoRpcException implements Exception {
  final String message;
  const FuegoRpcException(this.message);
  @override
  String toString() => 'FuegoRpcException: $message';
}
