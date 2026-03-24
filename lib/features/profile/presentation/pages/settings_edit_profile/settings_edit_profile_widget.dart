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
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class SettingsEditProfileWidget extends ConsumerStatefulWidget {
  const SettingsEditProfileWidget({super.key});

  static const String routeName = 'settingsEditProfile';
  static const String routePath = 'settingsEditProfile';

  @override
  ConsumerState<SettingsEditProfileWidget> createState() =>
      _SettingsEditProfileWidgetState();
}

class _SettingsEditProfileWidgetState
    extends ConsumerState<SettingsEditProfileWidget>
    with TickerProviderStateMixin {
  // Local state fields
  Uint8List? image;
  String? username;
  bool usernameAvailable = true;
  bool isUsernameEdited = false;

  // Action output results
  String? uploadToBucket;
  bool? checkIsUsernameAvailable;

  // Text controllers and focus nodes
  late final TextEditingController usernameTextController;
  late final FocusNode usernameFocusNode;
  late final TextEditingController bioTextController;
  late final FocusNode bioFocusNode;
  late final TextEditingController firstnameTextController;
  late final FocusNode firstnameFocusNode;
  late final TextEditingController lastnameTextController;
  late final FocusNode lastnameFocusNode;

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userData = ref.read(authProvider);
      // Load avatar URL as bytes
      if (userData.avatarUrl.isNotEmpty) {
        try {
          final response =
              await NetworkAssetBundle(Uri.parse(userData.avatarUrl))
                  .load(userData.avatarUrl);
          image = response.buffer.asUint8List();
        } catch (_) {
          // Failed to load image, leave as null
        }
      }
      username = userData.username;
      if (!mounted) return;
      setState(() {});
    });

    final userData = ref.read(authProvider);
    usernameTextController = TextEditingController(text: userData.username);
    usernameFocusNode = FocusNode();    bioTextController = TextEditingController(text: userData.bio);
    bioFocusNode = FocusNode();    firstnameTextController = TextEditingController(text: userData.firstName);
    firstnameFocusNode = FocusNode();    lastnameTextController = TextEditingController(text: userData.lastName);
    lastnameFocusNode = FocusNode();  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    usernameFocusNode.dispose();
    usernameTextController.dispose();
    bioFocusNode.dispose();
    bioTextController.dispose();
    firstnameFocusNode.dispose();
    firstnameTextController.dispose();
    lastnameFocusNode.dispose();
    lastnameTextController.dispose();
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
    image = bytes;
    if (!mounted) return;
    setState(() {});

    // Upload to storage
    uploadToBucket = await actions.uploadImageToStorage(
      UploadedFile(bytes: image, name: 'avatar.jpg'),
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
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 20.0),
                    child: Text(
                      'This info is visible to other users.',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(height: 1.5),
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
                                  if (image != null && image!.isNotEmpty) {
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
                                    return Center(
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: usernameTextController,
                        focusNode: usernameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'usernameTextController',
                          Duration(milliseconds: 100),
                          () async {
                            username = usernameTextController.text;
                            isUsernameEdited = true;
                            setState(() {});
                            checkIsUsernameAvailable =
                                await actions.checkIsUsernameAvailable(
                              FormValidators.normalizeUsername(username)
                                      .isNotEmpty
                                  ? FormValidators.normalizeUsername(username)
                                  : 'a',
                            );
                            usernameAvailable = checkIsUsernameAvailable!;
                            if (!mounted) return;
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
                          usernameTextController.text) &&
                      (usernameTextController.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'This username cannot be used.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  if ((FormValidators.usernameValidationResult(
                              usernameTextController.text) !=
                          'valid') &&
                      (usernameTextController.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        FormValidators.usernameValidationResult(
                            usernameTextController.text),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  if ((usernameTextController.text != '') &&
                      (FormValidators.usernameValidationResult(
                              usernameTextController.text) ==
                          'valid') &&
                      isUsernameEdited)
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            usernameAvailable ? 'Available ' : 'Unavailable',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: usernameAvailable
                                          ? AppColors.statusSuccess
                                          : AppColors.destructive500,
                                    ),
                          ).animate().fade(duration: 600.ms),
                          if (usernameAvailable)
                            Icon(
                              Icons.check,
                              color: AppColors.statusSuccess,
                              size: 20.0,
                            ),
                          if (!usernameAvailable)
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: bioTextController,
                        focusNode: bioFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'bioTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          lastnameFocusNode.requestFocus();
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 20.0),
                    child: Text(
                      'For verification and security',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(height: 1.5),
                    ),
                  ),
                  Text(
                    'First Name',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500, height: 1.4),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: firstnameTextController,
                        focusNode: firstnameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'firstnameTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          lastnameFocusNode.requestFocus();
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
                          firstnameTextController.text) &&
                      (firstnameTextController.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'First name cannot be used.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.error),
                      ).animate().fade(duration: 600.ms),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Last Name',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: lastnameTextController,
                        focusNode: lastnameFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'lastnameTextController',
                          Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        onFieldSubmitted: (_) async {
                          usernameFocusNode.requestFocus();
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
                          lastnameTextController.text) &&
                      (lastnameTextController.text != ''))
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Last name cannot be used.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: AppColors.error),
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
                          (firstnameTextController.text != '') &&
                              (lastnameTextController.text != '') &&
                              (FormValidators.usernameValidationResult(
                                      usernameTextController.text) ==
                                  'valid') &&
                              usernameAvailable;
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
                                          'first_name':
                                              firstnameTextController.text,
                                          'last_name':
                                              lastnameTextController.text,
                                          'username':
                                              FormValidators.normalizeUsername(
                                                  usernameTextController.text),
                                          'avatar_url': uploadToBucket,
                                          'bio': bioTextController.text,
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
                                                firstName:
                                                    firstnameTextController
                                                        .text,
                                                lastName:
                                                    lastnameTextController.text,
                                                username:
                                                    usernameTextController.text,
                                                bio: bioTextController.text,
                                                avatarUrl: uploadToBucket ?? '',
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                            color: Colors.white),
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
