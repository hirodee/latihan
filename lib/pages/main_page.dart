//main_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:translator/translator.dart';

import 'login_page.dart';
import 'profile_page.dart';
import 'grid_page.dart';

class MainPage extends StatefulWidget {
  final String username;
  const MainPage({super.key, required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const PdfTranslatorPage(), 
      const LayoutDemoPage(),    
      const GridDemoPage(),  
      ProfilePage(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.username),
              accountEmail: const Text('user@app.com'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: const Text('Terjemah PDF'),
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat'),
              onTap: () {
                setState(() => currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Terjemah'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}


class LayoutDemoPage extends StatelessWidget {
  const LayoutDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(20, (index) => "Item Data Ke-${index + 1}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktek ListView Flutter'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. ListView Default (Statis)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Gunakan jika data sedikit dan sudah pasti.'),
            const SizedBox(height: 10),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.blue),
                    title: Text('Informasi Aplikasi'),
                  ),
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.orange),
                    title: Text('Pusat Bantuan'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey),
                    title: Text('Pengaturan Umum'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '2. ListView.builder (Dinamis)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Efisien untuk data banyak (Lazy Loading).'),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(items[index]),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Anda menekan ${items[index]}')),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              '3. ListView.separated (Dengan Divider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Tampilan lebih rapi dengan garis pemisah.'),
            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                itemCount: 5, 
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.red,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('Riwayat Transaksi #00${index + 1}'),
                    trailing: const Text('Sukses', style: TextStyle(color: Colors.green)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfTranslatorPage extends StatefulWidget {
  const PdfTranslatorPage({super.key});

  @override
  State<PdfTranslatorPage> createState() => _PdfTranslatorPageState();
}

class _PdfTranslatorPageState extends State<PdfTranslatorPage> {
  String _translatedText = '';
  bool _isLoading = false;
  final GoogleTranslator _translator = GoogleTranslator();

  Future<void> _pickAndTranslatePdf() async {
    setState(() {
      _isLoading = true;
      _translatedText = 'Membaca dan menerjemahkan PDF...';
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, 
      );

      if (result != null) {
        List<int>? bytes;

        if (kIsWeb) {
          bytes = result.files.single.bytes;
        } else {
          if (result.files.single.path != null) {
            File file = File(result.files.single.path!);
            bytes = await file.readAsBytes();
          }
        }

        if (bytes == null) {
          setState(() {
            _translatedText = 'Gagal memuat file PDF.';
            _isLoading = false;
          });
          return;
        }

        final PdfDocument document = PdfDocument(inputBytes: bytes);
        final String extractedText = PdfTextExtractor(document).extractText();
        document.dispose();

        if (extractedText.trim().isEmpty) {
          setState(() {
            _translatedText = 'Tidak ada teks yang dapat diekstrak. Mungkin PDF ini berisi gambar hasil scan.';
            _isLoading = false;
          });
          return;
        }

        String cleanText = extractedText.replaceAll('\r\n', '\n');
        cleanText = cleanText.replaceAll(RegExp(r'(?<!\n)\n(?!\n)'), ' ');
        cleanText = cleanText.replaceAll(RegExp(r'[ \t]+'), ' ').trim();

        String textToTranslate = cleanText;
        if (textToTranslate.length > 4000) {
          textToTranslate = textToTranslate.substring(0, 4000);
        }

        var translation = await _translator.translate(
          textToTranslate, 
          from: 'en', 
          to: 'id'
        );

        setState(() {
          _translatedText = translation.text;
        });
      } else {
        setState(() {
          _translatedText = '';
        });
      }
    } catch (e) {
      setState(() {
        _translatedText = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerjemah PDF'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickAndTranslatePdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Pilih File PDF Bahasa Inggris'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Hasil Terjemahan ke Indonesia:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.blue),
                  tooltip: 'Salin Teks',
                  onPressed: _translatedText.isNotEmpty && !_isLoading
                      ? () async {
                          await Clipboard.setData(
                            ClipboardData(text: _translatedText)
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Teks berhasil disalin!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
            
            const SizedBox(height: 5),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(
                          _translatedText.isEmpty
                              ? 'Teks hasil terjemahan akan muncul di sini.'
                              : _translatedText,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}