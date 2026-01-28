import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/background_layer.dart';
import '../../../core/widgets/dotted_circle.dart';

class UploadFlowScreen extends StatefulWidget {
  const UploadFlowScreen({super.key, this.scanMode = false});

  final bool scanMode;

  @override
  State<UploadFlowScreen> createState() => _UploadFlowScreenState();
}

class _UploadFlowScreenState extends State<UploadFlowScreen> {
  String? _fileName;
  double _progress = 0;
  bool _isUploading = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (_isUploading) return;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _fileName = result.files.first.name);
      _startFakeUpload();
    }
  }

  void _startFakeUpload() {
    _timer?.cancel();
    setState(() {
      _progress = 0;
      _isUploading = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      setState(() {
        _progress += 0.06;
        if (_progress >= 1) {
          _progress = 1;
          _isUploading = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.scanMode ? 'Scan report' : 'Upload report';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundLayer(),
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.scanMode
                    ? 'Capture a clean scan to start the summary.'
                    : 'Upload your report to start the summary.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x153A6C96),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DottedCircle(
                          diameter: 52,
                          child: Icon(
                            widget.scanMode
                                ? Icons.document_scanner_outlined
                                : Icons.upload_file_outlined,
                            color: const Color(0xFF1A6FA3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _fileName ?? 'No file selected yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: _fileName == null
                                      ? const Color(0xFF7A95A8)
                                      : const Color(0xFF10314A),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: const Color(0xFFE6F3FA),
                      color: const Color(0xFF1A6FA3),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isUploading
                          ? 'Uploading and extracting text…'
                          : _progress == 1
                              ? 'Ready for AI summary'
                              : 'Waiting for upload',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: const Color(0xFF5F7B8C)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickFile,
                            icon: const Icon(Icons.add_circle_outline),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(widget.scanMode
                                  ? 'Capture scan'
                                  : 'Pick file'),
                            ),
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
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _progress == 1
                              ? () => Navigator.of(context)
                                  .pushNamed('/stub/ai-review')
                              : null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1A6FA3),
                            side: const BorderSide(color: Color(0xFF9AC7DD)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Run AI summary'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _InfoStrip(
                icon: Icons.lock_outline,
                text:
                    'Uploads stay on-device in this demo. Manual review uses anonymized data.',
              ),
              const SizedBox(height: 20),
              const _ReviewTimeline(),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD7EAF4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A6FA3)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ReviewTimeline extends StatelessWidget {
  const _ReviewTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A6C96),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review timeline',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _TimelineRow(
            title: 'Upload received',
            subtitle: 'Instantly after submission',
            icon: Icons.cloud_done_outlined,
          ),
          const SizedBox(height: 8),
          _TimelineRow(
            title: 'AI summary',
            subtitle: '2-4 minutes',
            icon: Icons.bolt_outlined,
          ),
          const SizedBox(height: 8),
          _TimelineRow(
            title: 'Doctor review',
            subtitle: '12-24 hours',
            icon: Icons.medical_services_outlined,
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1A6FA3)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: const Color(0xFF6B8CA1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
