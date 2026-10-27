import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(const UtsApp());
}

class UtsApp extends StatelessWidget {
  const UtsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMKM Rupa Rempah',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.spa, size: 100, color: Colors.teal),
            SizedBox(height: 20),
            Text("Selamat Datang", style: TextStyle(fontSize: 24)),
            Text("di", style: TextStyle(fontSize: 18)),
            Text(
              "UMKM Rupa Rempah",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. LOGIN USER (Shared Preferences)
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    String savedUser = prefs.getString('username') ?? 'admin';
    String savedPass = prefs.getString('password') ?? 'admin';

    if (_usernameCtrl.text == savedUser && _passwordCtrl.text == savedPass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau Password salah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _login, child: const Text('Submit')),
                ElevatedButton(
                  onPressed: () {
                    _usernameCtrl.clear();
                    _passwordCtrl.clear();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. DASHBOARD PRODUK
// ==========================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalJual = 0;

  final List<Map<String, dynamic>> products = [
    {
      'nama': 'COSRX Set',
      'harga': 150000,
      'desc': 'Satu set perawatan wajah COSRX Low pH Good Morning.',
      'gambar': 'assets/Skincare1.jpg',
      'qty': 0,
    },
    {
      'nama': 'Lacoco Serum',
      'harga': 250000,
      'desc': 'Lacoco En Nature Bust Fit Concentrate Serum.',
      'gambar': 'assets/Skincare2.jpg',
      'qty': 0,
    },
    {
      'nama': 'Tonskin Set',
      'harga': 180000,
      'desc': 'Paket lengkap Tonskin Brightening untuk kulit cerah.',
      'gambar': 'assets/Skincare3.jpg',
      'qty': 0,
    },
    {
      'nama': 'Y.O.U Hydra',
      'harga': 200000,
      'desc': 'Rangkaian skincare Y.O.U HydraRescue Series.',
      'gambar': 'assets/Skincare4.jpg',
      'qty': 0,
    },
    {
      'nama': 'Aqua+ Series',
      'harga': 125000,
      'desc': 'Aqua+ Series HYA 8D PLUS Revitalizing Skindrops.',
      'gambar': 'assets/Skincare5.jpg',
      'qty': 0,
    },
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka aksi ini')),
      );
    }
  }

  void _resetKeranjang() {
    setState(() {
      totalJual = 0;
      for (var prod in products) {
        prod['qty'] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'call') _launchURL('tel:081234567890');
              if (value == 'sms') _launchURL('sms:081234567890');
              if (value == 'maps')
                _launchURL(
                    'https://www.google.com/maps/search/?api=1&query=udinus');
              if (value == 'update') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateUserScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'call',
                  child: Text('Call Center Penjual'),
                ),
                const PopupMenuItem(
                  value: 'sms',
                  child: Text('SMS ke Penjual'),
                ),
                const PopupMenuItem(
                  value: 'maps',
                  child: Text('Maps Lokasi Agen'),
                ),
                const PopupMenuItem(
                  value: 'update',
                  child: Text('Update User & Password'),
                ),
              ];
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final prod = products[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        prod['qty']++;
                        totalJual += prod['harga'];
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${prod['nama']} ditambahkan!'),
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        prod['gambar'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(prod['nama']),
                              content: Text(prod['desc']),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          prod['nama'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rp ${prod['harga']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.teal[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              if (prod['qty'] > 0) {
                                setState(() {
                                  prod['qty']--;
                                  totalJual -= prod['harga'];
                                });
                              }
                            },
                          ),
                          Text(
                            '${prod['qty']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                prod['qty']++;
                                totalJual += prod['harga'];
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (totalJual > 0) {
            // Ambil daftar barang yang dibeli (qty > 0)
            List<Map<String, dynamic>> keranjang =
                products.where((p) => p['qty'] > 0).toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PaymentScreen(totalBayar: totalJual, keranjang: keranjang),
              ),
            ).then((value) {
              if (value == true) {
                _resetKeranjang();
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Keranjang masih kosong!')),
            );
          }
        },
        child: Container(
          height: 60,
          color: Colors.teal,
          alignment: Alignment.center,
          child: Text(
            'Total : Rp $totalJual',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. FORM PEMBAYARAN
// ==========================================
class PaymentScreen extends StatefulWidget {
  final double totalBayar;
  final List<Map<String, dynamic>> keranjang;

  const PaymentScreen({
    super.key,
    required this.totalBayar,
    required this.keranjang,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _bayarCtrl = TextEditingController();
  double kembalian = 0;

  void hitungKembalian() {
    double jmlBayar = double.tryParse(_bayarCtrl.text) ?? 0;
    setState(() {
      kembalian = jmlBayar - widget.totalBayar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Daftar Belanjaan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // ListView untuk menampilkan daftar produk
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.keranjang.length,
              itemBuilder: (context, index) {
                final item = widget.keranjang[index];
                final subtotal = item['harga'] * item['qty'];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item['nama'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Rp ${item['harga']} x ${item['qty']}'),
                  trailing: Text(
                    'Rp $subtotal',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total Transaksi:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${widget.totalBayar}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _bayarCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Pembayaran (Rp)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: hitungKembalian,
                  child: const Text('Hitung Kembalian'),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Kembali:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp $kembalian',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kembalian < 0 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Selesai', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. UPDATE USER & PASSWORD
// ==========================================
class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  Future<void> _updateData() async {
    if (_userCtrl.text.isNotEmpty && _passCtrl.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _userCtrl.text);
      await prefs.setString('password', _passCtrl.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User & Password berhasil diupdate!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User & Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateData,
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
