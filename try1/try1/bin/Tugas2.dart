import 'dart:io';
import 'dart:math';

void main() {
  print('=== Program Menghitung Luas dan Keliling ===');
  print('1. Persegi');
  print('2. Lingkaran');
  print('3. Kubus');

  // Meminta user memilih opsi
  stdout.write('Pilih menu (1/2/3): ');
  String? pilihan = stdin.readLineSync();

  switch (pilihan) {
    case '1':
      // === PERSEGI ===
      print('\n--- Menghitung Persegi ---');
      stdout.write('Masukkan panjang sisi: ');
      double sisi = double.parse(stdin.readLineSync()!);

      double luas = sisi * sisi;
      double keliling = 4 * sisi;

      print('Luas Persegi     : $luas');
      print('Keliling Persegi : $keliling');
      break;

    case '2':
      // === LINGKARAN ===
      print('\n--- Menghitung Lingkaran ---');
      stdout.write('Masukkan panjang jari-jari: ');
      double r = double.parse(stdin.readLineSync()!);

      double luas = pi * r * r;
      double keliling = 2 * pi * r;

      print('Luas Lingkaran     : ${luas.toStringAsFixed(2)}');
      print('Keliling Lingkaran : ${keliling.toStringAsFixed(2)}');
      break;

    case '3':
      // === KUBUS ===
      print('\n--- Menghitung Kubus ---');
      stdout.write('Masukkan panjang rusuk (sisi): ');
      double s = double.parse(stdin.readLineSync()!);

      double luasPermukaan = 6 * (s * s);
      // Catatan: Kubus itu bangun ruang. "Keliling" kubus biasanya diartikan total panjang semua rusuknya (ada 12 rusuk).
      double kelilingRusuk = 12 * s;
      double volume = s * s * s;

      print('Luas Permukaan Kubus : $luasPermukaan');
      print('Total Keliling Rusuk : $kelilingRusuk');
      print(
          'Volume Kubus         : $volume'); // Gua tambahin volume jaga-jaga kalau dosen lu nanyain
      break;

    default:
      print(
          '\nPilihan tidak valid! Silakan jalankan ulang program dan pilih 1, 2, atau 3.');
  }
}
