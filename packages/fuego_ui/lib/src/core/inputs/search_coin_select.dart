import 'package:flutter/material.dart';
import 'package:fuego_defi_types/fuego_defi_types.dart';
import 'package:fuego_ui/fuego_ui.dart';

Future<AssetId?> showCoinSearch(
  BuildContext context, {
  required List<AssetId> coins,
  DropdownMenuItem<AssetId> Function(AssetId coinId)? customCoinItemBuilder,
}) {
  final theme = Theme.of(context);
  final items =
      coins.map((assetId) {
        return customCoinItemBuilder?.call(assetId) ??
            DropdownMenuItem<AssetId>(
              value: assetId,
              child: Row(
                children: [
                  AssetIcon(assetId),
                  const SizedBox(width: 12),
                  Text(assetId.name, style: theme.listTileTheme.titleTextStyle),
                ],
              ),
            );
      }).toList();

  return showSearchableSelect<AssetId>(
    context: context,
    items: items,
    searchHint: 'Search coins', //TODO: Localize
  );
}
