import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iDispute_repository.dart';
import 'package:zcart/data/repository/dispute_repository.dart';
import 'package:zcart/riverpod/notifier/dispute/dispute_details_notifier.dart';
import 'package:zcart/riverpod/notifier/dispute/dispute_info_notifier.dart';
import 'package:zcart/riverpod/notifier/dispute/disputes_notifier.dart';
import 'package:zcart/riverpod/notifier/dispute/open_dispute_notifier.dart';

final disputeRepositoryProvider =
    Provider<IDisputeRepository>((ref) => DisputeRepository());

final disputesProvider = StateNotifierProvider(
    (ref) => DisputesNotifier(ref.watch(disputeRepositoryProvider)));
final disputeInfoProvider = StateNotifierProvider(
    (ref) => DisputeInfoNotifier(ref.watch(disputeRepositoryProvider)));
final openDisputeInfoProvider = StateNotifierProvider(
    (ref) => OpenDisputeNotifier(ref.watch(disputeRepositoryProvider)));
final disputeDetailsProvider = StateNotifierProvider(
    (ref) => DisputeDetailsNotifier(ref.watch(disputeRepositoryProvider)));
