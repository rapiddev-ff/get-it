import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/presentation/pages/seller_dashboard/shortlist_create_step2/home_dashoard_shortlist_create_step2_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist/home_dashoard_shortlist_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeDashoardShortlistCreateWidget extends StatefulWidget {
  const HomeDashoardShortlistCreateWidget({
    super.key,
    this.shortlistId,
    this.initialName,
    this.initialEventName,
    this.initialStartDate,
    this.initialEndDate,
    this.initialIsPublic = true,
  });

  /// If editing an existing shortlist, pass its ID.
  final String? shortlistId;
  final String? initialName;
  final String? initialEventName;
  final String? initialStartDate;
  final String? initialEndDate;
  final bool initialIsPublic;

  static const String routeName = 'homeDashoardShortlistCreate';
  static const String routePath = 'homeDashoardShortlistCreate';

  bool get isEditing => shortlistId != null;

  @override
  State<HomeDashoardShortlistCreateWidget> createState() =>
      _HomeDashoardShortlistCreateWidgetState();
}

class _HomeDashoardShortlistCreateWidgetState
    extends State<HomeDashoardShortlistCreateWidget> {
  String state = 'Shop';
  bool isPublic = true;
  bool _isSaving = false;

  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    textController1 = TextEditingController(text: widget.initialName ?? '');
    textFieldFocusNode1 = FocusNode();
    textController2 = TextEditingController(text: widget.initialEventName ?? '');
    textFieldFocusNode2 = FocusNode();
    isPublic = widget.initialIsPublic;

    // Parse initial dates if provided (MM/dd/yyyy format)
    if (widget.initialStartDate != null &&
        widget.initialStartDate!.isNotEmpty) {
      _startDate = _parseDateString(widget.initialStartDate!);
    }
    if (widget.initialEndDate != null && widget.initialEndDate!.isNotEmpty) {
      _endDate = _parseDateString(widget.initialEndDate!);
    }
  }

  DateTime? _parseDateString(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        return DateTime(
            int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
      }
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    textController1?.dispose();
    textFieldFocusNode1?.dispose();
    textController2?.dispose();
    textFieldFocusNode2?.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MM/dd/yyyy').format(date);
  }

  bool _validateForm() {
    if (textController1!.text.trim().isEmpty) {
      actions.toastificationshow(
        context, 'Missing Name', 'Please enter a shortlist name.', 'error');
      return false;
    }
    if (_startDate == null) {
      actions.toastificationshow(
        context, 'Missing Date', 'Please select a start date.', 'error');
      return false;
    }
    if (_endDate == null) {
      actions.toastificationshow(
        context, 'Missing Date', 'Please select an end date.', 'error');
      return false;
    }
    if (_endDate!.isBefore(_startDate!)) {
      actions.toastificationshow(
        context, 'Invalid Dates', 'End date must be on or after start date.', 'error');
      return false;
    }
    return true;
  }

  void _showDatePicker({required bool isStartDate}) {
    DateTime tempDate = (isStartDate ? _startDate : _endDate) ?? DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: AppColors.backgroundSecondary,
        child: Column(
          children: [
            Container(
              color: AppColors.backgroundSecondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge!,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text(
                      'Done',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isStartDate) {
                          _startDate = tempDate;
                        } else {
                          _endDate = tempDate;
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: tempDate,
                minimumDate: DateTime(2020),
                maximumDate: DateTime(2030, 12, 31),
                onDateTimeChanged: (date) => tempDate = date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Text(
                  widget.isEditing ? 'Edit Shortlist' : 'Create Shortlist',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shortlist Name',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15.0, height: 1.5),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: textController1,
                          focusNode: textFieldFocusNode1,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController1',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          enabled: true,
                          obscureText: false,
                          decoration:
                              appInputDecoration('e.g., Comic Con 2025'),
                          style: appTextFieldStyle,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text(
                        'Event/Convention',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 15.0, height: 1.5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: textController2,
                          focusNode: textFieldFocusNode2,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController2',
                            Duration(milliseconds: 100),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          enabled: true,
                          obscureText: false,
                          decoration:
                              appInputDecoration('e.g., San Diego Comc Con'),
                          style: appTextFieldStyle,
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 15.0, height: 1.5),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      _showDatePicker(isStartDate: true),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color: AppColors.neutral700,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      _startDate != null
                                          ? _formatDate(_startDate)
                                          : 'MM/DD/YYYY',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.0,
                                        color: _startDate != null
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End Date',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 15.0, height: 1.5),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      _showDatePicker(isStartDate: false),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color: AppColors.neutral700,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      _endDate != null
                                          ? _formatDate(_endDate)
                                          : 'MM/DD/YYYY',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.0,
                                        color: _endDate != null
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                    Divider(
                      height: 48.0,
                      thickness: 1.0,
                      color: AppColors.surfaceDark,
                    ),
                    Text(
                      'Privacy Settings',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15.0, height: 1.5),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: () => setState(() => isPublic = !isPublic),
                        child: Row(
                          children: [
                            if (!isPublic)
                              Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: AppColors.neutral700,
                                  ),
                                ),
                              ),
                            if (isPublic)
                              Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: AppColors.neutral700,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check_sharp,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                'Allow public viewing',
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0)
              Column(
                children: [
                  AppGradientButton(
                    text: widget.isEditing ? 'Save & Continue' : 'Create Shortlist',
                    onPressed: () {
                      if (!_validateForm()) return;
                      final params = {
                        'name': textController1!.text,
                        'eventName': textController2!.text,
                        'startDate': _formatDate(_startDate),
                        'endDate': _formatDate(_endDate),
                        'isPublic': isPublic.toString(),
                      };
                      if (widget.shortlistId != null) {
                        params['shortlistId'] = widget.shortlistId!;
                      }
                      context.pushNamed(
                        HomeDashoardShortlistCreateStep2Widget.routeName,
                        queryParameters: params,
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: TextButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (!_validateForm()) return;
                              setState(() => _isSaving = true);
                              final result = await actions.createShortlist(
                                name: textController1!.text,
                                eventName: textController2!.text,
                                startDate: _formatDate(_startDate),
                                endDate: _formatDate(_endDate),
                                isPublic: isPublic,
                                status: 'draft',
                              );
                              if (!mounted) return;
                              setState(() => _isSaving = false);
                              actions.toastificationshow(
                                context,
                                result['title'] ?? '',
                                result['message'] ?? '',
                                result['success'] == true ? 'success' : 'error',
                              );
                              if (result['success'] == true) {
                                context.goNamed(
                                    HomeDashoardShortlistWidget.routeName);
                              }
                            },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 56.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: AppColors.neutral800),
                        ),
                      ),
                      child: Text(
                        _isSaving ? 'Saving...' : 'Move to Drafts',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ]
                .addToStart(SizedBox(height: 24.0))
                .addToEnd(SizedBox(height: 32.0)),
          ),
        ),
        ),
      ),
    );
  }
}
