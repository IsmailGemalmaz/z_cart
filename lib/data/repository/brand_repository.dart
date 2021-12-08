import 'package:zcart/data/interface/iBrand_repository.dart';
import 'package:zcart/data/models/brand/brand_profile_model.dart';
import 'package:zcart/data/models/brand/brand_items_list_model.dart';
import 'package:zcart/data/network/api.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/data/network/network_utils.dart';

class BrandRepository implements IBrandRepository {
  @override
  Future<BrandItemsList> fetchBrandItems(String slug) async {
    var responseBody =
        await handleResponse(await getRequest(API.brandItems(slug)));
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    BrandItemsList brandItemList = BrandItemsList.fromMap(responseBody);
    return brandItemList;
  }

  @override
  Future<BrandProfile> fetchBrandProfile(String slug) async {
    var responseBody =
        await handleResponse(await getRequest(API.brandProfile(slug)));
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    BrandProfile brandProfile = BrandProfile.fromMap(responseBody);
    return brandProfile;
  }
}
