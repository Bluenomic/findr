import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import '../widgets/app_widgets.dart';

class IncomingClaimsPage extends StatelessWidget {
  final Item item;

  const IncomingClaimsPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    const claimants = ['Alya Putri', 'Raka Pratama'];

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'Klaim masuk',
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
                title: 'Temukan pemiliknya',
                subtitle: '2 orang mengajukan klaim untuk barang ini.',
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),

              ...claimants.map(
                (name) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: AppPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppBadge(
                          text: 'MENUNGGU',
                          backgroundColor: AppColors.lime,
                          textColor: AppColors.green,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Mengirim bukti kepemilikan • Hari ini',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ReviewClaimPage(
                                    claimant: name,
                                    item: item,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Lihat bukti →',
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewClaimPage extends StatelessWidget {
  final String claimant;
  final Item item;

  const ReviewClaimPage({
    super.key,
    required this.claimant,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final proof = claimant == 'Alya Putri'
        ? 'Ada kartu perpustakaan di bagian dalam dan jahitan kecil di sudut kanan.'
        : 'Dompet berisi kartu anggota gym. Ada inisial RP pada bagian dalam.';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'Detail klaim',
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
                title: 'Periksa dengan teliti',
                subtitle: 'Cocokkan bukti dengan barang yang kamu simpan.',
              ),
              const SizedBox(height: 18),

              AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claimant,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const AppBadge(
                      text: 'MENUNGGU PERSETUJUAN',
                      backgroundColor: AppColors.lime,
                      textColor: AppColors.green,
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.cream, height: 1),
                    const SizedBox(height: 14),
                    const Text(
                      'Bukti kepemilikan',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      proof,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppPrimaryButton(
                label: 'Setujui klaim',
                onPressed: () async {
                  final confirmed = await showAppConfirmDialog(
                    context: context,
                    title: 'Setujui klaim ini?',
                    content: 'Pastikan bukti pengaju cocok dengan barang yang ditemukan.',
                  );
                  if (confirmed == true && context.mounted) {
                    await showAppNoticeDialog(
                      context: context,
                      message: 'Konfirmasi berhasil dicoba. Data contoh belum berubah.',
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
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
