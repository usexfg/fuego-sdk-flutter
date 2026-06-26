/// Fuego blockchain network parameters.
///
/// Source: xfg_coin_config.json in fuego-suite.
library;

/// Average block time in seconds.
const int avgBlockTime = 480;

/// Block time as a Duration.
const Duration blockDuration = Duration(seconds: avgBlockTime);

/// Epoch size — one epoch equals this many blocks.
const int epochBlocks = 900;

/// Number of blocks per day (86400 / 480 = 180).
const int blocksPerDay = 180;

/// Transaction fee in atomic units (0.0008000 XFG).
const int txFee = 8000;

/// Minimum transaction fee.
const int minTxFee = 8000;

/// Dust threshold — smallest output allowed (0.0001000 XFG).
const int dust = 1000;

/// Confirmations before a transaction is considered mature.
const int matureConfirmations = 60;

/// Required confirmations for most operations.
const int requiredConfirmations = 4;

/// Default RPC port for fuegod.
const int defaultRpcPort = 18180;

/// Default P2P port.
const int defaultP2pPort = 18181;

/// Atomic units per XFG (7 decimal places).
const int atomicPerCoin = 10000000;

/// Number of decimal places.
const int decimalPlaces = 7;

/// Derivation path for HD wallets (BIP44).
const String derivationPath = "m/44'/9797'";

/// Public address type byte.
const int pubType = 25;

/// P2SH address type byte.
const int p2shType = 85;

/// WIF key type byte.
const int wifType = 153;

/// Address prefix.
const String addressPrefix = 'fire';

/// BIP44 coin type index for Fuego.
const int coinType = 9797;

/// Network ID for mainnet.
const int networkId = 6133;

/// Message signing prefix.
const String signMessagePrefix = 'Fuego Signed Message:\n';

/// Trezor coin name.
const String trezorCoin = 'Fuego';

// --- Emission / Treasury ---

/// Maximum supply in XFG.
const double maxSupply = 21000000;

/// Developer fund percentage (0.1% of every transaction).
const double devFee = 0.001;

/// Protocol-level fee for swaps (2% of every swap).
const double swapFee = 0.02;

/// HEAT burn ratio — how many HEAT tokens per 1 XFG burned.
const int heatBurnRatio = 10000;

// --- CD Constants ---

/// Allowed CD term tiers in epochs.
const List<int> cdAllowedTiers = [6, 18, 36, 72];

/// Allowed CD deposit amounts in HEAT.
const List<double> cdAllowedAmounts = [8, 80, 800, 8000];

/// APY rates for each tier (index-mapped to cdAllowedTiers).
const List<double> cdApyRates = [4.2, 5.8, 7.1, 8.5];

/// CD interest rate (2% base).
const double cdInterestRate = 0.02;

/// Fee to developer fund on CD creation.
const double cdDevFee = 0.001;

// --- Mining ---

/// Default number of mining threads.
const int defaultMiningThreads = 1;

/// Mining reward per block (placeholder — check emission schedule).
const double miningReward = 0;

/// Convert atomic units to XFG.
double fromAtomic(int atomic) => atomic / atomicPerCoin;

/// Convert XFG to atomic units.
int toAtomic(double xfg) => (xfg * atomicPerCoin).round();

/// Convert HEAT to atomic units.
int heatToAtomic(double heat) => toAtomic(heat);

/// Convert atomic units to HEAT.
double atomicToHeat(int atomic) => fromAtomic(atomic);

/// Format atomic amount to display string with 7 decimal places.
String formatXfg(int atomic) => fromAtomic(atomic).toStringAsFixed(decimalPlaces);

/// Format HEAT amount.
String formatHeat(double heat) => heat.toStringAsFixed(decimalPlaces);

/// Calculate CD maturity in blocks for a given term (epochs).
int cdMaturityBlocks(int termEpochs) => termEpochs * epochBlocks;

/// Calculate CD term in days.
double cdTermDays(int termEpochs) =>
    (cdMaturityBlocks(termEpochs) * avgBlockTime) / 86400;

/// Calculate CD interest for a given deposit.
double cdInterest(double depositAmount, int termEpochs) {
  final tierIndex = cdAllowedTiers.indexOf(termEpochs);
  if (tierIndex < 0) return 0;
  final rate = cdApyRates[tierIndex] / 100;
  return depositAmount * rate;
}
