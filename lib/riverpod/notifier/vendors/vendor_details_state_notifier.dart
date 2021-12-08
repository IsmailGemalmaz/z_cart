import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iVendors_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/state.dart';

class VendorDetailsNotifier extends StateNotifier<VendorDetailsState> {
  final IVendorsRepository _iVendorsRepository;

  VendorDetailsNotifier(this._iVendorsRepository) : super(VendorDetailsInitialState());

  Future<void> getVendorDetails(String slug) async {
    try {
      state = VendorDetailsLoadingState();
      final vendorsDetails = await _iVendorsRepository.fetchVendorDetails(slug);
      state = VendorDetailsLoadedState(vendorsDetails);
    } on NetworkException {
      state = VendorDetailsErrorState("Couldn't fetch Vendors Data. Something went wrong!");
    }
  }
}
