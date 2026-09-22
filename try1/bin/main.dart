// bin/main.dart
import 'package:try1/trading_domain.dart'; // Sesuaikan nama package lu

void main() async {
  print('=== Simulasi Trading System ===\n');

  // 1. Inisialisasi User
  var kiki = Trader(name: 'Kiki', accountBalance: 100.0);

  // 2. Bikin dummy JSON dari API (buat ngetes fromJson)
  var jsonResponse = {
    'symbol': 'BTC/USDT',
    'entryPrice': 65000.0,
    'type': 'long',
    'leverage': 20.0,
    'marginRequired': 40.0,
    'takeProfitPrice': 68000.0,
  };

  var btcOrder = TradePosition.fromJson(jsonResponse);

  // 3. Tes copyWith (Misal mau update TP sebelum dieksekusi)
  var finalBtcOrder = btcOrder.copyWith(takeProfitPrice: 70000.0);

  print('-- Test Normal Flow --');
  try {
    await kiki.executeOrder(finalBtcOrder);
    print('Data posisi berhasil dikonversi ke JSON:');
    print(finalBtcOrder.toJson());
  } catch (e) {
    print('Error: $e');
  }

  print('\n-- Test Pelanggaran Aturan (Exception) --');
  // Kiki cuma sisa saldo 60. Kita paksa buka ETH dengan margin 100
  var ethOrder = TradePosition(
    symbol: 'ETH/USDT',
    entryPrice: 3500.0,
    type: PositionType.short,
    leverage: 50.0,
    marginRequired: 100.0,
    // takeProfitPrice dibiarkan null (Null Safety in action)
  );

  try {
    await kiki.executeOrder(ethOrder);
  } catch (e) {
    print(
        '🚨 Program tertahan dengan rapi karena Exception menangkap masalah: \n$e');
  }
}
