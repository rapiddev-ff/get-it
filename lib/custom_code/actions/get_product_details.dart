import '/features/home/domain/models/product_details_model.dart';
import '/features/home/data/repositories/product_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = ProductRepository(Supabase.instance.client);

Future<ProductDetails?> getProductDetails(
  String productId,
  String? userId,
) async {
  return _repository.getProductDetails(productId, userId);
}
