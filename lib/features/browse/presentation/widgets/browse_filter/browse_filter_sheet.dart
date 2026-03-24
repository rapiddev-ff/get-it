import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';


/// Filter state passed to/from the bottom sheet.
class BrowseFilterState {
  final Map<String, Set<String>> selectedSubcategoryIds; // categoryId → set of subcategoryIds
  final Set<String> selectedCategoryIds;
  final Set<String> selectedConditionIds;
  final Set<String> selectedTagIds;
  final double? priceMin;
  final double? priceMax;
  final int? year;

  const BrowseFilterState({
    this.selectedCategoryIds = const {},
    this.selectedSubcategoryIds = const {},
    this.selectedConditionIds = const {},
    this.selectedTagIds = const {},
    this.priceMin,
    this.priceMax,
    this.year,
  });

  int get activeFilterCount {
    int count = 0;
    if (selectedCategoryIds.isNotEmpty) count++;
    if (selectedSubcategoryIds.values.any((s) => s.isNotEmpty)) count++;
    if (selectedConditionIds.isNotEmpty) count++;
    if (selectedTagIds.isNotEmpty) count++;
    if (priceMin != null || priceMax != null) count++;
    if (year != null) count++;
    return count;
  }

  bool get isEmpty => activeFilterCount == 0;

  List<String> get allSubcategoryIds =>
      selectedSubcategoryIds.values.expand((s) => s).toList();

  BrowseFilterState copyWith({
    Set<String>? selectedCategoryIds,
    Map<String, Set<String>>? selectedSubcategoryIds,
    Set<String>? selectedConditionIds,
    Set<String>? selectedTagIds,
    double? Function()? priceMin,
    double? Function()? priceMax,
    int? Function()? year,
  }) {
    return BrowseFilterState(
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      selectedSubcategoryIds:
          selectedSubcategoryIds ?? this.selectedSubcategoryIds,
      selectedConditionIds: selectedConditionIds ?? this.selectedConditionIds,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      priceMin: priceMin != null ? priceMin() : this.priceMin,
      priceMax: priceMax != null ? priceMax() : this.priceMax,
      year: year != null ? year() : this.year,
    );
  }
}

/// Shows the filter bottom sheet. Returns the updated filter state or null if cancelled.
Future<BrowseFilterState?> showBrowseFilterSheet(
  BuildContext context,
  BrowseFilterState current,
) {
  return showModalBottomSheet<BrowseFilterState>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (ctx) => _BrowseFilterSheet(initial: current),
  );
}

class _BrowseFilterSheet extends StatefulWidget {
  final BrowseFilterState initial;
  const _BrowseFilterSheet({required this.initial});

  @override
  State<_BrowseFilterSheet> createState() => _BrowseFilterSheetState();
}

class _BrowseFilterSheetState extends State<_BrowseFilterSheet> {
  late Set<String> _categoryIds;
  late Map<String, Set<String>> _subcategoryIds;
  late Set<String> _conditionIds;
  late Set<String> _tagIds;
  final _priceMinController = TextEditingController();
  final _priceMaxController = TextEditingController();
  final _yearController = TextEditingController();

  // Data from Supabase
  List<Map<String, dynamic>> _categories = [];
  Map<String, List<Map<String, dynamic>>> _subcategoriesByCategory = {};
  List<Map<String, dynamic>> _conditions = [];
  List<Map<String, dynamic>> _tags = [];
  bool _isLoadingData = true;

  // Expand state
  String? _expandedCategoryId;

  @override
  void initState() {
    super.initState();
    _categoryIds = Set.from(widget.initial.selectedCategoryIds);
    _subcategoryIds = {
      for (final e in widget.initial.selectedSubcategoryIds.entries)
        e.key: Set.from(e.value),
    };
    _conditionIds = Set.from(widget.initial.selectedConditionIds);
    _tagIds = Set.from(widget.initial.selectedTagIds);
    if (widget.initial.priceMin != null) {
      _priceMinController.text =
          NumberFormat('#,##0.##', 'en_US').format(widget.initial.priceMin);
    }
    if (widget.initial.priceMax != null) {
      _priceMaxController.text =
          NumberFormat('#,##0.##', 'en_US').format(widget.initial.priceMax);
    }
    if (widget.initial.year != null) {
      _yearController.text = widget.initial.year.toString();
    }
    _loadFilterData();
  }

  @override
  void dispose() {
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final results = await Future.wait([
        SupaFlow.client
            .from('categories')
            .select('id, name, slug, sort_order')
            .eq('is_active', true)
            .isFilter('deleted_at', null)
            .order('sort_order', ascending: true),
        SupaFlow.client
            .from('subcategories')
            .select('id, name, category_id, sort_order')
            .eq('is_active', true)
            .isFilter('deleted_at', null)
            .order('sort_order', ascending: true),
        SupaFlow.client
            .from('conditions')
            .select('id, name, code, category_id, sort_order')
            .order('sort_order', ascending: true),
        SupaFlow.client
            .from('tags')
            .select('id, name, slug, category_id')
            .order('name', ascending: true),
      ]);

      if (!mounted) return;

      final categories = List<Map<String, dynamic>>.from(results[0] as List);
      final subcategories = List<Map<String, dynamic>>.from(results[1] as List);
      final conditions = List<Map<String, dynamic>>.from(results[2] as List);
      final tags = List<Map<String, dynamic>>.from(results[3] as List);

      final subcatMap = <String, List<Map<String, dynamic>>>{};
      for (final sub in subcategories) {
        final catId = sub['category_id']?.toString() ?? '';
        subcatMap.putIfAbsent(catId, () => []).add(sub);
      }

      setState(() {
        _categories = categories;
        _subcategoriesByCategory = subcatMap;
        _conditions = conditions;
        _tags = tags;
        _isLoadingData = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingData = false);
    }
  }

  List<Map<String, dynamic>> get _filteredConditions {
    List<Map<String, dynamic>> source;
    if (_categoryIds.isEmpty) {
      source = _conditions;
    } else {
      source = _conditions.where((c) {
        final catId = c['category_id']?.toString();
        return catId == null || _categoryIds.contains(catId);
      }).toList();
    }
    // Deduplicate by name, keep first occurrence
    final seen = <String>{};
    return source.where((c) {
      final name = c['name']?.toString() ?? '';
      if (seen.contains(name)) return false;
      seen.add(name);
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredTags {
    List<Map<String, dynamic>> source;
    if (_categoryIds.isEmpty) {
      source = _tags;
    } else {
      source = _tags.where((t) {
        final catId = t['category_id']?.toString();
        return catId == null || _categoryIds.contains(catId);
      }).toList();
    }
    // Deduplicate by name
    final seen = <String>{};
    return source.where((t) {
      final name = t['name']?.toString() ?? '';
      if (seen.contains(name)) return false;
      seen.add(name);
      return true;
    }).toList();
  }

  double? _parsePrice(String text) {
    if (text.trim().isEmpty) return null;
    final cleaned = text.replaceAll(',', '');
    return double.tryParse(cleaned);
  }

  int? _parseYear(String text) {
    if (text.trim().isEmpty) return null;
    return int.tryParse(text.trim());
  }

  void _apply() {
    Navigator.pop(
      context,
      BrowseFilterState(
        selectedCategoryIds: _categoryIds,
        selectedSubcategoryIds: _subcategoryIds,
        selectedConditionIds: _conditionIds,
        selectedTagIds: _tagIds,
        priceMin: _parsePrice(_priceMinController.text),
        priceMax: _parsePrice(_priceMaxController.text),
        year: _parseYear(_yearController.text),
      ),
    );
  }

  void _reset() {
    setState(() {
      _categoryIds.clear();
      _subcategoryIds.clear();
      _conditionIds.clear();
      _tagIds.clear();
      _priceMinController.clear();
      _priceMaxController.clear();
      _yearController.clear();
      _expandedCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.0),
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: AppColors.neutral700,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    'Reset',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  'Filters',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: _apply,
                  child: Text(
                    'Apply',
                    style: GoogleFonts.inter(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.0, color: AppColors.surfaceDark),
          // Content
          Expanded(
            child: _isLoadingData
                ? Center(
                    child: CircularProgressIndicator(
                        color: AppColors.secondary, strokeWidth: 2.0))
                : SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 16.0 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories + Subcategories
                        _buildSectionLabel('Category'),
                        SizedBox(height: 8.0),
                        ..._categories.map(_buildCategoryTile),
                        SizedBox(height: 24.0),
                        // Conditions
                        _buildSectionLabel('Condition'),
                        SizedBox(height: 8.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children:
                              _filteredConditions.map(_buildConditionChip).toList(),
                        ),
                        SizedBox(height: 24.0),
                        // Tags
                        if (_filteredTags.isNotEmpty) ...[
                          _buildSectionLabel('Tags'),
                          SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children:
                                _filteredTags.take(30).map(_buildTagChip).toList(),
                          ),
                          SizedBox(height: 24.0),
                        ],
                        // Price Range
                        _buildSectionLabel('Price Range'),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(child: _buildPriceField(_priceMinController, 'Min')),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text('–',
                                  style: Theme.of(context).textTheme.titleMedium!),
                            ),
                            Expanded(child: _buildPriceField(_priceMaxController, 'Max')),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        // Year
                        _buildSectionLabel('Year'),
                        SizedBox(height: 8.0),
                        SizedBox(
                          width: 120.0,
                          child: TextFormField(
                            controller: _yearController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('e.g. 2024'),
                            style: Theme.of(context).textTheme.bodyMedium!,
                            cursorColor: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 32.0),
                      ],
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
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildCategoryTile(Map<String, dynamic> category) {
    final catId = category['id'].toString();
    final catName = category['name']?.toString() ?? '';
    final isSelected = _categoryIds.contains(catId);
    final isExpanded = _expandedCategoryId == catId;
    final subcats = _subcategoriesByCategory[catId] ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _categoryIds.remove(catId);
                _subcategoryIds.remove(catId);
                if (_expandedCategoryId == catId) _expandedCategoryId = null;
              } else {
                _categoryIds.add(catId);
                if (subcats.isNotEmpty) _expandedCategoryId = catId;
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.textSecondary,
                  size: 22.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    catName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                  ),
                ),
                if (subcats.isNotEmpty && isSelected)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expandedCategoryId = isExpanded ? null : catId;
                      });
                    },
                    child: Icon(
                      isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: AppColors.textSecondary,
                      size: 22.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Subcategories (expanded)
        if (isSelected && isExpanded && subcats.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: 34.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: subcats.map((sub) {
                final subId = sub['id'].toString();
                final subName = sub['name']?.toString() ?? '';
                final subSelected =
                    _subcategoryIds[catId]?.contains(subId) ?? false;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _subcategoryIds.putIfAbsent(catId, () => {});
                      if (subSelected) {
                        _subcategoryIds[catId]!.remove(subId);
                      } else {
                        _subcategoryIds[catId]!.add(subId);
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          subSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: subSelected
                              ? AppColors.secondary
                              : AppColors.textSecondary,
                          size: 20.0,
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            subName,
                            style:
                                Theme.of(context).textTheme.bodySmall!,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  /// Returns all condition IDs that share the same name.
  Set<String> _allConditionIdsForName(String name) {
    return _conditions
        .where((c) => c['name']?.toString() == name)
        .map((c) => c['id'].toString())
        .toSet();
  }

  Widget _buildConditionChip(Map<String, dynamic> condition) {
    final condName = condition['name']?.toString() ?? '';
    final allIds = _allConditionIdsForName(condName);
    final isSelected = allIds.any((id) => _conditionIds.contains(id));
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _conditionIds.removeAll(allIds);
          } else {
            _conditionIds.addAll(allIds);
          }
        });
      },
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.secondary, AppColors.brandBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isSelected ? null : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Text(
            condName,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(Map<String, dynamic> tag) {
    final tagId = tag['id'].toString();
    final tagName = tag['name']?.toString() ?? '';
    final isSelected = _tagIds.contains(tagId);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _tagIds.remove(tagId);
          } else {
            _tagIds.add(tagId);
          }
        });
      },
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.secondary, AppColors.brandBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isSelected ? null : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Text(
            tagName,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: _inputDecoration('\$$hint'),
      style: Theme.of(context).textTheme.bodyMedium!,
      cursorColor: AppColors.textPrimary,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.labelMedium!,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
        borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
        borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      ),
    );
  }
}
