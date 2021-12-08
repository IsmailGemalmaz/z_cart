import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/product/product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final IProductRepository _iProductRepository;

  ProductNotifier(this._iProductRepository) : super(ProductInitialState());

  Future<void> getProductDetails(String slug) async {
    try {
      state = ProductLoadingState();
      final productDetails = await _iProductRepository.fetchProductDetails(slug);
      state = ProductLoadedState(productDetails);
    } on NetworkException {
      state = ProductErrorState("Something went wrong! Try again later");
    }
  }

  updateState(productDetailsModel) {
    state = ProductLoadedState(productDetailsModel);
  }
}

class ProductVariantNotifier extends StateNotifier<ProductVariantState> {
  final IProductRepository _iProductRepository;

  ProductVariantNotifier(this._iProductRepository) : super(ProductVariantInitialState());

  Future<void> getProductVariantDetails(String slug, attributeId, attributeValue) async {
    var requestBody = {
      'attributes[$attributeId]': attributeValue,
    };
    try {
      state = ProductVariantLoadingState();
      final productVariantDetails = await _iProductRepository.fetchProductVariantDetails(slug, requestBody);
      state = ProductVariantLoadedState(productVariantDetails);
    } on NetworkException {
      state = ProductVariantErrorState("Something went wrong! Try again later");
    }
  }
}

class ProductListNotifier extends StateNotifier<ProductListState> {
  final IProductRepository _iProductRepository;

  ProductListNotifier(this._iProductRepository) : super(ProducListtInitialState());

  Future<void> getProductList(String slug) async {
    try {
      state = ProductListLoadingState();
      final productDetails = await _iProductRepository.fetchProductList(slug);
      state = ProductListLoadedState(productDetails);
    } on NetworkException {
      state = ProductListErrorState("Something went wrong! Try again later");
    }
  }

  Future<void> getMoreProductList() async {
    try {
      //state = RandomMoreItemLoadingState();
      final productDetails = await _iProductRepository.fetchMoreProductList();
      state = ProductListLoadedState(productDetails);
    } on NetworkException {
      state = ProductListErrorState("Couldn't fetch Random Item Data. Something went wrong!");
    }
  }
}
