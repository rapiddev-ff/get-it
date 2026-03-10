import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';

import '/features/browse/domain/models/tag_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';

class HomeDashoardInventoryAddTagsWidget extends StatefulWidget {
  const HomeDashoardInventoryAddTagsWidget({
    super.key,
    this.initialTags,
  });

  final List<Tag>? initialTags;

  static String routeName = 'homeDashoardInventoryAddTags';
  static String routePath = 'homeDashoardInventoryAddTags';

  @override
  State<HomeDashoardInventoryAddTagsWidget> createState() =>
      _HomeDashoardInventoryAddTagsWidgetState();
}

class _HomeDashoardInventoryAddTagsWidgetState
    extends State<HomeDashoardInventoryAddTagsWidget> {
  // Inlined model state
  List<Tag> tags = [];
  Stream<List<TagsRow>>? homeDashoardInventoryAddTagsSupabaseStream;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  void addToTags(Tag item) {
    tags.add(item);
  }

  void removeFromTags(Tag item) {
    tags.remove(item);
  }

  /// Inline replacement for functions.searchTags
  List<TagsRow>? _searchTags(String? searchingText, List<TagsRow>? allTags) {
    if (allTags == null) return null;
    if (searchingText == null || searchingText.isEmpty) return allTags;
    final query = searchingText.toLowerCase();
    return allTags
        .where((tag) => tag.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialTags != null) {
      tags = List<Tag>.from(widget.initialTags!);
    }

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    textFieldFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TagsRow>>(
      stream: homeDashoardInventoryAddTagsSupabaseStream ??= SupaFlow.client
          .from("tags")
          .stream(primaryKey: ['id']).map(
              (list) => list.map((item) => TagsRow(item)).toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<TagsRow> homeDashoardInventoryAddTagsTagsRowList = snapshot.data!;

        return DismissKeyboard(
          child: Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.0),
              child: AppBar(
                backgroundColor: AppColors.backgroundSecondary,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.info,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context, null);
                      },
                    ),
                    Text(
                      'Add a Product',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        tags = [];
                        setState(() {});
                      },
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Search tags',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  color: AppColors.textSecondary,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                prefixIcon: Icon(
                                  Icons.search_sharp,
                                  color: AppColors.textPrimary,
                                  size: 24.0,
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: AppColors.textPrimary,
                              ),
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Builder(
                              builder: (context) {
                                final tagsList = _searchTags(
                                            textController!.text,
                                            homeDashoardInventoryAddTagsTagsRowList
                                                .toList())
                                        ?.toList() ??
                                    [];

                                return Wrap(
                                  spacing: 12.0,
                                  runSpacing: 12.0,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.horizontal,
                                  runAlignment: WrapAlignment.start,
                                  verticalDirection: VerticalDirection.down,
                                  clipBehavior: Clip.none,
                                  children: List.generate(tagsList.length,
                                      (tagsListIndex) {
                                    final tagsListItem =
                                        tagsList[tagsListIndex];
                                    return InkWell(
                                      onTap: () async {
                                        if (tags.contains(Tag(
                                          id: tagsListItem.id,
                                          name: tagsListItem.name,
                                          slug: tagsListItem.slug,
                                        ))) {
                                          removeFromTags(Tag(
                                            id: tagsListItem.id,
                                            name: tagsListItem.name,
                                            slug: tagsListItem.slug,
                                          ));
                                          setState(() {});
                                        } else {
                                          addToTags(Tag(
                                            id: tagsListItem.id,
                                            name: tagsListItem.name,
                                            slug: tagsListItem.slug,
                                          ));
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              tags.contains(Tag(
                                                id: tagsListItem.id,
                                                name: tagsListItem.name,
                                                slug: tagsListItem.slug,
                                              ))
                                                  ? Color(0xFF7D56FF)
                                                  : Color(0xFF252525),
                                              tags.contains(Tag(
                                                id: tagsListItem.id,
                                                name: tagsListItem.name,
                                                slug: tagsListItem.slug,
                                              ))
                                                  ? Color(0xFF6187F1)
                                                  : Color(0xFF252525),
                                            ],
                                            stops: [0.0, 1.0],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 12.0,
                                              top: 2.0,
                                              right: 12.0,
                                              bottom: 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                tagsListItem.name,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.0,
                                                  color: AppColors.textPrimary,
                                                  height: 1.5,
                                                ),
                                              ),
                                              if (tags.contains(Tag(
                                                id: tagsListItem.id,
                                                name: tagsListItem.name,
                                                slug: tagsListItem.slug,
                                              )))
                                                Icon(
                                                  Icons.close,
                                                  color: AppColors.textPrimary,
                                                  size: 12.0,
                                                ),
                                            ].divide(SizedBox(width: 4.0)),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.pop(context, null);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 56.0),
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              backgroundColor: AppColors.backgroundPrimary,
                              side: BorderSide(color: Color(0xFF545454)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AppGradientButton(
                            text: 'Apply',
                            onPressed: () async {
                              Navigator.pop(context, tags);
                            },
                          ),
                        ),
                      ].divide(SizedBox(width: 16.0)),
                    ),
                  ),
                ]
                    .addToStart(SizedBox(height: 24.0))
                    .addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}
