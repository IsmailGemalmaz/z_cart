import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iCart_repository.dart';
import 'package:zcart/data/repository/cart_repository.dart';
import 'package:zcart/riverpod/notifier/cart_state_notifier.dart';

final cartRepositoryProvider =
    Provider<ICartRepository>((ref) => CartRepository());

final cartNotifierProvider = StateNotifierProvider(
    (ref) => CartNotifier(ref.watch(cartRepositoryProvider)));

final cartItemDetailsNotifierProvider = StateNotifierProvider(
    (ref) => CartItemDetailsNotifier(ref.watch(cartRepositoryProvider)));
