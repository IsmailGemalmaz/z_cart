import 'package:zcart/data/models/brand/brand_items_list_model.dart';
import 'package:zcart/data/models/brand/brand_profile_model.dart';

/// Vendors Details State
abstract class BrandProfileState {
  const BrandProfileState();
}

class BrandProfileInitialState extends BrandProfileState {
  const BrandProfileInitialState();
}

class BrandProfileLoadingState extends BrandProfileState {
  const BrandProfileLoadingState();
}

class BrandProfileLoadedState extends BrandProfileState {
  final BrandProfile brandProfile;

  const BrandProfileLoadedState(this.brandProfile);
}

class BrandProfileErrorState extends BrandProfileState {
  final String message;

  const BrandProfileErrorState(this.message);
}

/// Vendor Items State
abstract class BrandItemsState {
  const BrandItemsState();
}

class BrandItemsInitialState extends BrandItemsState {
  const BrandItemsInitialState();
}

class BrandItemsLoadingState extends BrandItemsState {
  const BrandItemsLoadingState();
}

class BrandItemsLoadedState extends BrandItemsState {
  final BrandItemsList brandItemsList;

  const BrandItemsLoadedState(this.brandItemsList);
}

class BrandItemsErrorState extends BrandItemsState {
  final String message;

  const BrandItemsErrorState(this.message);
}
