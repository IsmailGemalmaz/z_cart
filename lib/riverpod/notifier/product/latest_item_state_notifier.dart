import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/product/latest_item_state.dart';

class LatestItemNotifier extends StateNotifier<LatestItemState> {
  final ILatestItemRepository _iLatestItemRepository;

  LatestItemNotifier(this._iLatestItemRepository) : super(LatestItemInitialState());

  Future<void> getLatestItem() async {
    try {
      state = LatestItemLoadingState();
      final latestItems = await _iLatestItemRepository.fetchLatestItems();
      state = LatestItemLoadedState(latestItems);
    } on NetworkException {
      state = LatestItemErrorState("Couldn't fetch Latest Item Data. Something went wrong!");
    }
  }
}
