// lib/trading_domain.dart

// 1. Enum: Dipakai karena arah posisi futures cuma ada dua kemungkinan mutlak.
// Kalau pakai String, rentan typo seperti 'Long', 'longg', atau 'Lng'.
enum PositionType { long, short }

// 2. Custom Exception: Buat ngegagalin proses kalau margin (saldo) gak cukup.
// Aturan dunia nyatanya: lu nggak bisa buka posisi kalau duitnya kurang.
class InsufficientMarginException implements Exception {
  final String cause;
  InsufficientMarginException(this.cause);

  @override
  String toString() => 'InsufficientMarginException: $cause';
}

// 3. Mixin: Perilaku mencatat log (audit) yang bisa ditempel ke class mana aja nanti,
// nggak harus sekerabat dengan class Trader.
mixin TradeAuditable {
  void logAudit(String message) {
    print('[AUDIT - ${DateTime.now().toIso8601String()}] $message');
  }
}

// 4. Class Pertama (Base Class)
abstract class CryptoAsset {
  final String symbol;
  final double entryPrice;

  CryptoAsset({required this.symbol, required this.entryPrice});
}

// 5. Class Kedua (Inheritance dari CryptoAsset)
class TradePosition extends CryptoAsset {
  final PositionType type;
  final double leverage;
  final double marginRequired;

  // Null Safety: takeProfit boleh kosong (null) karena trader
  // kadang ngebiarin posisinya running tanpa set target TP awal.
  final double? takeProfitPrice;

  TradePosition({
    required super.symbol,
    required super.entryPrice,
    required this.type,
    required this.leverage,
    required this.marginRequired,
    this.takeProfitPrice,
  });

  // Method copyWith: Untuk bikin objek baru dengan sedikit modifikasi
  // (misal harga TP digeser), tanpa mengubah objek aslinya (immutable).
  TradePosition copyWith({
    double? entryPrice,
    double? takeProfitPrice,
  }) {
    return TradePosition(
      symbol: symbol,
      entryPrice: entryPrice ?? this.entryPrice,
      type: type,
      leverage: leverage,
      marginRequired: marginRequired,
      takeProfitPrice: takeProfitPrice ?? this.takeProfitPrice,
    );
  }

  // toJson: Ubah object ke Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'entryPrice': entryPrice,
      'type': type.name, // simpan enum sebagai string
      'leverage': leverage,
      'marginRequired': marginRequired,
      'takeProfitPrice': takeProfitPrice,
    };
  }

  // fromJson: Bikin object dari Map (JSON)
  factory TradePosition.fromJson(Map<String, dynamic> json) {
    return TradePosition(
      symbol: json['symbol'],
      entryPrice: json['entryPrice'],
      type: PositionType.values.firstWhere((e) => e.name == json['type']),
      leverage: json['leverage'],
      marginRequired: json['marginRequired'],
      takeProfitPrice: json['takeProfitPrice'],
    );
  }
}

// 6. Class Ketiga (Komposisi: Trader Punya List of TradePosition)
class Trader with TradeAuditable {
  final String name;
  double accountBalance;
  final List<TradePosition> activePositions = [];

  Trader({required this.name, required this.accountBalance});

  // Method Async dengan try-catch
  Future<void> executeOrder(TradePosition position) async {
    try {
      logAudit('Memproses order ${position.symbol} ${position.type.name}...');

      // Simulasi delay eksekusi server API
      await Future.delayed(Duration(seconds: 1));

      // Validasi aturan: Saldo cukup nggak buat nahan margin?
      if (position.marginRequired > accountBalance) {
        throw InsufficientMarginException(
            'Saldo kurang! Butuh ${position.marginRequired}, sisa saldo $accountBalance.');
      }

      accountBalance -= position.marginRequired;
      activePositions.add(position);
      logAudit(
          'Berhasil! Posisi ${position.symbol} masuk ke portofolio. Sisa saldo: $accountBalance');
    } catch (e) {
      logAudit('Order Gagal -> $e');
      rethrow; // Lempar lagi errornya biar bisa ditangkap di main.dart
    }
  }
}
