import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iBanner_repository.dart';
import 'package:zcart/data/repository/banner_repository.dart';
import 'package:zcart/riverpod/notifier/banner_state_notifier.dart';

final bannerRepositoryProvider = Provider<IBannerRepository>((ref) => BannerRepository());

final bannerNotifierProvider = StateNotifierProvider((ref) => BannerNotifier(ref.watch(bannerRepositoryProvider)));
