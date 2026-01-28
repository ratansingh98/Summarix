import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/utils/string_utils.dart';
import '../features/auth/presentation/auth_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_flow.dart';
import '../features/startup/presentation/start_gate.dart';
import '../features/stub/presentation/stub_screen.dart';
import '../features/upload/presentation/upload_flow_screen.dart';

class SummarixApp extends StatelessWidget {
  const SummarixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1A6FA3),
        secondary: Color(0xFF5CB6D6),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF113247),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Summarix',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF0F7FB),
        textTheme: GoogleFonts.manropeTextTheme(baseTheme.textTheme).copyWith(
          displaySmall: GoogleFonts.dmSerifDisplay(
            fontSize: 32,
            color: const Color(0xFF10314A),
          ),
          headlineSmall: GoogleFonts.dmSerifDisplay(
            fontSize: 24,
            color: const Color(0xFF10314A),
          ),
        ),
      ),
      routes: {
        '/': (_) => const StartGate(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const SummarixHome(),
        '/onboarding': (_) => const OnboardingFlow(),
        '/upload': (_) => const UploadFlowScreen(),
        '/scan': (_) => const UploadFlowScreen(scanMode: true),
      },
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        if (name.startsWith('/stub/')) {
          final title = name.replaceFirst('/stub/', '').replaceAll('-', ' ');
          return MaterialPageRoute<void>(
            builder: (_) => StubScreen(title: titleCase(title)),
            settings: settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => const SummarixHome(),
          settings: settings,
        );
      },
    );
  }
}
