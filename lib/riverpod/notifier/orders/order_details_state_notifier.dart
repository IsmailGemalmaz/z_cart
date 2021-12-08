import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iOrder_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/order_state.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final IOrderRepository _iOrderRepository;

  OrderNotifier(this._iOrderRepository) : super(OrderInitialState());

  Future getOrderDetails(orderId) async {
    try {
      state = OrderLoadingState();
      final orderDetails = await _iOrderRepository.order(orderId);
      state = OrderLoadedState(orderDetails);
    } on NetworkException {
      state = OrderErrorState("Something went wrong");
    }
  }
}
