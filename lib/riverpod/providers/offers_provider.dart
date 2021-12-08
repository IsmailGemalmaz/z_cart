import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iOffers_repository.dart';
import 'package:zcart/data/repository/offers_repository.dart';
import 'package:zcart/riverpod/notifier/offers_state_notifier.dart';

final offersRepositoryProvider = Provider<IOffersRepository>((ref) => OffersRepository());

final offersNotifierProvider = StateNotifierProvider((ref) => OffersNotifier(ref.watch(offersRepositoryProvider)));
