import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/background_layer.dart';
import '../../../core/widgets/dotted_circle.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _pageIndex = 0;
  late final AnimationController _fadeController;

  final List<_OnboardingCardData> _cards = const [
    _OnboardingCardData(
      title: 'Clinical quality',
      description:
          'Every report is checked against lab ranges and clinical guidelines.',
      icon: Icons.fact_check_outlined,
    ),
    _OnboardingCardData(
      title: 'Full-spectrum insight',
      description:
          'Vitals, labs, imaging, and notes merged into a single narrative.',
      icon: Icons.shield_outlined,
    ),
    _OnboardingCardData(
      title: 'Caring clinicians',
      description:
          'Doctor reviewers add context and explain what changes matter.',
      icon: Icons.support_agent_outlined,
    ),
    _OnboardingCardData(
      title: 'Best outcomes',
      description:
          'Clear next steps and reminders for follow-up care.',
      icon: Icons.thumb_up_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _jumpTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_pageIndex];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundLayer(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Skip'),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _jumpTo((_pageIndex + 1) % _cards.length),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Preview'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _cards.length,
                    onPageChanged: (index) {
                      setState(() => _pageIndex = index);
                      _fadeController.forward(from: 0);
                    },
                    itemBuilder: (context, index) {
                      final data = _cards[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _OnboardingCard(data: data),
                      );
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeController.value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - _fadeController.value) * 12),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          card.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          card.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: const Color(0xFF547184)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _cards.length,
                    (index) => GestureDetector(
                      onTap: () => _jumpTo(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: index == _pageIndex ? 20 : 8,
                        decoration: BoxDecoration(
                          color: index == _pageIndex
                              ? const Color(0xFF1A6FA3)
                              : const Color(0xFFC8DCE9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pageIndex == 0
                              ? null
                              : () => _jumpTo(_pageIndex - 1),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1A6FA3),
                            side: const BorderSide(color: Color(0xFF9AC7DD)),
                            minimumSize: const Size(0, 48),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Back'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pageIndex == _cards.length - 1
                              ? _completeOnboarding
                              : () => _jumpTo(_pageIndex + 1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A6FA3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(_pageIndex == _cards.length - 1
                                ? 'Get started'
                                : 'Next'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingCardData {
  const _OnboardingCardData({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.data});

  final _OnboardingCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A2E6A95),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DottedCircle(
            diameter: 110,
            child: Icon(data.icon, size: 48, color: const Color(0xFF1A6FA3)),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: const Color(0xFF547184)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
