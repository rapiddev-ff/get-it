import '../database.dart';

class ReferralsTable extends SupabaseTable<ReferralsRow> {
  @override
  String get tableName => 'referrals';

  @override
  ReferralsRow createRow(Map<String, dynamic> data) => ReferralsRow(data);
}

class ReferralsRow extends SupabaseDataRow {
  ReferralsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReferralsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get referrerId => getField<String>('referrer_id')!;
  set referrerId(String value) => setField<String>('referrer_id', value);

  String get referredId => getField<String>('referred_id')!;
  set referredId(String value) => setField<String>('referred_id', value);

  double? get totalCommissionEarned =>
      getField<double>('total_commission_earned');
  set totalCommissionEarned(double? value) =>
      setField<double>('total_commission_earned', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
