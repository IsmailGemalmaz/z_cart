import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iAddress_repository.dart';
import 'package:zcart/data/repository/address_repository.dart';
import 'package:zcart/riverpod/notifier/address/address_state_notifier.dart';
import 'package:zcart/riverpod/notifier/address/country_state_notifier.dart';
import 'package:zcart/riverpod/notifier/address/states_state_notifier.dart';

final addressRepositoryProvider =
    Provider<IAddressRepository>((ref) => AddressRepository());

final addressNotifierProvider = StateNotifierProvider(
    (ref) => AddressNotifier(ref.watch(addressRepositoryProvider)));

final countryNotifierProvider = StateNotifierProvider(
    (ref) => CountryNotifier(ref.watch(addressRepositoryProvider)));

final statesNotifierProvider = StateNotifierProvider(
    (ref) => StatesNotifier(ref.watch(addressRepositoryProvider)));

final packagingNotifierProvider = StateNotifierProvider(
    (ref) => PackagingNotifier(ref.watch(addressRepositoryProvider)));

final shippingNotifierProvider = StateNotifierProvider(
    (ref) => ShippingNotifier(ref.watch(addressRepositoryProvider)));

final paymentOptionsNotifierProvider = StateNotifierProvider(
    (ref) => PaymentOptionsNotifier(ref.watch(addressRepositoryProvider)));
