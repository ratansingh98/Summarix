import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/background_layer.dart';
import '../../../core/widgets/dotted_circle.dart';

class SummarixHome extends StatefulWidget {
  const SummarixHome({super.key});

  @override
  State<SummarixHome> createState() => _SummarixHomeState();
}

class _SummarixHomeState extends State<SummarixHome> {
  final Map<String, bool> _options = {
    'Lab results': true,
    'Imaging notes': false,
    'Medication list': true,
    'Doctor comments': false,
  };

  void _openStub(String slug) {
    Navigator.of(context).pushNamed('/stub/$slug');
  }

  int _tabIndex = 0;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_complete', false);
    await prefs.setBool('onboarding_complete', false);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundLayer(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _tabIndex,
                    children: [
                      _SummarizeTab(
                        options: _options,
                        onProfileTap: () => _openStub('profile'),
                        onLogout: _logout,
                        onUpload: () =>
                            Navigator.of(context).pushNamed('/upload'),
                        onScan: () => Navigator.of(context).pushNamed('/scan'),
                        onPrimary: () => _openStub('doctor-review'),
                        onSecondary: () => _openStub('schedule-review'),
                        onChat: () => _openStub('reviewer-chat'),
                        onDownload: () => _openStub('download-summary'),
                        onShare: () => _openStub('share-summary'),
                        onExport: () => _openStub('export-vault'),
                      ),
                      _PastSummaryTab(
                        onOpenDetail: () => _openStub('summary-detail'),
                      ),
                      _ProfileTab(
                        onLogout: _logout,
                        onBuyTokens: () => _openStub('buy-tokens'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (value) => setState(() => _tabIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Summarize',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Past summaries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _SummarizeTab extends StatelessWidget {
  const _SummarizeTab({
    required this.options,
    required this.onProfileTap,
    required this.onLogout,
    required this.onUpload,
    required this.onScan,
    required this.onPrimary,
    required this.onSecondary,
    required this.onChat,
    required this.onDownload,
    required this.onShare,
    required this.onExport,
  });

  final Map<String, bool> options;
  final VoidCallback onProfileTap;
  final VoidCallback onLogout;
  final VoidCallback onUpload;
  final VoidCallback onScan;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final VoidCallback onChat;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        _TopBar(
          onTap: onProfileTap,
          onLogout: onLogout,
        ),
        const SizedBox(height: 24),
        _HeroCard(
          onUpload: onUpload,
          onScan: onScan,
        ),
        const SizedBox(height: 24),
        _ModeDetails(
          onPrimary: onPrimary,
          onSecondary: onSecondary,
        ),
        const SizedBox(height: 24),
        _StatusBoard(
          onChat: onChat,
          onDownload: onDownload,
        ),
        const SizedBox(height: 24),
        _BottomActions(
          onShare: onShare,
          onExport: onExport,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.center,
          child: Text(
            'HIPAA-ready demo · Data stored locally only',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: const Color(0xFF6B8CA1)),
          ),
        ),
        SizedBox(height: size.width < 600 ? 24 : 40),
      ],
    );
  }
}

class _PastSummaryTab extends StatelessWidget {
  const _PastSummaryTab({required this.onOpenDetail});

  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final summaries = [
      'Annual physical · Jan 2026',
      'Cardio follow-up · Nov 2025',
      'Lab work · Sep 2025',
      'Imaging review · Jul 2025',
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        Text(
          'Past medical summaries',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Review your previous summaries and doctor notes.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: const Color(0xFF547184)),
        ),
        const SizedBox(height: 16),
        ...summaries.map(
          (title) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x143A6C96),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: Color(0xFF1A6FA3)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: onOpenDetail,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('View'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.onLogout, required this.onBuyTokens});

  final VoidCallback onLogout;
  final VoidCallback onBuyTokens;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x143A6C96),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFE6F3FA),
                child: Icon(Icons.person_outline, color: Color(0xFF1A6FA3)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Morgan',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'alex@summarix.health',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: const Color(0xFF6B8CA1)),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F4FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('128 tokens'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onBuyTokens,
          icon: const Icon(Icons.shopping_bag_outlined),
          label: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Buy more tokens'),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A6FA3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const _AboutPage(),
            ),
          ),
          icon: const Icon(Icons.info_outline),
          label: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('About Summarix'),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1A6FA3),
            side: const BorderSide(color: Color(0xFF9AC7DD)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          label: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Logout'),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1A6FA3),
            side: const BorderSide(color: Color(0xFF9AC7DD)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundLayer(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Text(
                  'From report to clarity',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'A guided flow inspired by medical onboarding cards.',
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 640;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _FeatureCard(
                          title: 'Clinical-grade checks',
                          description:
                              'AI highlights abnormalities with confidence scores.',
                          icon: Icons.verified_outlined,
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                        ),
                        _FeatureCard(
                          title: 'Full spectrum summary',
                          description:
                              'Vitals, labs, imaging, and notes in one brief.',
                          icon: Icons.layers_outlined,
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                        ),
                        _FeatureCard(
                          title: 'Caring clinicians',
                          description:
                              'Doctors annotate your report with practical tips.',
                          icon: Icons.people_outline,
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                        ),
                        _FeatureCard(
                          title: 'Rehab-ready guidance',
                          description:
                              'Get safe next steps and follow-up reminders.',
                          icon: Icons.health_and_safety_outlined,
                          width: isWide
                              ? (constraints.maxWidth - 16) / 2
                              : constraints.maxWidth,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onTap, required this.onLogout});

  final VoidCallback onTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
        const Spacer(),
        _TokenPill(onTap: onTap, onLogout: onLogout),
      ],
    );
  }
}

class _TokenPill extends StatelessWidget {
  const _TokenPill({required this.onTap, required this.onLogout});

  final VoidCallback onTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F4FB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFB6D8EA)),
        ),
        child: Row(
          children: [
            const Icon(Icons.bolt, color: Color(0xFF1A6FA3), size: 18),
            const SizedBox(width: 6),
            const Text('128 tokens'),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  onLogout();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
              icon: const Icon(Icons.more_vert, color: Color(0xFF1A6FA3)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onUpload, required this.onScan});

  final VoidCallback onUpload;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1D3A6EA5),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summarize your health report in minutes.',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Drop PDFs, scans, or lab images and get a clean, structured overview.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: const Color(0xFF547184)),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4FAFD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFB9DDED)),
            ),
            child: Row(
              children: [
                const DottedCircle(
                  diameter: 52,
                  child: Icon(Icons.upload_file, color: Color(0xFF1A6FA3)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Health_report_2026.pdf',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F1FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Ready'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onUpload,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Upload report'),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    minimumSize: const Size(0, 48),
                    backgroundColor: const Color(0xFF1A6FA3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.document_scanner_outlined),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Scan'),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: Color(0xFF9AC7DD)),
                    foregroundColor: const Color(0xFF1A6FA3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeDetails extends StatelessWidget {
  const _ModeDetails({
    required this.onPrimary,
    required this.onSecondary,
  });

  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A3B6C96),
                  blurRadius: 16,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: const Color(0xFF1A6FA3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Doctor Review',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Doctor-assisted review within 12-24 hours.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: const Color(0xFF567384)),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onPrimary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6FA3),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Request doctor review'),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: onSecondary,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1A6FA3),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    minimumSize: const Size(0, 48),
                    side: const BorderSide(color: Color(0xFF9DC6DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Schedule review call'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionsCard extends StatelessWidget {
  const _OptionsCard({
    required this.options,
    required this.onChanged,
    required this.onPreview,
  });

  final Map<String, bool> options;
  final void Function(String key, bool value) onChanged;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD3E7F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Include in summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          ...options.entries.map(
            (entry) => SwitchListTile.adaptive(
              value: entry.value,
              contentPadding: EdgeInsets.zero,
              activeColor: const Color(0xFF1A6FA3),
              title: Text(entry.key),
              subtitle: const Text('1 token'),
              onChanged: (value) => onChanged(entry.key, value),
            ),
          ),
          const SizedBox(height: 6),
          ElevatedButton.icon(
            onPressed: onPreview,
            icon: const Icon(Icons.visibility_outlined),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Preview summary'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5CB6D6),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.width,
  });

  final String title;
  final String description;
  final IconData icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x123A6C96),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            DottedCircle(
              diameter: 68,
              child: Icon(icon, size: 28, color: const Color(0xFF1A6FA3)),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: const Color(0xFF5A7789)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBoard extends StatelessWidget {
  const _StatusBoard({required this.onChat, required this.onDownload});

  final VoidCallback onChat;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14316A93),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review status',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          _StatusTile(
            title: 'AI Summary',
            subtitle: 'Completed · 2 minutes ago',
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 8),
          _StatusTile(
            title: 'Doctor Review',
            subtitle: 'Queued · ETA 18 hours',
            icon: Icons.schedule_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Chat with reviewer'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6FA3),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download_outlined),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Download'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A6FA3),
                  side: const BorderSide(color: Color(0xFF9AC7DD)),
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3FA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF1A6FA3)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: const Color(0xFF58798A)),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Color(0xFF8FB5CA)),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onShare, required this.onExport});

  final VoidCallback onShare;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Share summary'),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A6FA3),
              side: const BorderSide(color: Color(0xFF9AC7DD)),
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onExport,
            icon: const Icon(Icons.shield_outlined),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Export to vault'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5CB6D6),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
