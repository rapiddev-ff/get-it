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
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/home/presentation/pages/check_data/check_data_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

class AdditionalInfoWidget extends ConsumerStatefulWidget {
  const AdditionalInfoWidget({super.key});

  static const String routeName = 'additionalInfo';
  static const String routePath = 'additionalInfo';

  @override
  ConsumerState<AdditionalInfoWidget> createState() =>
      _AdditionalInfoWidgetState();
}

class _AdditionalInfoWidgetState extends ConsumerState<AdditionalInfoWidget>
    with KeyboardVisibilityMixin {
  Uint8List? image;
  bool isDataUploading_uploadImage = false;
  Uint8List? uploadedLocalFile_uploadImage;
  String? uploadToBucket;

  late final FocusNode firstnameFocusNode;
  late final TextEditingController firstnameTextController;
  late final FocusNode lastnameFocusNode;
  late final TextEditingController lastnameTextController;
  late final FocusNode usernameFocusNode;
  late final TextEditingController usernameTextController;

  bool? checkIsUsernameAvailable;
  dynamic createStripeCustomer;

  @override
  void initState() {
    super.initState();

    firstnameTextController = TextEditingController();
    firstnameFocusNode = FocusNode();    lastnameTextController = TextEditingController();
    lastnameFocusNode = FocusNode();    usernameTextController = TextEditingController();
    usernameFocusNode = FocusNode();  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    firstnameFocusNode.dispose();
    firstnameTextController.dispose();
    lastnameFocusNode.dispose();
    lastnameTextController.dispose();
    usernameFocusNode.dispose();
    usernameTextController.dispose();
    super.dispose();
  }

  // --- Inline helper functions ---

  static String _normalizeUsername(String text) => text.toLowerCase().trim();

  /// Returns 'valid' if username is acceptable, otherwise an error message.
  static String _usernameValidationResult(String text) {
    if (text.isEmpty) return 'Username is required';
    if (text.length < 3) return 'Username must be at least 3 characters';
    if (text.length > 20) return 'Username must be 20 characters or less';
    if (!RegExp(r'^@?[a-zA-Z0-9._]+$').hasMatch(text)) {
      return 'Only letters, numbers, underscores, and periods allowed';
    }
    if (text.contains('..')) return 'Username cannot contain consecutive periods';
    return 'valid';
  }

  TextStyle get _labelStyle => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontWeight: FontWeight.w500, height: 1.4);

  TextStyle get _errorSmallStyle =>
      Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error);

  bool get _isFormValid {
    return firstnameTextController.text.isNotEmpty &&
        lastnameTextController.text.isNotEmpty &&
        _usernameValidationResult(usernameTextController.text) == 'valid' &&
        (checkIsUsernameAvailable ?? false);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      if (!mounted) return;
      setState(() => isDataUploading_uploadImage = true);
      try {
        final bytes = await pickedFile.readAsBytes();
        if (!mounted) return;
        setState(() {
          uploadedLocalFile_uploadImage = bytes;
          image = bytes;
        });

        // Direct Supabase storage upload (bypassing FF custom action)
        final supabase = Supabase.instance.client;
        final uuid = const Uuid().v4();
        final ext = pickedFile.name.contains('.')
            ? pickedFile.name
                .substring(pickedFile.name.lastIndexOf('.'))
                .toLowerCase()
            : '.jpg';
        final filePath = '${ref.read(currentUserIdProvider)}/$uuid$ext';
        final mimeType = lookupMimeType(pickedFile.name) ?? 'image/jpeg';
        await supabase.storage.from('avatars').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: mimeType, upsert: true),
            );
        uploadToBucket =
            supabase.storage.from('avatars').getPublicUrl(filePath);
      } catch (e) {
        if (mounted) {
          actions.toastificationshow(context, 'Error',
              'Failed to upload image. Please try again', 'error');
        }
      } finally {
        isDataUploading_uploadImage = false;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernameText = usernameTextController.text;
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
                            style: Theme.of(context).textTheme.headlineMedium!,
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
                                    color: AppColors.surfaceDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    onTap: _pickAndUploadImage,
                                    child: Builder(
                                      builder: (context) {
                                        if (image != null &&
                                            image!.isNotEmpty) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.memory(
                                              image!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.userLarge,
                                              color: AppColors.neutral650,
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
                              controller: firstnameTextController,
                              focusNode: firstnameFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'firstnameTextController',
                                const Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              onFieldSubmitted: (_) async {
                                lastnameFocusNode.requestFocus();
                              },
                              autofocus: false,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: appInputDecoration('First Name'),
                              style: appTextFieldStyle,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
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
                              controller: lastnameTextController,
                              focusNode: lastnameFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'lastnameTextController',
                                const Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              onFieldSubmitted: (_) async {
                                usernameFocusNode.requestFocus();
                              },
                              autofocus: false,
                              autofillHints: const [AutofillHints.familyName],
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: appInputDecoration('Last Name'),
                              style: appTextFieldStyle,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
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
                              controller: usernameTextController,
                              focusNode: usernameFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'usernameTextController',
                                const Duration(milliseconds: 100),
                                () async {
                                  checkIsUsernameAvailable =
                                      await actions.checkIsUsernameAvailable(
                                    _normalizeUsername(
                                        usernameTextController.text),
                                  );

                                  if (!mounted) return;
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
                              maxLength: 20,
                              buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      required maxLength}) =>
                                  null,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9_.@]'))
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
                                  (checkIsUsernameAvailable ?? false)
                                      ? 'Available '
                                      : 'Unavailable',
                                  style: GoogleFonts.inter(
                                    color: (checkIsUsernameAvailable ?? false)
                                        ? AppColors.statusSuccess
                                        : AppColors.destructive500,
                                    fontSize: 12.0,
                                  ),
                                ).animate().fade(duration: 600.ms),
                                if (checkIsUsernameAvailable ?? false)
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.statusSuccess,
                                    size: 20.0,
                                  ),
                                if (!(checkIsUsernameAvailable ?? true))
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
                                    'first_name': firstnameTextController.text,
                                    'last_name': lastnameTextController.text,
                                    'username': _normalizeUsername(
                                        usernameTextController.text),
                                    'avatar_url': uploadToBucket,
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'user_id',
                                    ref.read(currentUserIdProvider),
                                  ),
                                );
                                createStripeCustomer =
                                    await actions.createStripeCustomer(
                                  ref.read(currentUserEmailProvider),
                                  '${firstnameTextController.text} ${lastnameTextController.text}',
                                  '',
                                );

                                // Update authProvider with new profile data
                                ref
                                    .read(authProvider.notifier)
                                    .updateUser((e) => e.copyWith(
                                          firstName:
                                              firstnameTextController.text,
                                          lastName: lastnameTextController.text,
                                          username: _normalizeUsername(
                                              usernameTextController.text),
                                          avatarUrl: uploadToBucket ?? '',
                                        ));

                                if (context.mounted) {
                                  context.goNamed(CheckDataWidget.routeName);
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
