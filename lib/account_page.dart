import 'package:flutter/material.dart';
import 'app_widgets.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'sample_data.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
                    title: 'Ruang pribadi',
                    subtitle: 'Senang bisa saling membantu.',
                  ),
                  const SizedBox(height: 20),

                  // Lime Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSignedIn ? 'IM' : '?',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isSignedIn ? 'Imam Dzulvan Muffid' : 'Halo, teman findr!',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSignedIn
                              ? 'Anggota komunitas findr'
                              : 'Masuk dan bantu barang kembali.',
                          style: const TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (isSignedIn) ...[
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAccountInfo('Email', 'muffid515@gmail.com'),
                          const SizedBox(height: 14),
                          const Divider(color: AppColors.cream, height: 1),
                          const SizedBox(height: 14),
                          _buildAccountInfo('Nomor HP', 'Belum ditambahkan'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppOutlinedButton(
                      label: 'Keluar dari akun',
                      textColor: AppColors.ink,
                      borderColor: const Color(0xFFD6DDD2),
                      onPressed: () async {
                        final confirmed = await showAppConfirmDialog(
                          context: context,
                          title: 'Keluar dari akun?',
                          content: 'Kamu tetap bisa menjelajahi barang setelah keluar.',
                        );
                        if (confirmed == true) {
                          isSignedInNotifier.value = false;
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          }
                        }
                      },
                    ),
                  ] else ...[
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
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Belum punya akun? Daftar',
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'findr  /  Temukan. Laporkan. Kembalikan.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(String label, String value) {
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
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
