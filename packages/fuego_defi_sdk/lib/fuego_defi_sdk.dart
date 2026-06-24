/// A high-level opinionated library that provides a simple way to build
/// cross-platform Fuego DeFi Framework applications
/// (primarily focused on wallets). This package consists of multiple
/// sub-packages in the packages folder which are orchestrated by this
/// package (komodo_defi_sdk)
library;

export 'package:fuego_cex_market_data/fuego_cex_market_data.dart'
    show Commodity, Cryptocurrency, FiatCurrency, QuoteCurrency, Stablecoin;
export 'package:fuego_defi_framework/fuego_defi_framework.dart'
    show
        BalanceEvent,
        HeartbeatEvent,
        IKdfHostConfig,
        LocalConfig,
        NetworkEvent,
        OrderStatusEvent,
        OrderbookEvent,
        RemoteConfig,
        ShutdownSignalEvent,
        SwapStatusEvent,
        TxHistoryEvent;
export 'package:fuego_defi_local_auth/fuego_defi_local_auth.dart'
    show AuthenticationState, AuthenticationStatus;
// ZHTLC sync parameters
export 'package:fuego_defi_rpc_methods/fuego_defi_rpc_methods.dart'
    show ZhtlcSyncParams;
export 'package:fuego_defi_sdk/src/addresses/address_operations.dart'
    show AddressOperations;
export 'package:fuego_defi_sdk/src/balances/balance_manager.dart'
    show BalanceManager;
export 'package:fuego_defi_sdk/src/sdk/fuego_defi_sdk_config.dart';
export 'package:fuego_defi_sdk/src/security/security_manager.dart'
    show SecurityManager;
export 'package:fuego_defi_sdk/src/trading/trading_manager.dart'
    show TradingManager;

export 'src/activation/nft_activation_service.dart' show NftActivationService;
export 'src/activation_config/activation_config_service.dart'
    show
        ActivationConfigRepository,
        ActivationConfigService,
        ActivationSettingDescriptor,
        AssetIdActivationSettings,
        InMemoryKeyValueStore,
        JsonActivationConfigRepository,
        WalletIdResolver,
        ZhtlcRecurringSyncMode,
        ZhtlcRecurringSyncPolicy,
        ZhtlcUserConfig;
export 'src/activation_config/hive_activation_config_repository.dart'
    show HiveActivationConfigRepository;
export 'src/assets/_assets_index.dart'
    show ActivatedAssetsCache, AssetHdWalletAddressesExtension;
export 'src/assets/asset_extensions.dart'
    show
        AssetFaucetExtension,
        AssetIdFaucetExtension,
        AssetUnavailableErrorReasonExtension,
        AssetValidation;
export 'src/assets/asset_pubkey_extensions.dart';
export 'src/assets/legacy_asset_extensions.dart';
export 'src/fuego_defi_sdk.dart' show FuegoDefiSdk;
export 'src/transaction_history/transaction_merge_utils.dart'
    show TransactionListReconciler, TransactionMergeUtils;
export 'src/widgets/asset_balance_text.dart';
export 'src/zcash_params/models/download_progress.dart';
export 'src/zcash_params/models/download_result.dart';
export 'src/zcash_params/zcash_params_downloader.dart';
// Zcash parameters download functionality
export 'src/zcash_params/zcash_params_downloader_factory.dart';
