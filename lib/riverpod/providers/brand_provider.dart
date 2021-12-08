import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iBrand_repository.dart';
import 'package:zcart/data/repository/brand_repository.dart';
import 'package:zcart/riverpod/notifier/brand_state_notifier.dart';

/// Brand Repo
final _brandRepositoryProvider =
    Provider<IBrandRepository>((ref) => BrandRepository());

/// Brand Profile
final brandProfileNotifierProvider = StateNotifierProvider(
    (ref) => BrandProfileNotifier(ref.watch(_brandRepositoryProvider)));

/// Brand Items List
final brandItemsListNotifierProvider = StateNotifierProvider(
    (ref) => BrandItemsListNotifier(ref.watch(_brandRepositoryProvider)));
