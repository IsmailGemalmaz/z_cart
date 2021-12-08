import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iUser_repository.dart';
import 'package:zcart/data/repository/user_repository.dart';
import 'package:zcart/riverpod/notifier/user_state_notifier.dart';

final _userRepositoryProvider = Provider<IUserRepository>((ref) => UserRepository());

final userNotifierProvider = StateNotifierProvider((ref) => UserNotifier(ref.watch(_userRepositoryProvider)));
