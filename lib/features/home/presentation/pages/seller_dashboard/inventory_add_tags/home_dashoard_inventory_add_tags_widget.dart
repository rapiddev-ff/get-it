import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:go_router/go_router.dart';

import '/features/browse/domain/models/tag_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';

class HomeDashoardInventoryAddTagsWidget extends StatefulWidget {
  const HomeDashoardInventoryAddTagsWidget({super.key});

  static String routeName = 'homeDashoardInventoryAddTags';
  static String routePath = 'homeDashoardInventoryAddTags';

  @override
  State<HomeDashoardInventoryAddTagsWidget> createState() =>
      _HomeDashoardInventoryAddTagsWidgetState();
}

class _HomeDashoardInventoryAddTagsWidgetState
    extends State<HomeDashoardInventoryAddTagsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.backgroundPrimary,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.0),
              child: AppBar(
                backgroundColor: AppColors.backgroundSecondary,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.info,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pop();
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
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
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
                actions: [],
                centerTitle: true,
                elevation: 0.0,
              ),
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
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
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 24.0),
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
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
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
                                            begin:
                                                AlignmentDirectional(0.0, -1.0),
                                            end: AlignmentDirectional(0, 1.0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 2.0, 12.0, 4.0),
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              context.pop();
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 56.0),
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
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
                          child: Container(
                            width: double.infinity,
                            height: 56.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                                stops: [0.0, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                // TODO: choosenTags will be handled via provider later
                                context.pop();
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size(double.infinity, 40.0),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                backgroundColor: Color(0x008E6CFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                'Apply',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
