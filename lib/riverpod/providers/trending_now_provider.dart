import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/repository/product/trending_now_repository.dart';
import 'package:zcart/riverpod/notifier/product/trending_now_state_notifier.dart';

final trendingNowRepositoryProvider = Provider<ITrendingNowRepository>((ref) => TrendingNowRepository());

final trendingNowNotifierProvider = StateNotifierProvider((ref) => TrendingNowNotifier(ref.watch(trendingNowRepositoryProvider)));
