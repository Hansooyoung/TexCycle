import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texcycle/views/guide_view.dart';
import 'package:texcycle/views/splash_view.dart';

void main() {
  testWidgets('Pengujian Tampilan GuideView (Tutorial Upcycling Offline)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GuideView(),
      ),
    );

    // Verifikasi judul halaman
    expect(find.text('Panduan Upcycling & Daur Ulang'), findsOneWidget);

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
    expect(find.text('Platform Tata Kelola & Daur Ulang Tekstil'), findsOneWidget);
    expect(find.byIcon(Icons.recycling_rounded), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 300));
  });
}
