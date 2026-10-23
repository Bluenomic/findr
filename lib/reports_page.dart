import 'package:flutter/material.dart';
import 'app_widgets.dart';
import 'create_report_page.dart';
import 'detail_page.dart';
import 'incoming_claims_page.dart';
import 'login_page.dart';
import 'sample_data.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
          child: ValueListenableBuilder<bool>(
            valueListenable: isSignedInNotifier,
            builder: (context, isSignedIn, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppHeading(
                    title: 'Laporan saya',
                    subtitle: 'Satu laporan bisa membuka jalan pulang.',
                  ),
                  const SizedBox(height: 20),

                  if (!isSignedIn) ...[
                    AppPanel(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 38,
                            color: AppColors.green,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Masuk untuk melihat laporan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kelola barang yang kamu laporkan di sini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppPrimaryButton(
                      label: 'Masuk',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    AppPrimaryButton(
                      label: '+  Buat laporan baru',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CreateReportPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: AppBadge(
                        text: '1 LAPORAN AKTIF',
                        backgroundColor: AppColors.lime,
                        textColor: AppColors.green,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ItemRowCard(
                      item: sampleItems[0],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailPage(
                              item: sampleItems[0],
                              isOwn: true,
                              origin: 'reports',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ada 2 klaim untuk laporanmu',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Periksa bukti kepemilikan sebelum menyetujui.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
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
                                    builder: (_) => IncomingClaimsPage(
                                      item: sampleItems[0],
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Periksa klaim →',
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
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
