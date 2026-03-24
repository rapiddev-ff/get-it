import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/app_loading_indicator.dart';
import '/features/home/data/repositories/vision_repository.dart';
import '/features/home/domain/models/ai_scan_result_model.dart';

class AiScanResultWidget extends ConsumerStatefulWidget {
  const AiScanResultWidget({
    super.key,
    required this.scanResult,
    required this.imageBytes,
  });

  final AiScanResult scanResult;
  final Uint8List imageBytes;

  @override
  ConsumerState<AiScanResultWidget> createState() =>
      _AiScanResultWidgetState();
}

class _AiScanResultWidgetState extends ConsumerState<AiScanResultWidget> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isRescanning = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.scanResult.suggestedTitle);
    _descriptionController =
        TextEditingController(text: widget.scanResult.suggestedDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _continueToForm() {
    // Build updated result with edited title/description
    final updatedResult = widget.scanResult.copyWith(
      suggestedTitle: _titleController.text.trim(),
      suggestedDescription: _descriptionController.text.trim(),
    );

    // Pop back to caller with the result + image
    Navigator.pop(context, {
      'scanResult': updatedResult,
      'imageBytes': widget.imageBytes,
    });
  }

  Future<void> _rescan() async {
    setState(() => _isRescanning = true);

    try {
      final result = await ref
          .read(visionRepositoryProvider)
          .analyzeImage(widget.imageBytes);

      if (!mounted) return;
      setState(() {
        _isRescanning = false;
        _titleController.text = result.suggestedTitle;
        _descriptionController.text = result.suggestedDescription;
      });

      // Replace current screen with new results
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AiScanResultWidget(
            scanResult: result,
            imageBytes: widget.imageBytes,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRescanning = false);

      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: Text('Rescan Failed'),
        description: Text(e.toString().replaceFirst('Exception: ', '')),
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.scanResult;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan Results',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: _isRescanning
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLoadingIndicator(),
                  const SizedBox(height: 16.0),
                  Text(
                    'Rescanning...',
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.memory(
                      widget.imageBytes,
                      width: double.infinity,
                      height: 220.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Confidence score
                  _buildConfidenceBar(result.confidence),
                  const SizedBox(height: 20.0),

                  // Suggested Title
                  _buildSectionLabel('Suggested Title'),
                  const SizedBox(height: 8.0),
                  _buildTextField(_titleController, 'Product title', 1),
                  const SizedBox(height: 16.0),

                  // Category
                  if (result.categoryName != null) ...[
                    _buildSectionLabel('Category'),
                    const SizedBox(height: 8.0),
                    _buildInfoChip(result.categoryName!),
                    const SizedBox(height: 16.0),
                  ],

                  // Subcategory
                  if (result.subcategoryName != null) ...[
                    _buildSectionLabel('Subcategory'),
                    const SizedBox(height: 8.0),
                    _buildInfoChip(result.subcategoryName!),
                    const SizedBox(height: 16.0),
                  ],

                  // Tags
                  if (result.suggestedTags.isNotEmpty) ...[
                    _buildSectionLabel('Suggested Tags'),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: result.suggestedTags
                          .map((tag) => _buildTagChip(tag.name))
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                  ],

                  // Detected Labels
                  if (result.labels.isNotEmpty) ...[
                    _buildSectionLabel('Detected Labels'),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: result.labels
                          .take(10)
                          .map((label) => _buildLabelChip(label))
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                  ],

                  // OCR Text
                  if (result.detectedText != null &&
                      result.detectedText!.isNotEmpty) ...[
                    _buildSectionLabel('Detected Text (OCR)'),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppColors.surfaceDark),
                      ),
                      child: Text(
                        result.detectedText!,
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],

                  // Description
                  _buildSectionLabel('Suggested Description'),
                  const SizedBox(height: 8.0),
                  _buildTextField(_descriptionController, 'Description', 4),
                  const SizedBox(height: 32.0),

                  // Action buttons
                  _buildContinueButton(),
                  const SizedBox(height: 12.0),
                  _buildRescanButton(),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
    );
  }

  Widget _buildConfidenceBar(double confidence) {
    final percentage = (confidence * 100).round();
    final color = confidence >= 0.7
        ? AppColors.statusSuccess
        : confidence >= 0.4
            ? AppColors.statusWarning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, size: 18.0, color: AppColors.brandPurple),
          const SizedBox(width: 8.0),
          Text(
            'Confidence: $percentage%',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: confidence,
                backgroundColor: AppColors.surfaceDark,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, int maxLines) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14.0,
          color: AppColors.textPlaceholder,
        ),
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.surfaceDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.surfaceDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.brandPurple),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.brandPurple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.brandPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: AppColors.brandPurpleLight,
        ),
      ),
    );
  }

  Widget _buildTagChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: AppColors.surfaceDark),
      ),
      child: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 13.0,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLabelChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12.0,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 52.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandPurple, AppColors.brandBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton(
        onPressed: _continueToForm,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Continue to Full Form',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRescanButton() {
    return Container(
      width: double.infinity,
      height: 52.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.surfaceDark),
      ),
      child: TextButton(
        onPressed: _rescan,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 20.0, color: AppColors.textPrimary),
            const SizedBox(width: 8.0),
            Text(
              'Rescan',
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
}
