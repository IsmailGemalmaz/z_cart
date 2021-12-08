import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iBrand_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/brand_state.dart';

class BrandProfileNotifier extends StateNotifier<BrandProfileState> {
  final IBrandRepository _iBrandRepository;

  BrandProfileNotifier(this._iBrandRepository)
      : super(BrandProfileInitialState());

  Future<void> getBrandProfile(String slug) async {
    try {
      state = BrandProfileLoadingState();
      final brandProfile = await _iBrandRepository.fetchBrandProfile(slug);
      state = BrandProfileLoadedState(brandProfile);
    } on NetworkException {
      state = BrandProfileErrorState(
          "Couldn't fetch brand data. Something went wrong!");
    }
  }
}

class BrandItemsListNotifier extends StateNotifier<BrandItemsState> {
  final IBrandRepository _iBrandRepository;

  BrandItemsListNotifier(this._iBrandRepository)
      : super(BrandItemsInitialState());

  Future<void> getBrandItemsList(String slug) async {
    try {
      state = BrandItemsInitialState();
      final brandItemsList = await _iBrandRepository.fetchBrandItems(slug);
      state = BrandItemsLoadedState(brandItemsList);
    } on NetworkException {
      state = BrandItemsErrorState(
          "Couldn't fetch brand items list. Something went wrong!");
    }
  }
}
