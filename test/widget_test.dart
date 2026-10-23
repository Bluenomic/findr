import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:findr/claim_page.dart';
import 'package:findr/create_report_page.dart';
import 'package:findr/detail_page.dart';
import 'package:findr/incoming_claims_page.dart';
import 'package:findr/login_page.dart';
import 'package:findr/main.dart';
import 'package:findr/main_navigation_page.dart';
import 'package:findr/register_page.dart';
import 'package:findr/sample_data.dart';

void main() {
  setUp(() {
    isSignedInNotifier.value = true;
  });

  testWidgets('App launches with LoginPage as starting point and logs into MainNavigationPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify LoginPage is shown first
    expect(find.text('Selamat datang kembali.'), findsOneWidget);
    expect(find.text('Masuk untuk melapor dan mengajukan klaim.'), findsOneWidget);
    expect(find.text('Jelajahi sebagai Tamu'), findsOneWidget);

    // Enter valid credentials and tap Masuk
    await tester.enterText(find.byType(TextFormField).first, 'muffid515@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    // Verify Beranda top bar elements
    expect(find.text('findr'), findsOneWidget);
    expect(find.text('RUANG TEMU'), findsOneWidget);

    // Verify Bottom Navigation items
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Laporan'), findsOneWidget);
    expect(find.text('Klaim'), findsOneWidget);
    expect(find.text('Akun'), findsOneWidget);

    // Switch to Laporan tab
    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Laporan saya'), findsOneWidget);
    expect(find.text('+  Buat laporan baru'), findsOneWidget);

    // Switch to Klaim tab
    await tester.tap(find.text('Klaim'));
    await tester.pumpAndSettle();
    expect(find.text('Klaim saya'), findsOneWidget);
    expect(find.text('MENUNGGU PERSETUJUAN'), findsOneWidget);

    // Switch to Akun tab
    await tester.tap(find.text('Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Ruang pribadi'), findsOneWidget);
    expect(find.text('Imam Dzulvan Muffid'), findsOneWidget);
  });

  testWidgets('LoginPage can explore as guest without logging in', (
    WidgetTester tester,
  ) async {
    isSignedInNotifier.value = false;
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Jelajahi sebagai Tamu'), findsOneWidget);
    await tester.tap(find.text('Jelajahi sebagai Tamu'));
    await tester.pumpAndSettle();

    expect(find.text('findr'), findsOneWidget);
    expect(isSignedInNotifier.value, isFalse);
  });

  testWidgets('Home page filter chips and search filter feed items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialScreen: MainNavigationPage()));
    await tester.pumpAndSettle();

    // Initially "Semua" is selected, 4 items present in Balikpapan
    expect(find.text('Dompet kulit cokelat'), findsOneWidget);
    expect(find.text('Headphone wireless'), findsOneWidget);

    // Tap "Ditemukan" chip
    await tester.tap(find.text('Ditemukan').first);
    await tester.pumpAndSettle();
    expect(find.text('Dompet kulit cokelat'), findsOneWidget);
    expect(find.text('Headphone wireless'), findsNothing);

    // Tap "Hilang" chip
    await tester.tap(find.text('Hilang').first);
    await tester.pumpAndSettle();
    expect(find.text('Headphone wireless'), findsOneWidget);
    expect(find.text('Dompet kulit cokelat'), findsNothing);

    // Reset to "Semua"
    await tester.tap(find.text('Semua').first);
    await tester.pumpAndSettle();

    // Search query that matches only 'Kunci'
    await tester.enterText(find.byType(TextField).first, 'Kunci');
    await tester.pumpAndSettle();
    expect(find.text('Kunci motor Honda'), findsOneWidget);
    expect(find.text('Dompet kulit cokelat'), findsNothing);

    // Search query with no match shows EmptyState
    await tester.enterText(find.byType(TextField).first, 'BarangAntariksa123');
    await tester.pumpAndSettle();
    expect(find.text('Belum ada yang cocok'), findsOneWidget);
  });

  testWidgets('DetailPage opens from feed card and navigates to ClaimPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialScreen: MainNavigationPage()));
    await tester.pumpAndSettle();

    // Tap on the first item "Dompet kulit cokelat" (found item)
    final feedCardFinder = find.text('Dompet kulit cokelat').first;
    await tester.ensureVisible(feedCardFinder);
    await tester.tap(feedCardFinder);
    await tester.pumpAndSettle();

    expect(find.byType(DetailPage), findsOneWidget);
    expect(find.text('Detail barang'), findsOneWidget);
    expect(find.text('BARANG DITEMUKAN'), findsOneWidget);
    expect(find.text('Ini barang saya'), findsOneWidget);

    // Tap "Ini barang saya"
    final claimBtnFinder = find.text('Ini barang saya');
    await tester.ensureVisible(claimBtnFinder);
    await tester.tap(claimBtnFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ClaimPage), findsOneWidget);
    expect(find.text('Buktikan ini milikmu'), findsOneWidget);

    // Enter proof and submit claim
    await tester.enterText(
      find.byType(TextField),
      'Warna cokelat tua ada kartu perpus',
    );
    final kirimKlaimFinder = find.text('Kirim klaim');
    await tester.ensureVisible(kirimKlaimFinder);
    await tester.tap(kirimKlaimFinder);
    await tester.pumpAndSettle();

    expect(find.text('Pratinjau findr'), findsOneWidget);
    expect(
      find.text('Tampilan klaim selesai dicoba. Klaim belum dikirim atau disimpan.'),
      findsOneWidget,
    );

    // Dismiss dialog
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();

    // Returns to DetailPage
    expect(find.byType(DetailPage), findsOneWidget);
  });

  testWidgets('CreateReportPage opens, fills form, and shows notice dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateReportPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Buat laporan'), findsOneWidget);
    expect(find.text('Ceritakan barangnya'), findsOneWidget);

    // Tap photo upload placeholder
    await tester.tap(find.text('Tambahkan foto barang'));
    await tester.pumpAndSettle();
    expect(find.text('Pratinjau findr'), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();

    // Select category 'Elektronik'
    await tester.tap(find.text('Elektronik'));
    await tester.pumpAndSettle();

    // Tap submit button
    final kirimLaporanFinder = find.text('Kirim laporan');
    await tester.ensureVisible(kirimLaporanFinder);
    await tester.tap(kirimLaporanFinder);
    await tester.pumpAndSettle();

    expect(find.text('Pratinjau findr'), findsOneWidget);
    expect(
      find.text(
        'Tampilan laporan selesai dicoba. Pengiriman dan penyimpanan akan tersedia pada tahap berikutnya.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();
  });

  testWidgets('IncomingClaimsPage and ReviewClaimPage approve flow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: IncomingClaimsPage(item: sampleItems[0]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Klaim masuk'), findsOneWidget);
    expect(find.text('Alya Putri'), findsOneWidget);
    expect(find.text('Raka Pratama'), findsOneWidget);

    // Tap "Lihat bukti →" for Alya Putri
    await tester.tap(find.text('Lihat bukti →').first);
    await tester.pumpAndSettle();

    expect(find.byType(ReviewClaimPage), findsOneWidget);
    expect(find.text('Detail klaim'), findsOneWidget);
    expect(
      find.text('Ada kartu perpustakaan di bagian dalam dan jahitan kecil di sudut kanan.'),
      findsOneWidget,
    );

    // Tap "Setujui klaim"
    await tester.tap(find.text('Setujui klaim'));
    await tester.pumpAndSettle();

    expect(find.text('Setujui klaim ini?'), findsOneWidget);
    await tester.tap(find.text('Ya, lanjutkan'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi berhasil dicoba. Data contoh belum berubah.'), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();
  });

  testWidgets('AccountPage logout and RegisterPage flow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialScreen: MainNavigationPage(initialIndex: 3)));
    await tester.pumpAndSettle();

    // Tap "Keluar dari akun"
    await tester.tap(find.text('Keluar dari akun'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari akun?'), findsOneWidget);
    await tester.tap(find.text('Ya, lanjutkan'));
    await tester.pumpAndSettle();

    // Now logged out and returned to LoginPage
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Selamat datang kembali.'), findsOneWidget);

    // Open Register
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.text('Jadi bagian dari findr.'), findsOneWidget);
  });

  testWidgets('LoginPage validates fields and toggles password visibility', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang kembali.'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.text('Lihat'));
    await tester.pumpAndSettle();

    expect(find.text('Sembunyikan'), findsOneWidget);
    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isFalse,
    );
  });

  testWidgets('City dropdown updates selected city and filters feed items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialScreen: MainNavigationPage()));
    await tester.pumpAndSettle();

    expect(find.text('Lokasi: Balikpapan'), findsOneWidget);
    expect(find.text('Temukan di Balikpapan'), findsOneWidget);

    // Open city dropdown popup menu
    await tester.tap(find.text('Lokasi: Balikpapan'));
    await tester.pumpAndSettle();

    // Select Samarinda
    await tester.tap(find.text('Samarinda').last);
    await tester.pumpAndSettle();

    // Verify empty state for Samarinda
    expect(find.text('Lokasi: Samarinda'), findsOneWidget);
    expect(find.text('Temukan di Samarinda'), findsOneWidget);
    expect(find.text('Belum ada yang cocok'), findsOneWidget);

    // Switch back to Balikpapan
    await tester.tap(find.text('Lokasi: Samarinda'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Balikpapan').last);
    await tester.pumpAndSettle();

    expect(find.text('Dompet kulit cokelat'), findsOneWidget);
  });

  testWidgets('Lost item in DetailPage shows reporter contact card when signed in', (
    WidgetTester tester,
  ) async {
    // Open DetailPage for sampleItems[1] (Headphone wireless - lost item)
    await tester.pumpWidget(
      MaterialApp(
        home: DetailPage(
          item: sampleItems[1],
          isOwn: false,
          origin: 'home',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BARANG HILANG'), findsOneWidget);
    expect(find.text('Menemukan barang ini?'), findsOneWidget);
    expect(find.text('Hubungi pelapor · Nadia'), findsOneWidget);

    // Tap contact button
    final contactBtn = find.text('Hubungi pelapor · Nadia');
    await tester.ensureVisible(contactBtn);
    await tester.tap(contactBtn);
    await tester.pumpAndSettle();

    expect(find.text('Kontak Pelapor'), findsOneWidget);
    expect(
      find.text('Silakan hubungi pelapor melalui WhatsApp/Telepon: 0812-3456-7890 (Nadia).'),
      findsOneWidget,
    );
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();
  });

  testWidgets('Cancel report in DetailPage shows confirmation, notice, and pops', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    item: sampleItems[0],
                    isOwn: true,
                    origin: 'reports',
                  ),
                ),
              ),
              child: const Text('Buka Detail'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Open DetailPage
    await tester.tap(find.text('Buka Detail'));
    await tester.pumpAndSettle();
    expect(find.text('Batalkan laporan'), findsOneWidget);

    // Tap "Batalkan laporan"
    final cancelBtn = find.text('Batalkan laporan');
    await tester.ensureVisible(cancelBtn);
    await tester.tap(cancelBtn);
    await tester.pumpAndSettle();

    expect(find.text('Batalkan laporan?'), findsOneWidget);
    await tester.tap(find.text('Ya, lanjutkan'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi berhasil dicoba. Data contoh belum berubah.'), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();

    // DetailPage popped, back to origin button
    expect(find.text('Buka Detail'), findsOneWidget);
  });

  testWidgets('RegisterPage full submission succeeds and updates login state', (
    WidgetTester tester,
  ) async {
    isSignedInNotifier.value = false;

    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Jadi bagian dari findr.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '081234567890');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');
    await tester.enterText(find.byType(TextFormField).at(4), 'password123');

    final submitBtn = find.widgetWithText(FilledButton, 'Daftar akun');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text('Pratinjau findr'), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();

    expect(isSignedInNotifier.value, isTrue);
  });

  testWidgets('HomePage and CreateReportPage render smoothly without overflow on 320px viewport', (
    WidgetTester tester,
  ) async {
    // Set small device size (e.g. 320x640)
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp(initialScreen: MainNavigationPage()));
    await tester.pumpAndSettle();

    expect(find.text('findr'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);

    // Open CreateReportPage
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateReportPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ceritakan barangnya'), findsOneWidget);
    expect(find.text('Barang Hilang'), findsOneWidget);
  });
}
