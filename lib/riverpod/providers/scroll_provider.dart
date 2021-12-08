import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/riverpod/notifier/scroll_state_notifier.dart';

final randomItemScrollNotifierProvider =
    StateNotifierProvider((ref) => RandomItemScrollNotifier());
final vendorItemScrollNotifierProvider =
    StateNotifierProvider((ref) => VendorItemScrollNotifier());
final categoryDetailsScrollNotifierProvider =
    StateNotifierProvider((ref) => CategoryDetailsScrollNotifier());
final disputesScrollNotifierProvider =
    StateNotifierProvider((ref) => DisputesScrollNotifier());
final wishlistScrollNotifierProvider =
    StateNotifierProvider((ref) => WishListScrollNotifier());
