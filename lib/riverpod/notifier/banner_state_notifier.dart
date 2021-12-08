import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iBanner_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/banner_state.dart';

class BannerNotifier extends StateNotifier<BannerState> {
  final IBannerRepository _iBannerRepository;

  BannerNotifier(this._iBannerRepository) : super(BannerInitialState());

  Future<void> getBanner() async {
    try {
      state = BannerLoadingState();
      final banner = await _iBannerRepository.fetchBanner();
      state = BannerLoadedState(banner);
    } on NetworkException {
      state = BannerErrorState("Couldn't fetch Banner Data. Something went wrong!");
    }
  }
}
