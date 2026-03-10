import '/backend/supabase/supabase.dart';
import '/core/utils/uploaded_file.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/utils/form_validators.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'settings_edit_profile_model.dart';
export 'settings_edit_profile_model.dart';

class SettingsEditProfileWidget extends ConsumerStatefulWidget {
  const SettingsEditProfileWidget({super.key});

  static String routeName = 'settingsEditProfile';
  static String routePath = 'settingsEditProfile';

  @override
  ConsumerState<SettingsEditProfileWidget> createState() =>
      _SettingsEditProfileWidgetState();
}

class _SettingsEditProfileWidgetState
    extends ConsumerState<SettingsEditProfileWidget>
    with TickerProviderStateMixin {
  late SettingsEditProfileModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsEditProfileModel();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userData = ref.read(authProvider);
      // Load avatar URL as bytes
      if (userData.avatarUrl.isNotEmpty) {
        try {
          final response =
              await NetworkAssetBundle(Uri.parse(userData.avatarUrl))
                  .load(userData.avatarUrl);
          _model.image = response.buffer.asUint8List();
        } catch (_) {
          // Failed to load image, leave as null
        }
      }
      _model.username = userData.username;
      setState(() {});
    });

    final userData = ref.read(authProvider);
    _model.usernameTextController ??=
        TextEditingController(text: userData.username);
    _model.usernameFocusNode ??= FocusNode();
    _model.usernameFocusNode!.addListener(() => setState(() {}));
    _model.bioTextController ??= TextEditingController(text: userData.bio);
    _model.bioFocusNode ??= FocusNode();
    _model.bioFocusNode!.addListener(() => setState(() {}));
    _model.firstnameTextController ??=
        TextEditingController(text: userData.firstName);
    _model.firstnameFocusNode ??= FocusNode();
    _model.firstnameFocusNode!.addListener(() => setState(() {}));
    _model.lastnameTextController ??=
        TextEditingController(text: userData.lastName);
    _model.lastnameFocusNode ??= FocusNode();
    _model.lastnameFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    _model.image = bytes;
    if (!mounted) return;
    setState(() {});

    // Upload to storage
    _model.uploadToBucket = await actions.uploadImageToStorage(
      UploadedFile(bytes: _model.image, name: 'avatar.jpg'),
      'avatars',
      ref.read(currentUserIdProvider),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Public Profile',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 20.0),
                    child: Text(
                      'This info is visible to other users.',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        color: AppColors.textSecondary,
                        fontSize: 14.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 128.0,
                      height: 128.0,
                      child: Stack(
                        children: [
                          Container(
                            width: 128.0,
                            height: 128.0,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () async {
                                await _pickImage();
                              },
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
                                    return Center(
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
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
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
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Username',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.usernameTextController,
                        focusNode: _model.usernameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.usernameTextController',
                          Duration(milliseconds: 100),
                          () async {
                            _model.username =
                                _model.usernameTextController!.text;
                            _model.isUsernameEdited = true;
                            setState(() {});
                            _model.checkIsUsernameAvailable =
                                await actions.checkIsUsernameAvailable(
                              FormValidators.normalizeUsername(_model.username)
                                      .isNotEmpty
                                  ? FormValidators.normalizeUsername(
                                      _model.username)
                                  : 'a',
                            );
                            _model.usernameAvailable =
                                _model.checkIsUsernameAvailable!;
                            setState(() {});
                          },
                        ),
                        autofocus: false,
                        autofillHints: [AutofillHints.username],
                        obscureText: false,
                        decoration: appInputDecoration('Username'),
                        style: Theme.of(context).textTheme.bodyMedium!,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9_\-\.@!#\$%&\*]+'))
                        ],
                      ),
                    ),
                  ),
                  if (FormValidators.containsProfanity(
                          _model.usernameTextController!.text) &&
                      (_model.usernameTextController!.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'This username cannot be used.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  if ((FormValidators.usernameValidationResult(
                              _model.usernameTextController!.text) !=
                          'valid') &&
                      (_model.usernameTextController!.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        FormValidators.usernameValidationResult(
                            _model.usernameTextController!.text),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  if ((_model.usernameTextController!.text != '') &&
                      (FormValidators.usernameValidationResult(
                              _model.usernameTextController!.text) ==
                          'valid') &&
                      _model.isUsernameEdited)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _model.usernameAvailable
                                ? 'Available '
                                : 'Unavailable',
                            style: GoogleFonts.inter(
                              color: _model.usernameAvailable
                                  ? AppColors.statusSuccess
                                  : AppColors.destructive500,
                              fontSize: 12.0,
                            ),
                          ).animate().fade(duration: 600.ms),
                          if (_model.usernameAvailable)
                            Icon(
                              Icons.check,
                              color: AppColors.statusSuccess,
                              size: 20.0,
                            ),
                          if (!_model.usernameAvailable)
                            Icon(
                              Icons.error_outline,
                              color: AppColors.destructive500,
                              size: 20.0,
                            ),
                        ].divide(SizedBox(width: 4.0)),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Bio',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.bioTextController,
                        focusNode: _model.bioFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.bioTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          _model.lastnameFocusNode?.requestFocus();
                        },
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        decoration: appInputDecoration(
                          'Describe yourself or your collection focus',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium!,
                        maxLines: null,
                        minLines: 4,
                        maxLength: 500,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                maxLength}) =>
                            null,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                      ),
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Text(
                    'Private Account Details',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 20.0),
                    child: Text(
                      'For verification and security',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        color: AppColors.textSecondary,
                        fontSize: 14.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Text(
                    'First Name',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.firstnameTextController,
                        focusNode: _model.firstnameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.firstnameTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          _model.lastnameFocusNode?.requestFocus();
                        },
                        autofocus: false,
                        autofillHints: [AutofillHints.name],
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        decoration: appInputDecoration('First Name'),
                        style: Theme.of(context).textTheme.bodyMedium!,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('^[a-zA-Z]+( [a-zA-Z]+){0,2}'))
                        ],
                      ),
                    ),
                  ),
                  if (FormValidators.containsProfanity(
                          _model.firstnameTextController!.text) &&
                      (_model.firstnameTextController!.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'First name cannot be used.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Last Name',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.lastnameTextController,
                        focusNode: _model.lastnameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.lastnameTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          _model.usernameFocusNode?.requestFocus();
                        },
                        autofocus: false,
                        autofillHints: [AutofillHints.familyName],
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        decoration: appInputDecoration('Last Name'),
                        style: Theme.of(context).textTheme.bodyMedium!,
                        cursorColor: AppColors.textPrimary,
                        enableInteractiveSelection: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('^[a-zA-Z]+( [a-zA-Z]+){0,2}'))
                        ],
                      ),
                    ),
                  ),
                  if (FormValidators.containsProfanity(
                          _model.lastnameTextController!.text) &&
                      (_model.lastnameTextController!.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Last name cannot be used.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  Divider(
                    height: 56.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Builder(
                    builder: (context) {
                      final isFormValid =
                          (_model.firstnameTextController!.text != '') &&
                              (_model.lastnameTextController!.text != '') &&
                              (FormValidators.usernameValidationResult(
                                      _model.usernameTextController!.text) ==
                                  'valid') &&
                              _model.usernameAvailable;
                      return Container(
                        width: double.infinity,
                        height: 56.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isFormValid
                                  ? AppColors.brandPurple
                                  : AppColors.surfaceDark,
                              isFormValid
                                  ? AppColors.brandBlue
                                  : AppColors.surfaceDark,
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: TextButton(
                          onPressed: !isFormValid
                              ? null
                              : () async {
                                  await Future.wait([
                                    Future(() async {
                                      await UserProfilesTable().update(
                                        data: {
                                          'first_name': _model
                                              .firstnameTextController!.text,
                                          'last_name': _model
                                              .lastnameTextController!.text,
                                          'username':
                                              FormValidators.normalizeUsername(
                                                  _model.usernameTextController!
                                                      .text),
                                          'avatar_url': _model.uploadToBucket,
                                          'bio': _model.bioTextController!.text,
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'user_id',
                                          ref.read(currentUserIdProvider),
                                        ),
                                      );
                                    }),
                                    Future(() async {
                                      ref
                                          .read(authProvider.notifier)
                                          .updateUser((e) => e.copyWith(
                                                firstName: _model
                                                    .firstnameTextController!
                                                    .text,
                                                lastName: _model
                                                    .lastnameTextController!
                                                    .text,
                                                username: _model
                                                    .usernameTextController!
                                                    .text,
                                                bio: _model
                                                    .bioTextController!.text,
                                                avatarUrl:
                                                    _model.uploadToBucket ?? '',
                                              ));
                                      setState(() {});
                                    }),
                                  ]);
                                  if (context.mounted) context.pop();
                                },
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 56.0),
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: TextButton(
                      onPressed: () async {
                        context.pop();
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 56.0),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: AppColors.neutral800),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ]
                    .addToStart(SizedBox(height: 32.0))
                    .addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
