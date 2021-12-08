import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iOffers_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/offers_state.dart';

class OffersNotifier extends StateNotifier<OffersState> {
  final IOffersRepository _iOffersRepository;

  OffersNotifier(this._iOffersRepository) : super(OffersInitialState());

  Future<void> getOffersFromOtherSellers(String slug) async {
    try {
      state = OffersLoadingState();
      final offers = await _iOffersRepository.fetchOffersFromOtherSellers(slug);
      state = OffersLoadedState(offers);
    } on NetworkException {
      state = OffersErrorState("Something went wrong! Try again later");
    }
  }
}
