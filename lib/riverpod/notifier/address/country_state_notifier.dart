import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iAddress_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/address/country_state.dart';

class CountryNotifier extends StateNotifier<CountryState> {
  final IAddressRepository _iAddressRepository;

  CountryNotifier(this._iAddressRepository) : super(CountryInitialState());

  Future getCountries() async {
    try {
      state = CountryLoadingState();
      final countries = await _iAddressRepository.fetchCountries();
      state = CountryLoadedState(countries);
    } on NetworkException {
      state = CountryErrorState("Couldn't fetch Country data. Something went wrong!");
    }
  }
}
