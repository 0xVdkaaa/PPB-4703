import 'dart:io';

// Membuat Class untuk struktur perhitungan nilai
class Penilaian {
  // === ATRIBUT ===
  String nim = '';
  String nama = '';
  double nilaiUts = 0;
  double nilaiTugas = 0;
  double nilaiUas = 0;

  double pNilaiUts = 0;
  double pNilaiTugas = 0;
  double pNilaiUas = 0;
  double nilaiAkhir = 0;

  String nHuruf = '';
  String predikat = '';

  // === METHOD ===

  // Method 1: hitungNilai (untuk menghitung persentase dan nilai akhir)
  void hitungNilai() {
    pNilaiUts = 0.30 * nilaiUts;
    pNilaiTugas = 0.35 * nilaiTugas;
    pNilaiUas = 0.35 * nilaiUas;

    nilaiAkhir = pNilaiTugas + pNilaiUts + pNilaiUas;

    // Memanggil method lain untuk mengisi nilai huruf dan predikat
    nHuruf = getNilaiHuruf();
    predikat = getPredikat();
  }

  // Method 2: getNilaiHuruf (menentukan A/B/C/D/E dari nilai akhir)
  String getNilaiHuruf() {
    if (nilaiAkhir >= 85) return 'A';
    if (nilaiAkhir >= 75) return 'B';
    if (nilaiAkhir >= 65) return 'C';
    if (nilaiAkhir >= 50) return 'D';
    return 'E';
  }

  // Method 3: getPredikat (menentukan predikat berdasarkan huruf)
  String getPredikat() {
    switch (nHuruf) {
      case 'A':
        return 'Sangat Baik';
      case 'B':
        return 'Baik';
      case 'C':
        return 'Cukup';
      case 'D':
        return 'Kurang';
      case 'E':
        return 'Sangat Kurang';
      default:
        return 'Tidak valid';
    }
  }

  // Method 4: cetakNilai (menampilkan semua hasil)
  void cetakNilai() {
    print('\n==================================');
    print('      HASIL PERHITUNGAN NILAI     ');
    print('==================================');
    print('NIM            : $nim');
    print('Nama           : $nama');
    print('Nilai Tugas    : $nilaiTugas (35% = $pNilaiTugas)');
    print('Nilai UTS      : $nilaiUts (30% = $pNilaiUts)');
    print('Nilai UAS      : $nilaiUas (35% = $pNilaiUas)');
    print('----------------------------------');
    print('Nilai Akhir    : $nilaiAkhir');
    print('Nilai Huruf    : $nHuruf');
    print('Predikat       : $predikat');
    print('==================================\n');
  }
}

void main() {
  // Membuat objek dari class Penilaian
  Penilaian mhs = Penilaian();

  print('\n=== Program Input Nilai Mahasiswa ===');

  // Atribut nama diisi langsung di kode
  mhs.nama = 'Rizqy Akbar Dinul Putra';
  print('Nama Mahasiswa : ${mhs.nama}');

  // Meminta input NIM dan Nilai
  stdout.write('Masukkan NIM         : ');
  mhs.nim = stdin.readLineSync()!;

  stdout.write('Masukkan Nilai Tugas : ');
  mhs.nilaiTugas = double.parse(stdin.readLineSync()!);

  stdout.write('Masukkan Nilai UTS   : ');
  mhs.nilaiUts = double.parse(stdin.readLineSync()!);

  stdout.write('Masukkan Nilai UAS   : ');
  mhs.nilaiUas = double.parse(stdin.readLineSync()!);

  // Memanggil method untuk memproses perhitungan
  mhs.hitungNilai();

  // Memanggil method untuk mencetak hasil
  mhs.cetakNilai();
}
