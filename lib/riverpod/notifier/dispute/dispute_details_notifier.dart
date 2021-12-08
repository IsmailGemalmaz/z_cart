import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/data/interface/iDispute_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/dispute/dispute_details_state.dart';

class DisputeDetailsNotifier extends StateNotifier<DisputeDetailsState> {
  final IDisputeRepository _iDisputeRepository;

  DisputeDetailsNotifier(this._iDisputeRepository)
      : super(DisputeDetailsInitialState());

  Future getDisputeDetails(disputeId) async {
    try {
      state = DisputeDetailsLoadingState();
      final disputeDetails =
          await _iDisputeRepository.disputeDetails(disputeId);
      state = DisputeDetailsLoadedState(disputeDetails);
    } on NetworkException {
      state = DisputeDetailsErrorState("Something went wrong");
    }
  }

  Future postDisputeRespose(disputeId, requestBody) async {
    try {
      await _iDisputeRepository.responseDispute(disputeId, requestBody);
      getDisputeDetails(disputeId);
    } on NetworkException {
      state = DisputeDetailsErrorState("Something went wrong");
    }
  }

  Future postDisputeAppeal(disputeId, requestBody) async {
    try {
      await _iDisputeRepository.appealDispute(disputeId, requestBody);
      await getDisputeDetails(disputeId);
      toast("Appeal is sent!");
    } on NetworkException {
      state = DisputeDetailsErrorState("Something went wrong");
    }
  }
}
