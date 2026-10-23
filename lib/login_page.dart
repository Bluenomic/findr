import 'package:flutter/material.dart';

import 'main_navigation_page.dart';
import 'register_page.dart';
import 'sample_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _darkGreen = Color(0xFF19382F);
  static const _buttonGreen = Color(0xFF356D50);
  static const _mutedText = Color(0xFF7A817B);
  static const _fieldBorder = Color(0xFF858C87);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF454B47), fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      filled: true,
      fillColor: Colors.transparent,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _fieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _fieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _buttonGreen, width: 2),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    isSignedInNotifier.value = true;
    _showMessage('Berhasil masuk.');

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MainNavigationPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (canGoBack)
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: _buttonGreen,
                          tooltip: 'Kembali',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 42),
                        ),
                      const Text(
                        'Masuk',
                        style: TextStyle(
                          color: _darkGreen,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  const Text(
                    'Selamat datang kembali.',
                    style: TextStyle(
                      color: _darkGreen,
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Masuk untuk melapor dan mengajukan klaim.',
                    style: TextStyle(
                      color: _mutedText,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: _fieldDecoration('Email'),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) return 'Email wajib diisi.';
                              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                  .hasMatch(email)) {
                                return 'Masukkan alamat email yang valid.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 21),
                          TextFormField(
                            controller: _passwordController,
                            decoration: _fieldDecoration(
                              'Kata sandi',
                              suffix: TextButton(
                                onPressed: () => setState(
                                  () => _passwordVisible = !_passwordVisible,
                                ),
                                child: Text(
                                  _passwordVisible ? 'Sembunyikan' : 'Lihat',
                                  style: const TextStyle(
                                    color: _buttonGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => _submit(),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Kata sandi wajib diisi.'
                                : null,
                          ),
                          const SizedBox(height: 17),
                          SizedBox(
                            height: 53,
                            child: FilledButton(
                              onPressed: _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: _buttonGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(
                          color: _buttonGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        isSignedInNotifier.value = false;
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MainNavigationPage(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Jelajahi sebagai Tamu',
                        style: TextStyle(
                          color: _mutedText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
