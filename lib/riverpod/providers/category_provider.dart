import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iCategory_repository.dart';
import 'package:zcart/riverpod/notifier/category_state_notifier.dart';
import 'package:zcart/data/repository/category_repository.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) => CategoryRepository());

final categoryNotifierProvider = StateNotifierProvider((ref) => CategoryNotifier(ref.watch(categoryRepositoryProvider)));

final categorySubgroupNotifierProvider = StateNotifierProvider((ref) => CategorySubgroupNotifier(ref.watch(categoryRepositoryProvider)));

final subgroupCategoryNotifierProvider = StateNotifierProvider((ref) => SubgroupCategoryNotifier(ref.watch(categoryRepositoryProvider)));

final categoryItemRepositoryProvider = Provider<ICategoryItemRepository>((ref) => CategoryItemRepository());

final categoryItemNotifierProvider = StateNotifierProvider((ref) => CategoryItemNotifier(ref.watch(categoryItemRepositoryProvider)));
