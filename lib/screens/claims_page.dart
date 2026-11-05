import 'package:flutter/material.dart';
import '../models/sample_data.dart';
import '../widgets/app_widgets.dart';
import 'detail_page.dart';
import 'login_page.dart';

class ClaimsPage extends StatelessWidget {
  const ClaimsPage({super.key});

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
                    title: 'Klaim saya',
                    subtitle: 'Pantau perjalanan barangmu kembali.',
                  ),
                  const SizedBox(height: 20),

                  if (!isSignedIn) ...[
                    AppPanel(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 38,
                            color: AppColors.green,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Klaimmu ada di sini',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Masuk untuk melihat klaim kepemilikan.',
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
                    if (sampleItems.isEmpty) ...[
                      const EmptyState(
                        title: 'Belum ada klaim',
                        subtitle:
                            'Klaim barang yang kamu ajukan akan muncul dan dipantau di sini.',
                      ),
                    ] else ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: AppBadge(
                          text: 'MENUNGGU PERSETUJUAN',
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
                                isOwn: false,
                                origin: 'claims',
                              ),
                            ),
                          );
                        },
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
