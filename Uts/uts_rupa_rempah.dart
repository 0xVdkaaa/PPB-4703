import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const UTSRupaRempahApp());
}

class UTSRupaRempahApp extends StatelessWidget {
  const UTSRupaRempahApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMKM Rupa Rempah Solo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// 1. SPLASH SCREEN
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    // Delay 3 detik untuk nampilin splash screen
    await Future.delayed(const Duration(seconds: 3));
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.storefront, size: 100, color: Colors.teal),
            SizedBox(height: 20),
            Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'di',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'UMKM Rupa Rempah Solo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. LOGIN SCREEN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  void _login() async {
    if (_userCtrl.text.isNotEmpty && _passCtrl.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', _userCtrl.text);
      await prefs.setString('password', _passCtrl.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi Username & Password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Registrasi Login', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userCtrl,
                    decoration: const InputDecoration(labelText: 'Username', border: UnderlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: UnderlineInputBorder()),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _userCtrl.clear();
                          _passCtrl.clear();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                        child: const Text('Reset', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MODEL DATA PRODUK
// ==========================================
class Produk {
  final String nama;
  final String deskripsi;
  final double harga;

  Produk(this.nama, this.deskripsi, this.harga);
}

// ==========================================
// 3. DASHBOARD SCREEN
// ==========================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalJual = 0;

  List<Produk> daftarProduk = [
    Produk('Sabun Cair', 'Sabun cair herbal alami dari rempah pilihan yang menyegarkan.', 25000),
    Produk('Skin Care', 'Perawatan wajah glowing berbahan dasar rempah nusantara.', 85000),
    Produk('Lulur Rempah', 'Lulur tradisional untuk mengangkat sel kulit mati.', 45000),
    Produk('Masker Wajah', 'Masker organik mencerahkan dan menyegarkan kulit.', 30000),
    Produk('Minyak Esensial', 'Aromaterapi relaksasi dari ekstrak rempah asli.', 60000),
    Produk('Sampo Herbal', 'Merawat kesehatan rambut dan mencegah rontok.', 35000),
  ];

  // Aksi Menu Kanan Atas
  void _onMenuSelected(String value) async {
    switch (value) {
      case 'Call Center':
        final Uri telLaunchUri = Uri(scheme: 'tel', path: '081234567890');
        launchUrl(telLaunchUri);
        break;
      case 'SMS Center':
        final Uri smsLaunchUri = Uri(scheme: 'sms', path: '081234567890');
        launchUrl(smsLaunchUri);
        break;
      case 'Maps Lokasi':
        final Uri mapsUri = Uri.parse('https://maps.google.com/?q=-7.5755,110.8243'); // Kordinat Solo
        launchUrl(mapsUri);
        break;
      case 'Update User':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UpdateUserScreen()),
        );
        break;
      case 'Logout':
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }
  }

  void _showDeskripsi(Produk p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(p.nama),
        content: Text(p.deskripsi),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return {'Call Center', 'SMS Center', 'Maps Lokasi', 'Update User', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: daftarProduk.length,
              itemBuilder: (context, index) {
                var p = daftarProduk[index];
                return Card(
                  elevation: 4,
                  shape: Border.all(color: Colors.black12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // KETENTUAN: Jika gambar diketuk, total jual bertambah
                      InkWell(
                        onTap: () {
                          setState(() {
                            totalJual += p.harga;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${p.nama} ditambahkan!'), duration: const Duration(seconds: 1)),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey), // Placeholder Gambar
                        ),
                      ),
                      const SizedBox(height: 15),
                      // KETENTUAN: Jika nama produk diketuk, muncul deskripsi
                      InkWell(
                        onTap: () => _showDeskripsi(p),
                        child: Text(
                          p.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Rp. ${p.harga.toInt()}'),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // KETENTUAN: Jika Total Penjualan diketuk, keluar form pembayaran
          InkWell(
            onTap: () {
              if (totalJual > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentScreen(totalBayar: totalJual)),
                ).then((value) {
                  // Reset total jika pembayaran berhasil
                  if (value == true) {
                    setState(() {
                      totalJual = 0;
                    });
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih produk dulu!')),
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.teal,
              child: Text(
                'Total : Rp. ${totalJual.toInt()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 4. UPDATE USER & PASSWORD SCREEN
// ==========================================
class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _newUserCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();

  void _updateUser() async {
    if (_newUserCtrl.text.isNotEmpty && _newPassCtrl.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _newUserCtrl.text);
      await prefs.setString('password', _newPassCtrl.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diupdate!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('User', style: TextStyle(fontSize: 18)),
                TextField(controller: _newUserCtrl, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                const Text('Password', style: TextStyle(fontSize: 18)),
                TextField(controller: _newPassCtrl, obscureText: true, textAlign: TextAlign.center),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(onPressed: _updateUser, child: const Text('Update')),
                    OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. PAYMENT SCREEN (FORM PEMBAYARAN)
// ==========================================
class PaymentScreen extends StatefulWidget {
  final double totalBayar;
  const PaymentScreen({Key? key, required this.totalBayar}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _bayarCtrl = TextEditingController();
  double kembali = 0;

  void _hitungKembali(String value) {
    double jmlBayar = double.tryParse(value) ?? 0;
    setState(() {
      kembali = jmlBayar - widget.totalBayar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total Transaksi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Rp. ${widget.totalBayar.toInt()}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 30),
                
                const Text('Jumlah Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _bayarCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: _hitungKembali,
                  decoration: const InputDecoration(hintText: '0'),
                ),
                const SizedBox(height: 30),

                const Text('Kembali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  kembali < 0 ? 'Uang Kurang!' : 'Rp. ${kembali.toInt()}', 
                  style: TextStyle(
                    fontSize: 18, 
                    color: kembali < 0 ? Colors.red : Colors.black
                  )
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: kembali >= 0 ? () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembayaran Sukses!')));
                    Navigator.pop(context, true); // Return true untuk reset dashboard
                  } : null,
                  child: const Text('Selesaikan Transaksi'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}