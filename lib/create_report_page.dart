import 'package:flutter/material.dart';
import 'app_widgets.dart';
import 'sample_data.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  String _type = 'Hilang'; // 'Hilang' or 'Ditemukan'
  String _category = 'Dompet'; // 'Dompet', 'Elektronik', 'Kunci', 'Lainnya'

  final _titleController = TextEditingController();
  final _cityController = TextEditingController(text: 'Balikpapan');
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String hint, {bool alignTop = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.muted),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
      alignLabelWithHint: alignTop,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD6DDD2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD6DDD2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.green, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'Buat laporan',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeading(
                title: 'Ceritakan barangnya',
                subtitle: 'Detail yang jelas membantu orang mengenalinya.',
              ),
              const SizedBox(height: 18),

              // Type Selector Chips ('Barang Hilang', 'Barang Ditemukan')
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Hilang', 'Ditemukan'].map((type) {
                    final isSelected = _type == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text('Barang $type'),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.ink,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                        selectedColor: AppColors.green,
                        backgroundColor: Colors.white,
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: isSelected ? AppColors.green : const Color(0xFFD6DDD2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _type = type;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Upload Photo Placeholder
              Material(
                color: const Color(0xFFE8EEE3),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showAppNoticeDialog(
                      context: context,
                      message:
                          'Pilihan kamera dan galeri akan tersedia pada tahap berikutnya.',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    alignment: Alignment.center,
                    child: const Column(
                      children: [
                        Text(
                          '+',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: AppColors.green,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tambahkan foto barang',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Gunakan foto yang terang dan jelas',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Field
              TextField(
                controller: _titleController,
                decoration: _inputDecoration('Nama barang', 'Contoh: Dompet kulit cokelat'),
              ),
              const SizedBox(height: 16),

              // Category Section
              const Text(
                'Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Dompet', 'Elektronik', 'Kunci', 'Lainnya'].map((cat) {
                  final isSelected = _category == cat;
                  return FilterChip(
                    selected: isSelected,
                    label: Text(cat),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.ink,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    selectedColor: AppColors.green,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.green : const Color(0xFFD6DDD2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (val) {
                      setState(() {
                        _category = cat;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // City Field
              TextField(
                controller: _cityController,
                decoration: _inputDecoration('Kota', 'Contoh: Balikpapan'),
              ),
              const SizedBox(height: 16),

              // Location Field
              TextField(
                controller: _locationController,
                decoration: _inputDecoration(
                  _type == 'Hilang' ? 'Lokasi terakhir terlihat' : 'Lokasi ditemukan',
                  'Contoh: Jalan Jenderal Sudirman',
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 6,
                decoration: _inputDecoration(
                  'Deskripsi',
                  'Warna, merek, dan ciri barang…',
                  alignTop: true,
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              AppPrimaryButton(
                label: 'Kirim laporan',
                onPressed: () async {
                  await showAppNoticeDialog(
                    context: context,
                    message:
                        'Tampilan laporan selesai dicoba. Pengiriman dan penyimpanan akan tersedia pada tahap berikutnya.',
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
