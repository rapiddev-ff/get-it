import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/app_loading_indicator.dart';
import '/features/home/data/repositories/vision_repository.dart';
import '/features/home/domain/models/ai_scan_result_model.dart';
import '/features/home/presentation/pages/seller_dashboard/ai_scan/ai_scan_result_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add/home_dashoard_inventory_add_widget.dart';

class AiScanWidget extends ConsumerStatefulWidget {
  const AiScanWidget({super.key, this.returnResultOnly = false});

  /// If true, pops with scan result data instead of navigating to inventory form.
  /// Used when opened from within the inventory_add form.
  final bool returnResultOnly;

  static const String routeName = 'aiScan';
  static const String routePath = 'aiScan';

  @override
  ConsumerState<AiScanWidget> createState() => _AiScanWidgetState();
}

enum _ScanState { idle, analyzing }

class _AiScanWidgetState extends ConsumerState<AiScanWidget> {
  final ImagePicker _picker = ImagePicker();
  _ScanState _scanState = _ScanState.idle;
  Uint8List? _capturedImageBytes;
  bool _isPickerActive = false;

  Future<void> _captureAndAnalyze() async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      await _analyzeImage(bytes);
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> _uploadFromGallery() async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      await _analyzeImage(bytes);
    } finally {
      _isPickerActive = false;
    }
  }

  Future<void> _analyzeImage(Uint8List bytes) async {
    if (!mounted) return;
    setState(() {
      _scanState = _ScanState.analyzing;
      _capturedImageBytes = bytes;
    });

    try {
      final result =
          await ref.read(visionRepositoryProvider).analyzeImage(bytes);

      if (!mounted) return;
      setState(() => _scanState = _ScanState.idle);

      // Navigate to results screen
      final resultData = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (_) => AiScanResultWidget(
            scanResult: result,
            imageBytes: bytes,
          ),
        ),
      );

      // If user tapped "Continue to Full Form"
      if (resultData != null && mounted) {
        if (widget.returnResultOnly) {
          // Pop back to caller (inventory_add) with result
          Navigator.pop(context, resultData);
        } else {
          // Navigate to inventory add with pre-filled data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeDashoardInventoryAddWidget(
                aiScanResult: resultData['scanResult'] as AiScanResult,
                aiScanImageBytes: resultData['imageBytes'] as Uint8List,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _scanState = _ScanState.idle);

      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: Text('Analysis Failed'),
        description: Text(e.toString().replaceFirst('Exception: ', '')),
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add to Inventory',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: _scanState == _ScanState.analyzing
          ? _buildAnalyzingState()
          : _buildIdleState(),
    );
  }

  Widget _buildIdleState() {
    const hp = EdgeInsets.symmetric(horizontal: 16.0);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          // Help + Expand row
          Padding(
            padding: hp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 26.0,
                  height: 26.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '?',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.crop_free,
                  size: 22.0,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),

          // Camera preview area (85% width, centered)
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: _buildCameraPreviewArea(),
            ),
          ),
          const SizedBox(height: 12.0),

          // AI Ready indicator
          Padding(
            padding: hp,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: AppColors.brandPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'AI Ready to Scan',
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Full-width divider
          Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.surfaceDark,
          ),
          const SizedBox(height: 20.0),

          // Quick Tips
          Padding(
            padding: hp,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Tips',
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildTip('1', 'Ensure good lighting and clear visibility of the product'),
                const SizedBox(height: 14.0),
                _buildTip('2', 'Position the entire product within the frame'),
                const SizedBox(height: 14.0),
                _buildTip('3', 'AI will automatically detect and catalog product details'),
              ],
            ),
          ),
          const SizedBox(height: 20.0),

          // Full-width divider
          Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.surfaceDark,
          ),
          const SizedBox(height: 24.0),

          // Action buttons
          Padding(
            padding: hp,
            child: Column(
              children: [
                _buildCaptureButton(),
                const SizedBox(height: 12.0),
                _buildGalleryButton(),
                const SizedBox(height: 16.0),
                _buildManualEntryButton(),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildCameraPreviewArea() {
    return AspectRatio(
      aspectRatio: 0.85,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.neutral700,
          borderRadius: 10.0,
          dashWidth: 4.0,
          dashSpace: 3.0,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 48.0,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Position product in frame',
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26.0,
          height: 26.0,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return Container(
      width: double.infinity,
      height: 56.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandPurple, AppColors.brandBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton(
        onPressed: _captureAndAnalyze,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 20.0, color: AppColors.textPrimary),
            const SizedBox(width: 8.0),
            Text(
              'Capture & Analyze',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryButton() {
    return Container(
      width: double.infinity,
      height: 56.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.neutral900),
      ),
      child: TextButton(
        onPressed: _uploadFromGallery,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined,
                size: 20.0, color: AppColors.textPrimary),
            const SizedBox(width: 8.0),
            Text(
              'Upload from Gallery',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualEntryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeDashoardInventoryAddWidget(),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.keyboard_outlined,
                size: 20.0, color: AppColors.textPrimary),
            const SizedBox(width: 8.0),
            Text(
              'Enter Details Manually',
              style: GoogleFonts.inter(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show captured image thumbnail
          if (_capturedImageBytes != null)
            Container(
              width: 200.0,
              height: 200.0,
              margin: const EdgeInsets.only(bottom: 32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: MemoryImage(_capturedImageBytes!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const AppLoadingIndicator(),
          const SizedBox(height: 16.0),
          Text(
            'Analyzing product...',
            style: GoogleFonts.inter(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Detecting labels, text, and category',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.brandPurple, AppColors.brandBlue],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.auto_awesome, size: 20.0, color: Colors.white),
                ),
                const SizedBox(width: 12.0),
                Text(
                  'AI Scan Help',
                  style: GoogleFonts.inter(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Take a photo of your product or upload from gallery. '
              'Our AI will automatically detect the product type, brand, '
              'condition, and suggest a title, category, and tags.',
              style: GoogleFonts.inter(
                fontSize: 14.0,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20.0),
            _helpTip(Icons.light_mode_outlined, 'Use good lighting'),
            const SizedBox(height: 12.0),
            _helpTip(Icons.crop_original, 'Place the product on a clean background'),
            const SizedBox(height: 12.0),
            _helpTip(Icons.label_outline, 'Make sure any labels/tags are visible'),
            const SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              height: 52.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.brandPurple, AppColors.brandBlue],
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Got it',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _helpTip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.0, color: AppColors.brandPurpleLight),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
  });

  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end.clamp(0, metric.length)),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderRadius != oldDelegate.borderRadius ||
      dashWidth != oldDelegate.dashWidth ||
      dashSpace != oldDelegate.dashSpace;
}
