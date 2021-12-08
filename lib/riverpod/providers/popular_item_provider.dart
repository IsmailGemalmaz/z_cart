import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/repository/product/popular_item_repository.dart';
import 'package:zcart/riverpod/notifier/product/popular_item_state_notifier.dart';

final popularItemRepositoryProvider = Provider<IPopularItemRepository>((ref) => PopularItemRepository());

final popularItemNotifierProvider = StateNotifierProvider((ref) => PopularItemNotifier(ref.watch(popularItemRepositoryProvider)));
