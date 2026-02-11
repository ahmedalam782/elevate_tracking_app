class EndPoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";
  static const String login = "/drivers/signin";
  static const String register = "/auth/signup";
  static const String forgetPasswordEndpoint = "/auth/forgotPassword";
  static const String verifyResetEndpoint = "/auth/verifyResetCode";
  static const String resetPasswordEndpoint = "/auth/resetPassword";


  //! TERMS AND CONDITIONS
  //! لو عاوزين تغير مكنها  معنديش مشكلة <Kareem>
  static const String termsPath = "assets/json/terms_and_conditions.json";

  //! About App
  static const String aboutApp = "/about-app";
  //! لو عاوزين تغير مكنها  معنديش مشكلة <Kareem>
  static const String aboutAppPath = 'assets/json/Flowery About Section JSON with Expanded Content.json';
}

class Apikeys {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String userId = 'userId';
  static const String rememberMe = 'rememberMe';
  static const String language = 'language';
}

class QueryParameter {
  static const String keyword = 'keyword';
  static const String page = 'page';
  static const String limit = 'limit';
}
