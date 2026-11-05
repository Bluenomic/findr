import 'package:flutter/material.dart';
import '../config/supabase_config.dart';
import '../models/sample_data.dart';
import '../services/supabase_service.dart';
import '../widgets/app_widgets.dart';
import 'login_page.dart';
import 'main_navigation_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String hint, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.muted),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffix,
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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (SupabaseConfig.isInitialized) {
        await SupabaseService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      }
      isSignedInNotifier.value = true;
      if (mounted) {
        await showAppNoticeDialog(
          context: context,
          message: 'Akun berhasil dibuat. Selamat datang di findr!',
        );
        if (mounted) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const MainNavigationPage(initialIndex: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        await showAppNoticeDialog(
          context: context,
          message: 'Pendaftaran gagal: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          'Daftar akun',
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
                title: 'Jadi bagian dari findr.',
                subtitle: 'Bersama, kita bantu barang menemukan pemiliknya.',
              ),
              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Nama lengkap', 'Nama kamu'),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email', 'nama@email.com'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                        if (!val.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration('Nomor HP', '08…'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _passwordController,
                      decoration: _inputDecoration(
                        'Kata sandi',
                        'Masukkan kata sandi',
                        suffix: TextButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Text(
                            _passwordVisible ? 'Sembunyi' : 'Lihat',
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Kata sandi wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: _inputDecoration(
                        'Konfirmasi kata sandi',
                        'Ulangi kata sandi',
                        suffix: TextButton(
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                          child: Text(
                            _confirmPasswordVisible ? 'Sembunyi' : 'Lihat',
                            style: const TextStyle(
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      obscureText: !_confirmPasswordVisible,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Ulangi kata sandi';
                        if (val != _passwordController.text) {
                          return 'Kata sandi tidak sama';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    AppPrimaryButton(
                      label: _isLoading ? 'Mendaftarkan…' : 'Daftar akun',
                      onPressed: _isLoading ? () {} : _submit,
                    ),
                    const SizedBox(height: 14),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sudah punya akun? Masuk',
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
          ),
        ),
      ),
    );
  }
}
