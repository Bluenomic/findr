import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import '../widgets/app_widgets.dart';
import 'claim_page.dart';
import 'incoming_claims_page.dart';
import 'login_page.dart';

class DetailPage extends StatelessWidget {
  final Item item;
  final bool isOwn;
  final String origin;

  const DetailPage({
    super.key,
    required this.item,
    this.isOwn = false,
    this.origin = 'home',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'Detail barang',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Item Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 320,
                  width: double.infinity,
                  color: AppColors.photoBg,
                  child: ItemPhotoWidget(
                    photo: item.photo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Status Badge
              AppBadge(
                text: item.found ? 'BARANG DITEMUKAN' : 'BARANG HILANG',
                backgroundColor: item.found ? AppColors.lime : const Color(0xFFFFE8D6),
                textColor: item.found ? AppColors.green : AppColors.lostBadge,
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),

              // Location and Date
              Text(
                '${item.location}, ${item.city}  •  Hari ini',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),

              // Details Panel
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Kategori', item.category),
                    const SizedBox(height: 12),
                    _buildInfoRow('Status laporan', 'Aktif'),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.cream, height: 1),
                    const SizedBox(height: 14),
                    const Text(
                      'Tentang barang',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.description} ${item.found ? "Ditemukan di ${item.location.toLowerCase()}. Barang sudah disimpan dengan aman. Jelaskan ciri khusus barang saat mengajukan klaim." : "Terakhir terlihat di ${item.location.toLowerCase()}. Jika menemukan barang ini, mohon bantu menghubungi pelapor."}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Reporter Panel
              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOwn ? 'Dilaporkan oleh kamu' : 'Dilaporkan oleh Nadia',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Anggota komunitas findr',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Actions
              if (isOwn) ...[
                AppPrimaryButton(
                  label: 'Lihat klaim masuk · 2',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => IncomingClaimsPage(item: item),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                AppOutlinedButton(
                  label: 'Batalkan laporan',
                  textColor: AppColors.danger,
                  borderColor: const Color(0xFFF1D4D0),
                  onPressed: () async {
                    final confirmed = await showAppConfirmDialog(
                      context: context,
                      title: 'Batalkan laporan?',
                      content:
                          'Laporan yang dibatalkan tidak lagi menerima klaim baru.',
                    );
                    if (confirmed == true && context.mounted) {
                      await showAppNoticeDialog(
                        context: context,
                        message:
                            'Konfirmasi berhasil dicoba. Data contoh belum berubah.',
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ] else if (item.found) ...[
                ValueListenableBuilder<bool>(
                  valueListenable: isSignedInNotifier,
                  builder: (context, isSignedIn, _) {
                    return AppPrimaryButton(
                      label: 'Ini barang saya',
                      onPressed: () {
                        if (isSignedIn) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ClaimPage(item: item),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ] else ...[
                ValueListenableBuilder<bool>(
                  valueListenable: isSignedInNotifier,
                  builder: (context, isSignedIn, _) {
                    if (isSignedIn) {
                      return AppPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Menemukan barang ini?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Bantu barang ini kembali ke pemiliknya dengan menghubungi pelapor.',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AppPrimaryButton(
                              label: 'Hubungi pelapor · Nadia',
                              onPressed: () {
                                showAppNoticeDialog(
                                  context: context,
                                  title: 'Kontak Pelapor',
                                  message:
                                      'Silakan hubungi pelapor melalui WhatsApp/Telepon: 0812-3456-7890 (Nadia).',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Informasi kontak tersedia setelah masuk.',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppPrimaryButton(
                              label: 'Masuk untuk melihat kontak',
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
