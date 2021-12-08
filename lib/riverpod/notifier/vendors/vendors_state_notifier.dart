import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iVendors_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/vendors_state.dart';

class VendorsNotifier extends StateNotifier<VendorsState> {
  final IVendorsRepository _iVendorsRepository;

  VendorsNotifier(this._iVendorsRepository) : super(VendorsInitialState());

  Future<void> getVendors() async {
    try {
      state = VendorsLoadingState();
      final vendors = await _iVendorsRepository.fetchVendorsList();
      state = VendorsLoadedState(vendors);
    } on NetworkException {
      state = VendorsErrorState("Couldn't fetch Vendors Data. Something went wrong!");
    }
  }
}


