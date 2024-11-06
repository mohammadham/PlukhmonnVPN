class AppUrls {

  static String baseMasterUrl = "https://curly-bar-81b1.plakhmoon.workers.dev"; // Default base URL
  static String baseUrl = "https://curly-bar-81b1.plakhmoon.workers.dev"; // Default base URL
  static void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }
  static String freeServer = "https://curly-bar-81b1.plakhmoon.workers.dev"; // Default base URL
  static void updateFreeServer(String newBaseUrl) {
    freeServer = newBaseUrl;
  }
  static String get baseApiUrl => '$baseUrl/api/v1'; // Base API URL

  static String get login => '$baseApiUrl/passport/auth/login';
  static String get register => '$baseApiUrl/passport/auth/register';
  static String get getQuickLoginUrl => '$baseApiUrl/passport/auth/getQuickLoginUrl';
  static String get userSubscribe => '$baseApiUrl/user/getSubscribe';
  static String get resetSecurity => '$baseApiUrl/user/resetSecurity';
  static String get plan => '$baseApiUrl/guest/plan/fetch';
  static String get server => '$baseApiUrl/user/server/fetch';
  static String get userInfo => '$baseApiUrl/user/info';
  static String get appSetting => '/api/plakhmoon/generate-token';
}
