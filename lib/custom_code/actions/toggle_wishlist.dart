import '/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = WishlistRepository(Supabase.instance.client);

Future<bool> toggleWishlist(
  String userId,
  String productId,
) async {
  return _repository.toggleWishlist(userId, productId);
}
