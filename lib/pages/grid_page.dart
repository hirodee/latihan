//grid_page.dart
import 'package:flutter/material.dart';

class GridDemoPage extends StatefulWidget {
  const GridDemoPage({super.key});

  @override
  State<GridDemoPage> createState() => _GridDemoPageState();
}

class _GridDemoPageState extends State<GridDemoPage> with SingleTickerProviderStateMixin {
  // ==========================================
  // STATE 1: THEME MANAGEMENT
  // ==========================================
  int _currentThemeIndex = 0;
  
  final List<ThemeData> _themes = [
    ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
      ),
    ),
    ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.deepPurple.shade50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      ),
    ),
    ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.orange,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.black),
      ),
    ),
  ];

  // ==========================================
  // STATE 2: ANIMASI (IMPLICIT & EXPLICIT)
  // ==========================================
  // State untuk Implicit Animation
  bool _isImplicitAnimated = false; // Untuk AnimatedContainer
  bool _isOpacityVisible = true;    // Untuk AnimatedOpacity
  bool _isCrossFadeFirst = true;    // Untuk AnimatedCrossFade

  // Controller & Animasi untuk Explicit Animation
  late AnimationController _explicitAnimController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi Explicit Animation (Durasi 2 detik, berulang bolak-balik)
    _explicitAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 1. Animasi ukuran (membesar-mengecil)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _explicitAnimController, curve: Curves.easeInOut),
    );
    
    // 2. Animasi rotasi (bergetar/berputar kecil)
    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _explicitAnimController, curve: Curves.easeInOut),
    );

    // 3. Animasi Geser (Slide Kiri ke Kanan)
    _slideAnimation = Tween<Offset>(begin: const Offset(-1.2, 0), end: const Offset(1.2, 0)).animate(
      CurvedAnimation(parent: _explicitAnimController, curve: Curves.easeInOut),
    );

    // 4. Animasi Transisi Warna Explicit
    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.blue).animate(
      CurvedAnimation(parent: _explicitAnimController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _explicitAnimController.dispose();
    super.dispose();
  }

  // ==========================================
  // FUNGSI 3: DIALOGS
  // ==========================================
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AlertDialog'),
        content: const Text('Ini adalah dialog standar untuk konfirmasi. Lanjutkan proses?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proses dilanjutkan!')),
              );
            },
            child: const Text('Ya, Lanjut'),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('SimpleDialog (Pilih Opsi)'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opsi 1 dipilih')));
            },
            child: const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text('Opsi 1: Laporan Bulanan')),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opsi 2 dipilih')));
            },
            child: const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text('Opsi 2: Laporan Tahunan')),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded, size: 60, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 20),
              const Text(
                'Custom Dialog',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Dialog ini dibuat secara bebas tanpa batasan bawaan Material. Sangat cocok untuk desain UI khusus, ilustrasi, atau form kompleks.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Keren, Tutup!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Elektronik', 'icon': Icons.tv, 'color': Colors.blue},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
      {'name': 'Makanan', 'icon': Icons.fastfood, 'color': Colors.orange},
      {'name': 'Olahraga', 'icon': Icons.fitness_center, 'color': Colors.green},
      {'name': 'Otomotif', 'icon': Icons.directions_car, 'color': Colors.purple},
      {'name': 'Buku', 'icon': Icons.book, 'color': Colors.brown},
    ];

    final List<Map<String, String>> products = [
      {'name': 'Kamera DSLR', 'image': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500', 'price': 'Rp 5.000.000'},
      {'name': 'Headphone Wireless', 'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'price': 'Rp 1.200.000'},
      {'name': 'Jam Tangan Digital', 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500', 'price': 'Rp 850.000'},
      {'name': 'Sepatu Sport', 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500', 'price': 'Rp 1.500.000'},
    ];

    return Theme(
      data: _themes[_currentThemeIndex],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced UI & GridView'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'MATERI ADVANCED UI/UX',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: _themes[_currentThemeIndex].primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 1. THEME MANAGEMENT ---
              const Text('1. Theme Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Ubah gaya keseluruhan halaman hanya dengan satu state.'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildThemeButton('Teal (Light)', 0, Colors.teal),
                  _buildThemeButton('Purple', 1, Colors.deepPurple),
                  _buildThemeButton('Dark Mode', 2, Colors.orange),
                ],
              ),
              const SizedBox(height: 30),

              // --- 2. DIALOG ---
              const Text('2. Jenis Dialog Interaktif', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Menghentikan alur aplikasi untuk meminta respon user.'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: _showAlertDialog,
                    icon: const Icon(Icons.warning_amber),
                    label: const Text('AlertDialog'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showSimpleDialog,
                    icon: const Icon(Icons.list),
                    label: const Text('SimpleDialog'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showCustomDialog,
                    icon: const Icon(Icons.dashboard_customize),
                    label: const Text('Custom Dialog'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- 3. ANIMASI ---
              const Text('3. Animasi di Flutter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              // ==========================================
              // A. IMPLICIT ANIMATION (Lebih Banyak Contoh)
              // ==========================================
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('A. Implicit Animation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),

                    // Contoh 1: AnimatedContainer
                    const Text('1. AnimatedContainer (Ubah Bentuk/Warna):'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isImplicitAnimated = !_isImplicitAnimated),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        height: _isImplicitAnimated ? 100 : 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _isImplicitAnimated ? _themes[_currentThemeIndex].primaryColor : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(_isImplicitAnimated ? 30 : 8),
                          boxShadow: _isImplicitAnimated 
                            ? [BoxShadow(color: _themes[_currentThemeIndex].primaryColor.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))]
                            : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _isImplicitAnimated ? 'Animasi Bekerja Secara Otomatis!' : 'Ketuk Kotak Ini',
                          style: TextStyle(color: _isImplicitAnimated ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Divider(height: 30),

                    // Contoh 2: AnimatedOpacity
                    const Text('2. AnimatedOpacity (Fade In / Fade Out):'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() => _isOpacityVisible = !_isOpacityVisible),
                          child: Text(_isOpacityVisible ? 'Sembunyikan Ikon' : 'Munculkan Ikon'),
                        ),
                        AnimatedOpacity(
                          opacity: _isOpacityVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: Icon(Icons.favorite, color: Colors.red, size: 50),
                        ),
                      ],
                    ),
                    const Divider(height: 30),

                    // Contoh 3: AnimatedCrossFade
                    const Text('3. AnimatedCrossFade (Perpindahan antar 2 Widget):'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isCrossFadeFirst = !_isCrossFadeFirst),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.blueGrey.shade50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ketuk area ini untuk ubah ikon ->', style: TextStyle(color: Colors.black87)),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 600),
                              firstChild: const Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
                              secondChild: const Icon(Icons.nightlight_round, color: Colors.blueGrey, size: 40),
                              crossFadeState: _isCrossFadeFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // B. EXPLICIT ANIMATION (Lebih Banyak Contoh)
              // ==========================================
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('B. Explicit Animation (Looping)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text('Dikontrol penuh oleh AnimationController.', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 15),

                    // Contoh 1: Kombinasi Scale, Rotate & Color
                    const Text('1. Rotate, Scale & ColorTween:'),
                    const SizedBox(height: 10),
                    Center(
                      child: AnimatedBuilder(
                        animation: _explicitAnimController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Transform.rotate(
                              angle: _rotateAnimation.value,
                              child: Icon(
                                Icons.diamond,
                                size: 60,
                                color: _colorAnimation.value, // Warna berubah dari merah ke biru
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Contoh 2: SlideTransition
                    const Text('2. SlideTransition (Perpindahan Koordinat):'),
                    const SizedBox(height: 10),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: SlideTransition(
                          position: _slideAnimation, // Menggunakan Tween<Offset>
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _themes[_currentThemeIndex].primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.directions_car, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const Divider(thickness: 3),
              const SizedBox(height: 20),

              // ==========================================
              // BAGIAN BAWAH: MATERI GRIDVIEW (ORIGINAL)
              // ==========================================
              Center(
                child: Text(
                  'MATERI GRIDVIEW',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: _themes[_currentThemeIndex].primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                '1. GridView.count (Statis)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('Menentukan jumlah kolom tetap secara manual.'),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildMenuBox('Home', Icons.home, Colors.teal),
                  _buildMenuBox('Chat', Icons.chat, Colors.blue),
                  _buildMenuBox('Map', Icons.map, Colors.red),
                  _buildMenuBox('Notif', Icons.notifications, Colors.amber),
                  _buildMenuBox('Cari', Icons.search, Colors.indigo),
                  _buildMenuBox('Set', Icons.settings, Colors.grey),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                '2. GridView.builder (Dinamis)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('Efisien untuk data dari List atau API.'),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return Card(
                    color: item['color'].withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: item['color']),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], color: item['color']),
                          const SizedBox(width: 8),
                          Text(
                            item['name'],
                            style: TextStyle(
                              color: item['color'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                '3. GridView Visual (Katalog Card)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('Tampilan estetik dengan gambar dan bayangan.'),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return _buildImageCard(
                    products[index]['name']!,
                    products[index]['image']!,
                    products[index]['price']!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton(String label, int index, Color color) {
    bool isSelected = _currentThemeIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentThemeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBox(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String title, String imageUrl, String price) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
