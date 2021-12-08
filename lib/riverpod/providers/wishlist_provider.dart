import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iWishlist_repository.dart';
import 'package:zcart/data/repository/wishlist_repository.dart';
import 'package:zcart/riverpod/notifier/wishlist_state.notifier.dart';

final wishListRepositoryProvider = Provider<IWishListRepository>((ref) => WishListRepository());

final wishListNotifierProvider = StateNotifierProvider((ref) => WishListNotifier(ref.watch(wishListRepositoryProvider)));
