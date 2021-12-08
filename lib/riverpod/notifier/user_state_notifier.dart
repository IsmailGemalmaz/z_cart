import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zcart/data/interface/iUser_repository.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/riverpod/state/user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final IUserRepository _iUserRepository;

  UserNotifier(this._iUserRepository) : super(UserInitialState());

  Future<void> login(String username, String password) async {
    try {
      state = UserLoadingState();
      final user = await _iUserRepository.logIn(username, password);
      state = UserLoadedState(user);
    } on NetworkException {
      state = UserErrorState("Failed to log you in!");
    }
  }

  Future<void> register(String name, email, password,
      bool agreeToTermsAndCondition, acceptMarkeing) async {
    try {
      state = UserLoadingState();
      final user = await _iUserRepository.register(
          name, email, password, agreeToTermsAndCondition, acceptMarkeing);
      state = UserLoadedState(user);
    } on NetworkException {
      state = UserErrorState("Registration Failed!");
    }
  }

  Future<void> logout() async {
    try {
      await _iUserRepository.logout();
    } on NetworkException {
      state = UserErrorState("Failed to log you in!");
    }
  }

  Future<void> getUserInfo() async {
    try {
      state = UserLoadingState();
      final user = await _iUserRepository.fetchUserInfo();
      state = UserLoadedState(user);
    } on NetworkException {
      state = UserErrorState("Something went wrong!");
    }
  }

  Future<void> updateUserInfo(String fullName, String nickName, String bio,
      String email, dynamic dob) async {
    try {
      await _iUserRepository.updateBasicInfo(
          fullName: fullName,
          nickName: nickName,
          bio: bio,
          email: email,
          dob: dob);
    } on NetworkException {
      state = UserErrorState("Something went wrong!");
    }
  }

  Future<void> updatePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    try {
      await _iUserRepository.updatePassword(
          oldPassword, newPassword, confirmPassword);
    } on NetworkException {
      state = UserErrorState("Something went wrong!");
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _iUserRepository.forgotPassword(email);
    } on NetworkException {
      state = UserErrorState("Something went wrong!");
    }
  }
}
