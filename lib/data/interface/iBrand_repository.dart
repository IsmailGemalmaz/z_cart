import 'package:zcart/data/models/brand/brand_items_list_model.dart';
import 'package:zcart/data/models/brand/brand_profile_model.dart';

abstract class IBrandRepository {
  Future<BrandProfile> fetchBrandProfile(String slug);

  Future<BrandItemsList> fetchBrandItems(String slug);
}
