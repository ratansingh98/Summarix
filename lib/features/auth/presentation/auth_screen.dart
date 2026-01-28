import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/background_layer.dart';
import '../../../core/widgets/dotted_circle.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  Future<void> _completeAuth(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_complete', true);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundLayer(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A2B6F9C),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.medical_services_outlined,
                            color: Color(0xFF1A6FA3)),
                        const SizedBox(width: 8),
                        Text(
                          'Summarix',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                DottedCircle(
                  diameter: 120,
                  child: Icon(
                    Icons.lock_outline,
                    size: 48,
                    color: const Color(0xFF1A6FA3),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Summarix',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to summarize your health report and keep it organized.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: const Color(0xFF557283)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _PrimaryButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata,
                  onPressed: () => _completeAuth(context),
                ),
                const SizedBox(height: 12),
                _SecondaryButton(
                  label: 'Sign up with email',
                  icon: Icons.mail_outline,
                  onPressed: () => _completeAuth(context),
                ),
                const SizedBox(height: 12),
                _SecondaryButton(
                  label: 'Already have an account? Log in',
                  icon: Icons.login,
                  onPressed: () => _completeAuth(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'By continuing you agree to our Terms and Privacy Policy.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: const Color(0xFF6B8CA1)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A6FA3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1A6FA3),
        side: const BorderSide(color: Color(0xFF9AC7DD)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
