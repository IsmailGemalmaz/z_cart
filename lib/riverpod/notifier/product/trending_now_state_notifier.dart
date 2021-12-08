import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/state.dart';

class TrendingNowNotifier extends StateNotifier<TrendingNowState> {
  final ITrendingNowRepository _iTrendingNowRepository;

  TrendingNowNotifier(this._iTrendingNowRepository) : super(TrendingNowInitialState());

  Future<void> getTrendingNowItems() async {
    try {
      state = TrendingNowLoadingState();
      final trendingNow = await _iTrendingNowRepository.fetchTrendingNowItems();
      state = TrendingNowLoadedState(trendingNow);
    } on NetworkException {
      state = TrendingNowErrorState("Couldn't fetch Trending Now Data. Something went wrong!");
    }
  }
}
