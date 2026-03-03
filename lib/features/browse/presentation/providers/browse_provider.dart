import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/backend/schema/structs/index.dart';

final _secureStorage = FlutterSecureStorage();

// --- categories (persisted) ---

class CategoriesNotifier extends AsyncNotifier<List<CategoryStruct>> {
  @override
  Future<List<CategoryStruct>> build() async {
    return _readFromStorage();
  }

  Future<List<CategoryStruct>> _readFromStorage() async {
    final raw = await _secureStorage.read(key: 'ff_categories');
    if (raw == null || raw.isEmpty) return [];
    return CsvToListConverter()
        .convert(raw)
        .first
        .map((e) {
          try {
            return CategoryStruct.fromSerializableMap(jsonDecode(e.toString()));
          } catch (_) {
            return null;
          }
        })
        .whereType<CategoryStruct>()
        .toList();
  }

  Future<void> _persist(List<CategoryStruct> list) async {
    final csv = ListToCsvConverter().convert([
      list.map((x) => x.serialize()).toList(),
    ]);
    await _secureStorage.write(key: 'ff_categories', value: csv);
  }

  Future<void> set(List<CategoryStruct> categories) async {
    await _persist(categories);
    state = AsyncData(categories);
  }

  Future<void> add(CategoryStruct category) async {
    final current = state.valueOrNull ?? [];
    final updated = [...current, category];
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> remove(CategoryStruct category) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((c) => c != category).toList();
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> removeAtIndex(int index) async {
    final current = [...(state.valueOrNull ?? [])]..removeAt(index);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> updateAtIndex(
    int index,
    CategoryStruct Function(CategoryStruct) updateFn,
  ) async {
    final current = [...(state.valueOrNull ?? [])];
    current[index] = updateFn(current[index]);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> insertAtIndex(int index, CategoryStruct category) async {
    final current = [...(state.valueOrNull ?? [])]..insert(index, category);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_categories');
    state = const AsyncData([]);
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<CategoryStruct>>(
  CategoriesNotifier.new,
);

// --- conditions (persisted) ---

class ConditionsNotifier extends AsyncNotifier<List<ConditionStruct>> {
  @override
  Future<List<ConditionStruct>> build() async {
    return _readFromStorage();
  }

  Future<List<ConditionStruct>> _readFromStorage() async {
    final raw = await _secureStorage.read(key: 'ff_conditions');
    if (raw == null || raw.isEmpty) return [];
    return CsvToListConverter()
        .convert(raw)
        .first
        .map((e) {
          try {
            return ConditionStruct.fromSerializableMap(
                jsonDecode(e.toString()));
          } catch (_) {
            return null;
          }
        })
        .whereType<ConditionStruct>()
        .toList();
  }

  Future<void> _persist(List<ConditionStruct> list) async {
    final csv = ListToCsvConverter().convert([
      list.map((x) => x.serialize()).toList(),
    ]);
    await _secureStorage.write(key: 'ff_conditions', value: csv);
  }

  Future<void> set(List<ConditionStruct> conditions) async {
    await _persist(conditions);
    state = AsyncData(conditions);
  }

  Future<void> add(ConditionStruct condition) async {
    final current = state.valueOrNull ?? [];
    final updated = [...current, condition];
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> remove(ConditionStruct condition) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((c) => c != condition).toList();
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> removeAtIndex(int index) async {
    final current = [...(state.valueOrNull ?? [])]..removeAt(index);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> updateAtIndex(
    int index,
    ConditionStruct Function(ConditionStruct) updateFn,
  ) async {
    final current = [...(state.valueOrNull ?? [])];
    current[index] = updateFn(current[index]);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> insertAtIndex(int index, ConditionStruct condition) async {
    final current = [...(state.valueOrNull ?? [])]..insert(index, condition);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_conditions');
    state = const AsyncData([]);
  }
}

final conditionsProvider =
    AsyncNotifierProvider<ConditionsNotifier, List<ConditionStruct>>(
  ConditionsNotifier.new,
);

// --- choosenTags (in-memory only) ---

class ChoosenTagsNotifier extends Notifier<List<TagStruct>> {
  @override
  List<TagStruct> build() => [];

  void set(List<TagStruct> tags) {
    state = tags;
  }

  void add(TagStruct tag) {
    state = [...state, tag];
  }

  void remove(TagStruct tag) {
    state = state.where((t) => t != tag).toList();
  }

  void removeAtIndex(int index) {
    state = [...state]..removeAt(index);
  }

  void updateAtIndex(
    int index,
    TagStruct Function(TagStruct) updateFn,
  ) {
    final list = [...state];
    list[index] = updateFn(list[index]);
    state = list;
  }

  void insertAtIndex(int index, TagStruct tag) {
    state = [...state]..insert(index, tag);
  }

  void clear() {
    state = [];
  }
}

final choosenTagsProvider =
    NotifierProvider<ChoosenTagsNotifier, List<TagStruct>>(
  ChoosenTagsNotifier.new,
);
