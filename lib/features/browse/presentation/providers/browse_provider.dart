import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/features/browse/domain/models/tag_model.dart';

final _secureStorage = FlutterSecureStorage();

// --- categories (persisted) ---

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    return _readFromStorage();
  }

  Future<List<Category>> _readFromStorage() async {
    final raw = await _secureStorage.read(key: 'ff_categories');
    if (raw == null || raw.isEmpty) return [];
    return CsvToListConverter()
        .convert(raw)
        .first
        .map((e) {
          try {
            return Category.fromJson(jsonDecode(e.toString()));
          } catch (_) {
            return null;
          }
        })
        .whereType<Category>()
        .toList();
  }

  Future<void> _persist(List<Category> list) async {
    final csv = ListToCsvConverter().convert([
      list.map((x) => x.serialize()).toList(),
    ]);
    await _secureStorage.write(key: 'ff_categories', value: csv);
  }

  Future<void> set(List<Category> categories) async {
    await _persist(categories);
    state = AsyncData(categories);
  }

  Future<void> add(Category category) async {
    final current = state.valueOrNull ?? [];
    final updated = [...current, category];
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> remove(Category category) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((c) => c != category).toList();
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> removeAtIndex(int index) async {
    final current = <Category>[...(state.valueOrNull ?? [])]..removeAt(index);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> updateAtIndex(
    int index,
    Category Function(Category) updateFn,
  ) async {
    final current = <Category>[...(state.valueOrNull ?? [])];
    current[index] = updateFn(current[index]);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> insertAtIndex(int index, Category category) async {
    final current = <Category>[...(state.valueOrNull ?? [])]
      ..insert(index, category);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_categories');
    state = const AsyncData([]);
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<Category>>(
  CategoriesNotifier.new,
);

// --- conditions (persisted) ---

class ConditionsNotifier extends AsyncNotifier<List<Condition>> {
  @override
  Future<List<Condition>> build() async {
    return _readFromStorage();
  }

  Future<List<Condition>> _readFromStorage() async {
    final raw = await _secureStorage.read(key: 'ff_conditions');
    if (raw == null || raw.isEmpty) return [];
    return CsvToListConverter()
        .convert(raw)
        .first
        .map((e) {
          try {
            return Condition.fromJson(jsonDecode(e.toString()));
          } catch (_) {
            return null;
          }
        })
        .whereType<Condition>()
        .toList();
  }

  Future<void> _persist(List<Condition> list) async {
    final csv = ListToCsvConverter().convert([
      list.map((x) => x.serialize()).toList(),
    ]);
    await _secureStorage.write(key: 'ff_conditions', value: csv);
  }

  Future<void> set(List<Condition> conditions) async {
    await _persist(conditions);
    state = AsyncData(conditions);
  }

  Future<void> add(Condition condition) async {
    final current = state.valueOrNull ?? [];
    final updated = [...current, condition];
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> remove(Condition condition) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((c) => c != condition).toList();
    await _persist(updated);
    state = AsyncData(updated);
  }

  Future<void> removeAtIndex(int index) async {
    final current = <Condition>[...(state.valueOrNull ?? [])]..removeAt(index);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> updateAtIndex(
    int index,
    Condition Function(Condition) updateFn,
  ) async {
    final current = <Condition>[...(state.valueOrNull ?? [])];
    current[index] = updateFn(current[index]);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> insertAtIndex(int index, Condition condition) async {
    final current = <Condition>[...(state.valueOrNull ?? [])]
      ..insert(index, condition);
    await _persist(current);
    state = AsyncData(current);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_conditions');
    state = const AsyncData([]);
  }
}

final conditionsProvider =
    AsyncNotifierProvider<ConditionsNotifier, List<Condition>>(
  ConditionsNotifier.new,
);

// --- choosenTags (in-memory only) ---

class ChoosenTagsNotifier extends Notifier<List<Tag>> {
  @override
  List<Tag> build() => [];

  void set(List<Tag> tags) {
    state = tags;
  }

  void add(Tag tag) {
    state = [...state, tag];
  }

  void remove(Tag tag) {
    state = state.where((t) => t != tag).toList();
  }

  void removeAtIndex(int index) {
    state = [...state]..removeAt(index);
  }

  void updateAtIndex(
    int index,
    Tag Function(Tag) updateFn,
  ) {
    final list = [...state];
    list[index] = updateFn(list[index]);
    state = list;
  }

  void insertAtIndex(int index, Tag tag) {
    state = [...state]..insert(index, tag);
  }

  void clear() {
    state = [];
  }
}

final choosenTagsProvider = NotifierProvider<ChoosenTagsNotifier, List<Tag>>(
  ChoosenTagsNotifier.new,
);
