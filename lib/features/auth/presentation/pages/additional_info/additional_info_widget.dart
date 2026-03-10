import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/home/presentation/pages/home_page/home_page_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'additional_info_model.dart';

export 'additional_info_model.dart';

class AdditionalInfoWidget extends ConsumerStatefulWidget {
  const AdditionalInfoWidget({super.key});

  static String routeName = 'additionalInfo';
  static String routePath = 'additionalInfo';

  @override
  ConsumerState<AdditionalInfoWidget> createState() =>
      _AdditionalInfoWidgetState();
}

class _AdditionalInfoWidgetState extends ConsumerState<AdditionalInfoWidget>
    with KeyboardVisibilityMixin {
  late AdditionalInfoModel _model;

  @override
  void initState() {
    super.initState();
    _model = AdditionalInfoModel();

    _model.firstnameTextController ??= TextEditingController();
    _model.firstnameFocusNode ??= FocusNode();
    _model.firstnameFocusNode!.addListener(() => setState(() {}));
    _model.lastnameTextController ??= TextEditingController();
    _model.lastnameFocusNode ??= FocusNode();
    _model.lastnameFocusNode!.addListener(() => setState(() {}));
    _model.usernameTextController ??= TextEditingController();
    _model.usernameFocusNode ??= FocusNode();
    _model.usernameFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- Inline helper functions ---

  static String _normalizeUsername(String text) => text.toLowerCase().trim();

  /// Returns 'valid' if username is acceptable, otherwise an error message.
  static String _usernameValidationResult(String text) {
    if (text.isEmpty) return 'Username is required';
    if (text.length < 3) return 'Username must be at least 3 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text)) {
      return 'Only letters, numbers, and underscores allowed';
    }
    return 'valid';
  }

  TextStyle get _labelStyle => Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4);

  TextStyle get _errorSmallStyle => Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error);

  bool get _isFormValid {
    return (_model.firstnameTextController?.text ?? '').isNotEmpty &&
        (_model.lastnameTextController?.text ?? '').isNotEmpty &&
        _usernameValidationResult(_model.usernameTextController?.text ?? '') ==
            'valid' &&
        (_model.checkIsUsernameAvailable ?? false);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _model.isDataUploading_uploadImage = true);
      try {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _model.uploadedLocalFile_uploadImage = bytes;
          _model.image = bytes;
        });

        // Direct Supabase storage upload (bypassing FF custom action)
        final supabase = Supabase.instance.client;
        final uuid = const Uuid().v4();
        final ext = pickedFile.name.contains('.')
            ? pickedFile.name
                .substring(pickedFile.name.lastIndexOf('.'))
                .toLowerCase()
            : '.jpg';
        final filePath = '$ref.read(currentUserIdProvider)/$uuid$ext';
        final mimeType = lookupMimeType(pickedFile.name) ?? 'image/jpeg';
        await supabase.storage.from('avatars').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: mimeType, upsert: true),
            );
        _model.uploadToBucket =
            supabase.storage.from('avatars').getPublicUrl(filePath);
      } catch (e) {
        if (mounted) {
          actions.toastificationshow(context, 'Error',
              'Failed to upload image. Please try again', 'error');
        }
      } finally {
        _model.isDataUploading_uploadImage = false;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameText = _model.usernameTextController?.text ?? '';
    final usernameValidation = _usernameValidationResult(usernameText);

    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            AppConstants.appName,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
          actions: const [],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 34.0),
                          child: Text(
                            'About You',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 128.0,
                            height: 128.0,
                            child: Stack(
                              children: [
                                Container(
                                  width: 128.0,
                                  height: 128.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF363636),
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    onTap: _pickAndUploadImage,
                                    child: Builder(
                                      builder: (context) {
                                        if (_model.image != null &&
                                            _model.image!.isNotEmpty) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.memory(
                                              _model.image!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.userLarge,
                                              color: Color(0xFF797A79),
                                              size: 70.0,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.camera,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'First Name',
                          style: _labelStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.firstnameTextController,
                              focusNode: _model.firstnameFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.firstnameTextController',
                                const Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              onFieldSubmitted: (_) async {
                                _model.lastnameFocusNode?.requestFocus();
                              },
                              autofocus: false,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: appInputDecoration('First Name'),
                              style: appTextFieldStyle,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              validator: _model
                                          .firstnameTextControllerValidator !=
                                      null
                                  ? (val) =>
                                      _model.firstnameTextControllerValidator!(
                                          context, val)
                                  : null,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('^[a-zA-Z]+( [a-zA-Z]+){0,2}'))
                              ],
                            ),
                          ),
                        ),
                        // Profanity check removed (placeholder: always false)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Last Name',
                            style: _labelStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.lastnameTextController,
                              focusNode: _model.lastnameFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.lastnameTextController',
                                const Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              onFieldSubmitted: (_) async {
                                _model.usernameFocusNode?.requestFocus();
                              },
                              autofocus: false,
                              autofillHints: const [AutofillHints.familyName],
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: appInputDecoration('Last Name'),
                              style: appTextFieldStyle,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              validator:
                                  _model.lastnameTextControllerValidator != null
                                      ? (val) => _model
                                              .lastnameTextControllerValidator!(
                                          context, val)
                                      : null,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('^[a-zA-Z]+( [a-zA-Z]+){0,2}'))
                              ],
                            ),
                          ),
                        ),
                        // Profanity check removed (placeholder: always false)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Username',
                            style: _labelStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _model.usernameTextController,
                              focusNode: _model.usernameFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.usernameTextController',
                                const Duration(milliseconds: 100),
                                () async {
                                  _model.checkIsUsernameAvailable =
                                      await actions.checkIsUsernameAvailable(
                                    _normalizeUsername(
                                        _model.usernameTextController!.text),
                                  );

                                  setState(() {});
                                },
                              ),
                              autofocus: false,
                              autofillHints: const [AutofillHints.username],
                              obscureText: false,
                              decoration: appInputDecoration('Username'),
                              style: appTextFieldStyle,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                              validator:
                                  _model.usernameTextControllerValidator != null
                                      ? (val) => _model
                                              .usernameTextControllerValidator!(
                                          context, val)
                                      : null,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z0-9_]+'))
                              ],
                            ),
                          ),
                        ),
                        // Profanity check removed (placeholder: always false)
                        if (usernameValidation != 'valid' &&
                            usernameText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              usernameValidation,
                              style: _errorSmallStyle,
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (usernameText.isNotEmpty &&
                            usernameValidation == 'valid')
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  (_model.checkIsUsernameAvailable ?? false)
                                      ? 'Available '
                                      : 'Unavailable',
                                  style: GoogleFonts.inter(
                                    color: (_model.checkIsUsernameAvailable ??
                                            false)
                                        ? const Color(0xFF4ADE80)
                                        : const Color(0xFFEF4444),
                                    fontSize: 12.0,
                                  ),
                                ).animate().fade(duration: 600.ms),
                                if (_model.checkIsUsernameAvailable ?? false)
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFF4ADE80),
                                    size: 20.0,
                                  ),
                                if (!(_model.checkIsUsernameAvailable ?? true))
                                  const Icon(
                                    Icons.error_outline,
                                    color: AppColors.destructive500,
                                    size: 20.0,
                                  ),
                              ].divide(const SizedBox(width: 4.0)),
                            ),
                          ),
                      ].addToStart(const SizedBox(height: 32.0)),
                    ),
                  ),
                ),
                if (!isKeyboardShowing(context))
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Next',
                        enabled: _isFormValid,
                        borderRadius: 8.0,
                        onPressed: !_isFormValid
                            ? null
                            : () async {
                                await UserProfilesTable().update(
                                  data: {
                                    'first_name':
                                        _model.firstnameTextController!.text,
                                    'last_name':
                                        _model.lastnameTextController!.text,
                                    'username': _normalizeUsername(
                                        _model.usernameTextController!.text),
                                    'avatar_url': _model.uploadToBucket,
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'user_id',
                                    ref.read(currentUserIdProvider),
                                  ),
                                );
                                _model.createStripeCustomer =
                                    await actions.createStripeCustomer(
                                  currentUserEmail,
                                  '${_model.firstnameTextController!.text} ${_model.lastnameTextController!.text}',
                                  '',
                                );

                                // Update authProvider with new profile data
                                ref
                                    .read(authProvider.notifier)
                                    .updateUser((e) => e.copyWith(
                                          firstName: _model
                                              .firstnameTextController!.text,
                                          lastName: _model
                                              .lastnameTextController!.text,
                                          username: _normalizeUsername(_model
                                              .usernameTextController!.text),
                                          avatarUrl:
                                              _model.uploadToBucket ?? '',
                                        ));

                                if (context.mounted) {
                                  context.goNamed(HomePageWidget.routeName);
                                }
                              },
                      ),
                    ]
                        .divide(const SizedBox(height: 40.0))
                        .addToStart(const SizedBox(height: 24.0))
                        .addToEnd(const SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: const Offset(0, 100),
                        end: Offset.zero,
                        duration: 600.ms,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
