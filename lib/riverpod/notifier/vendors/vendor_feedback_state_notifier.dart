import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iVendors_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/state.dart';

class VendorFeedbackNotifier extends StateNotifier<VendorFeedbackState> {
  final IVendorsRepository _iVendorsRepository;

  VendorFeedbackNotifier(this._iVendorsRepository) : super(VendorFeedbackInitialState());

  Future<void> getVendorFeedback(String slug) async {
    try {
      state = VendorFeedbackLoadingState();
      final vendorFeddbacks = await _iVendorsRepository.fetchVendorFeedback(slug);
      state = VendorFeedbackLoadedState(vendorFeddbacks);
    } on NetworkException {
      state = VendorFeedbackErrorState("Couldn't fetch Vendors Feedback Data. Something went wrong!");
    }
  }
}
