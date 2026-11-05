import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../config/supabase_config.dart';
import '../models/sample_data.dart';
import '../services/supabase_service.dart';
import '../widgets/app_widgets.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  String _type = 'Hilang'; // 'Hilang' or 'Ditemukan'
  String _category = 'Dompet'; // 'Dompet', 'Elektronik', 'Kunci', 'Lainnya'
  File? _selectedImage;
  bool _isSubmitting = false;

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.green),
              title: const Text('Ambil foto dengan kamera'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.green),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;
    try {
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final city = _cityController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama barang wajib diisi')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? photoUrl;
      if (_selectedImage != null && SupabaseConfig.isInitialized) {
        photoUrl = await SupabaseService.uploadPhoto(_selectedImage!);
      }

      if (SupabaseConfig.isInitialized) {
        await SupabaseService.createItem(
          title: title,
          category: _category,
          city: city.isNotEmpty ? city : 'Balikpapan',
          location: location.isNotEmpty ? location : '-',
          description: description,
          isFound: _type == 'Ditemukan',
          photoUrl: photoUrl,
        );
      }

      sampleItems.insert(
        0,
        Item(
          title: title,
          category: _category,
          city: city.isNotEmpty ? city : 'Balikpapan',
          location: location.isNotEmpty ? location : '-',
          description: description,
          found: _type == 'Ditemukan',
          photo: photoUrl ?? (_selectedImage?.path ?? ''),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dikirim!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showAppNoticeDialog(
          context: context,
          message: 'Gagal mengirim laporan: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  color: const Color(0xFFE8EEE3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _pickImage,
                    child: _selectedImage != null
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                _selectedImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
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
                label: _isSubmitting ? 'Mengirim…' : 'Kirim laporan',
                onPressed: _isSubmitting ? () {} : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
