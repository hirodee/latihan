import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart'; // IMPORT TTS BARU

import '../translations.dart';
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
              title: Text(AppTranslations.tr('menu_translate')),
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(AppTranslations.tr('menu_home')),
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(AppTranslations.tr('menu_history')),
              onTap: () {
                setState(() => currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppTranslations.tr('menu_profile')),
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppTranslations.tr('menu_logout')),
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
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.translate), label: AppTranslations.tr('menu_translate')),
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppTranslations.tr('menu_home')),
          BottomNavigationBarItem(icon: const Icon(Icons.history), label: AppTranslations.tr('menu_history')),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: AppTranslations.tr('menu_profile')),
        ],
      ),
    );
  }
}

// ===================================================================
// KODE ASLI - TIDAK ADA YANG DIHAPUS (LayoutDemoPage)
// ===================================================================
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

// ===================================================================
// KODE HALAMAN TRANSLATOR DENGAN TTS & I18N
// ===================================================================
class PdfTranslatorPage extends StatefulWidget {
  const PdfTranslatorPage({super.key});

  @override
  State<PdfTranslatorPage> createState() => _PdfTranslatorPageState();
}

class _PdfTranslatorPageState extends State<PdfTranslatorPage> {
  String _selectedSourceLanguage = 'en'; 
  
  final Map<String, String> _sourceLanguages = {
    'en': 'Inggris',
    'fr': 'Prancis',
    'de': 'Jerman',
  };

  String _pdfTranslatedText = '';
  bool _isPdfLoading = false;
  
  final TextEditingController _manualTextController = TextEditingController();
  String _manualTranslatedText = '';
  bool _isManualLoading = false;

  final GoogleTranslator _translator = GoogleTranslator();
  
  // Instance TTS Baru
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void dispose() {
    _manualTextController.dispose();
    _flutterTts.stop(); // Hentikan TTS ketika widget dihapus
    super.dispose();
  }

  // Fungsi memanggil Text-to-Speech
  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.setLanguage("id-ID"); // Target bahasa tetap di set ID
      await _flutterTts.speak(text);
    }
  }

  Future<void> _pickAndTranslatePdf() async {
    setState(() {
      _isPdfLoading = true;
      _pdfTranslatedText = AppTranslations.tr('pdf_loading');
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
            _pdfTranslatedText = AppTranslations.tr('pdf_fail');
            _isPdfLoading = false;
          });
          return;
        }

        final PdfDocument document = PdfDocument(inputBytes: bytes);
        final String extractedText = PdfTextExtractor(document).extractText();
        document.dispose();

        if (extractedText.trim().isEmpty) {
          setState(() {
            _pdfTranslatedText = AppTranslations.tr('pdf_no_text');
            _isPdfLoading = false;
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
          from: _selectedSourceLanguage,
          to: 'id'
        );

        setState(() {
          _pdfTranslatedText = translation.text;
        });
      } else {
        setState(() {
          _pdfTranslatedText = '';
        });
      }
    } catch (e) {
      setState(() {
        _pdfTranslatedText = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        _isPdfLoading = false;
      });
    }
  }

  Future<void> _translateManualText() async {
    String textToTranslate = _manualTextController.text.trim();
    
    if (textToTranslate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppTranslations.tr('txt_empty')))
      );
      return;
    }

    setState(() {
      _isManualLoading = true;
      _manualTranslatedText = AppTranslations.tr('manual_loading');
    });

    try {
      if (textToTranslate.length > 4000) {
        textToTranslate = textToTranslate.substring(0, 4000);
      }

      var translation = await _translator.translate(
        textToTranslate, 
        from: _selectedSourceLanguage, 
        to: 'id' 
      );

      setState(() {
        _manualTranslatedText = translation.text;
      });
    } catch (e) {
      setState(() {
        _manualTranslatedText = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        _isManualLoading = false;
      });
    }
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTranslations.tr('copy_success')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.tr('title_translator')),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTranslations.tr('trans_from'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSourceLanguage,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                      style: const TextStyle(
                        fontSize: 16, 
                        color: Colors.blue, 
                        fontWeight: FontWeight.bold
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSourceLanguage = newValue;
                          });
                        }
                      },
                      items: _sourceLanguages.entries
                          .map<DropdownMenuItem<String>>((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              AppTranslations.tr('trans_doc'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isPdfLoading ? null : _pickAndTranslatePdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(AppTranslations.tr('btn_pick_pdf')), 
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppTranslations.tr('result_id'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                // FITUR TTS PLAY BUTTON
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.blue, size: 24),
                      tooltip: 'Bicara (TTS)',
                      onPressed: _pdfTranslatedText.isNotEmpty && !_isPdfLoading
                          ? () => _speak(_pdfTranslatedText)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blue, size: 20),
                      tooltip: 'Salin Teks PDF',
                      onPressed: _pdfTranslatedText.isNotEmpty && !_isPdfLoading
                          ? () => _copyToClipboard(_pdfTranslatedText)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 200, 
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: _isPdfLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        _pdfTranslatedText.isEmpty
                            ? AppTranslations.tr('res_pdf_empty')
                            : _pdfTranslatedText,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const SizedBox(height: 20),

            Text(
              AppTranslations.tr('trans_manual'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _manualTextController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppTranslations.tr('hint_manual'), 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isManualLoading ? null : _translateManualText,
              icon: const Icon(Icons.g_translate),
              label: Text(AppTranslations.tr('btn_trans_text')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppTranslations.tr('result_id'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                // FITUR TTS PLAY BUTTON MANUAL
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.green, size: 24),
                      tooltip: 'Bicara (TTS)',
                      onPressed: _manualTranslatedText.isNotEmpty && !_isManualLoading
                          ? () => _speak(_manualTranslatedText)
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.green, size: 20),
                      tooltip: 'Salin Teks Manual',
                      onPressed: _manualTranslatedText.isNotEmpty && !_isManualLoading
                          ? () => _copyToClipboard(_manualTranslatedText)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 150,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: _isManualLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        _manualTranslatedText.isEmpty
                            ? AppTranslations.tr('res_manual_empty')
                            : _manualTranslatedText,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}