import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texcycle/core/localization/app_locale.dart';
import 'package:texcycle/views/guide_view.dart';
import 'package:texcycle/views/settings_view.dart';
import 'package:texcycle/views/splash_view.dart';

void main() {
  setUp(() {
    AppLocale.setLocale('id');
  });

  testWidgets('Pengujian Tampilan GuideView (Tutorial Upcycling Offline)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GuideView(),
      ),
    );

    // Verifikasi judul halaman
    expect(find.text(AppText.guideTitle), findsOneWidget);

    // Verifikasi keberadaan chip kategori
    expect(find.text('Semua Tutorial'), findsOneWidget);
    expect(find.text('Kain Besar'), findsOneWidget);
    expect(find.text('Kain Sedang'), findsOneWidget);
    expect(find.text('Kain Kecil'), findsOneWidget);
    expect(find.text('Sisa Benang'), findsOneWidget);

    // Verifikasi keberadaan tutorial awal
    expect(find.text('Membuat Tote Bag Belanja Ramah Lingkungan'), findsOneWidget);
    expect(find.text('Membuat Dompet Koin & Pouch Kosmetik'), findsOneWidget);

    // Uji interaksi ekspansi tutorial
    await tester.tap(find.text('Membuat Tote Bag Belanja Ramah Lingkungan'));
    await tester.pumpAndSettle();

    // Verifikasi bagian alat dan bahan muncul
    expect(find.text('Alat & Bahan:'), findsOneWidget);
    expect(find.text('Langkah Pembuatan:'), findsOneWidget);
  });

  testWidgets('Pengujian Tampilan SplashView (Branding & Preloader Versi 1.2)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashView(autoPreload: false),
      ),
    );

    // Verifikasi teks branding TexCycle
    expect(find.text('TexCycle'), findsOneWidget);
    expect(find.text(AppText.splashSubtitle), findsOneWidget);
    expect(find.byIcon(Icons.recycling_rounded), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('Pengujian Interaksi Pilihan Bahasa di SettingsView', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsView(),
      ),
    );

    // Verifikasi teks awal bahasa Indonesia
    expect(find.text(AppText.langPrefTitle), findsOneWidget);
    expect(find.text('ID'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);

    // Tap tombol 'EN'
    await tester.tap(find.text('EN'));
    await tester.pump(const Duration(milliseconds: 200));

    // Verifikasi locale berubah menjadi EN
    expect(AppLocale.isEn, isTrue);
    expect(AppText.navHome, equals('Home'));
  });
}
