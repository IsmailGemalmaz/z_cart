import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/repository/product/product_repository.dart';
import 'package:zcart/riverpod/notifier/product/product_state_notifier.dart';

final productRepositoryProvider = Provider<IProductRepository>((ref) => ProductRepository());

final productNotifierProvider = StateNotifierProvider((ref) => ProductNotifier(ref.watch(productRepositoryProvider)));
final productVariantNotifierProvider = StateNotifierProvider((ref) => ProductVariantNotifier(ref.watch(productRepositoryProvider)));
final productListNotifierProvider = StateNotifierProvider((ref) => ProductListNotifier(ref.watch(productRepositoryProvider)));
