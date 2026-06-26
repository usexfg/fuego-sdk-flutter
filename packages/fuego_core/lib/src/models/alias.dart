class FuegoAlias {
  final String alias;
  final String address;
  final String? comment;
  final int? blockHeight;
  final String? txHash;

  const FuegoAlias({
    required this.alias,
    required this.address,
    this.comment,
    this.blockHeight,
    this.txHash,
  });

  factory FuegoAlias.fromJson(Map<String, dynamic> json) => FuegoAlias(
        alias: json['alias'] as String,
        address: json['address'] as String,
        comment: json['comment'] as String?,
        blockHeight: json['block_height'] as int?,
        txHash: json['tx_hash'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'alias': alias,
        'address': address,
        if (comment != null) 'comment': comment,
        if (blockHeight != null) 'block_height': blockHeight,
        if (txHash != null) 'tx_hash': txHash,
      };

  @override
  String toString() => 'FuegoAlias($alias -> $address)';
}

class AliasRegistrationRequest {
  final String alias;
  final String address;
  final String? comment;

  const AliasRegistrationRequest({
    required this.alias,
    required this.address,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        'alias': alias,
        'address': address,
        if (comment != null) 'comment': comment,
      };
}

class AliasResolveRequest {
  final String alias;

  const AliasResolveRequest({required this.alias});

  Map<String, dynamic> toJson() => {'alias': alias};
}
