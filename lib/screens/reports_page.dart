import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import '../widgets/app_widgets.dart';
import 'create_report_page.dart';
import 'detail_page.dart';
import 'login_page.dart';

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

                    if (sampleItems.isEmpty) ...[
                      const EmptyState(
                        title: 'Belum ada laporan',
                        subtitle:
                            'Laporan barang yang kamu buat akan muncul di sini. Ketuk "+ Buat laporan baru" untuk mulai melapor.',
                      ),
                    ] else ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppBadge(
                          text: '${sampleItems.length} LAPORAN AKTIF',
                          backgroundColor: AppColors.lime,
                          textColor: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...sampleItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ItemRowCard(
                            item: item,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(
                                    item: item,
                                    isOwn: true,
                                    origin: 'reports',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
