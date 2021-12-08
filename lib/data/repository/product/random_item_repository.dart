import 'package:zcart/data/interface/iProduct_repository.dart';
import 'package:zcart/data/models/product/product_model.dart';
import 'package:zcart/data/network/api.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';

class RandomItemRepository implements IRandomItemRepository {
  ProductModel randomItemModel;
  List<ProductList> randomItemList = [];

  @override
  Future<List<ProductList>> fetchRandomItems() async {
    if (randomItemList != null) {
      randomItemList.clear();
    }
    var responseBody = await handleResponse(await getRequest(API.random));
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    randomItemModel = ProductModel.fromJson(responseBody);
    randomItemList.addAll(randomItemModel.data);
    return randomItemList;
  }

  @override
  Future<List<ProductList>> fetchMoreRandomItems() async {
    var responseBody;
    print("fetchMoreRandomItems (before): ${randomItemList.length}");

    if (randomItemModel.links.next != null) {
      toast("Loading more products");
      responseBody = await handleResponse(
          await getRequest(randomItemModel.links.next.split('api/').last));

      randomItemModel = ProductModel.fromJson(responseBody);
      randomItemList.addAll(randomItemModel.data);
      print("fetchMoreRandomItems (after): ${randomItemList.length}");
      return randomItemList;
    } else {
      toast("You have reached the end!");
      return randomItemList;
    }
  }
}
