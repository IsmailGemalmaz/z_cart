import 'package:zcart/data/interface/iUser_repository.dart';
import 'package:zcart/data/models/user/user_model.dart';
import 'package:zcart/helper/constants.dart';
import 'package:zcart/data/network/api.dart';
import 'package:zcart/data/network/network_exception.dart';
import 'package:zcart/data/network/network_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zcart/Theme/styles/colors.dart';

class UserRepository implements IUserRepository {
  /// Login user
  @override
  Future<User> logIn(username, password) async {
    setBool(LOGGED_IN, false);

    var requestBody = {'email': username.trim(), 'password': password};
    var responseBody;

    try {
      responseBody =
          await handleResponse(await postRequest(API.login, requestBody));
    } catch (e) {
      throw NetworkException();
    }
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    UserModel userModel = UserModel.fromJson(responseBody);

    toast("Sign In Successful");
    setBool(LOGGED_IN, true);
    setString(ACCESS, userModel.data.apiToken);

    return userModel.data;
  }

  /// Register User
  @override
  Future<User> register(String name, email, password,
      bool agreeToTermsAndCondition, acceptMarkeing) async {
    var requestBody = {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirmation': password,
      'agree': agreeToTermsAndCondition.toString(),
      'accepts_marketing': acceptMarkeing.toString()
    };
    var responseBody;

    try {
      responseBody =
          await handleResponse(await postRequest(API.register, requestBody));
    } catch (e) {
      print(e);
      throw NetworkException();
    }

    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    UserModel userModel = UserModel.fromJson(responseBody);

    toast("Register Successful");
    setBool(LOGGED_IN, true);
    setString(ACCESS, userModel.data.apiToken);
    return userModel.data;
  }

  @override
  Future logout() async {
    var requestBody = {};
    var responseBody;

    try {
      responseBody = await handleResponse(
          await postRequest(API.logout, requestBody, bearerToken: true));
    } catch (e) {
      throw NetworkException();
    }
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    toast("Logged out!");
    await getSharedPref().then((value) => value.clear());
  }

  /// Fetch user info
  @override
  Future<User> fetchUserInfo() async {
    var responseBody;

    try {
      responseBody = await handleResponse(
          await getRequest(API.userInfo, bearerToken: true));
    } catch (e) {
      throw NetworkException();
    }
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    UserModel userModel = UserModel.fromJson(responseBody);

    return userModel.data;
  }

  /// Update user account
  @override
  Future<void> updateBasicInfo(
      {String fullName,
      String nickName,
      String bio,
      dynamic dob,
      String email}) async {
    var requestBody = {
      'name': fullName,
      'nice_name': nickName,
      'description': bio,
      'dob': dob,
      'email': email
    };
    var responseBody;

    try {
      responseBody =
          await handleResponse(await putRequest(API.userInfo, requestBody));
    } catch (e) {
      throw NetworkException();
    }
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    UserModel userModel = UserModel.fromJson(responseBody);
    toast(
      "Profile updated successfully",
      gravity: ToastGravity.CENTER,
      bgColor: kPrimaryColor,
      textColor: kLightColor,
    );

    return userModel.data;
  }

  @override
  Future updatePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    var requestBody = {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': confirmPassword,
    };
    var responseBody;

    try {
      responseBody = await handleResponse(
          await putRequest(API.updatePassword, requestBody));
    } catch (e) {
      throw NetworkException();
    }
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    toast(
      "Password updated successfully",
      gravity: ToastGravity.CENTER,
      bgColor: kPrimaryColor,
      textColor: kLightColor,
    );
  }

  @override
  Future forgotPassword(String email) async {
    var requestBody = {
      'email': email,
    };
    var responseBody;

    try {
      responseBody =
          await handleResponse(await postRequest(API.forgot, requestBody));
    } catch (e) {
      throw NetworkException();
    }
    if (responseBody.runtimeType == int) if (responseBody > 206)
      throw NetworkException();

    toast(
      "The password reset link sent! Please check your email.",
      gravity: ToastGravity.CENTER,
      bgColor: kPrimaryColor,
      textColor: kLightColor,
    );
  }
}
