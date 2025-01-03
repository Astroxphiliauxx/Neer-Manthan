import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static final String loginUrl = dotenv.env['LOGIN_URL'] ?? '';
  static final String signupUrl = dotenv.env['SIGNUP_URL'] ?? '';
  static final String otpUrl = dotenv.env['OTP_URL'] ?? '';
  static final String reOtpUrl = dotenv.env['REGENERATE_OTP'] ?? '';
  static final int defaultTimeout = int.tryParse(dotenv.env['DEFAULT_TIMEOUT'] ?? '30') ?? 30;
  static final String predictionUrl = dotenv.env['PREDICTION_URL'] ?? '';
  static final String predictionUrl2 = dotenv.env['PREDICTION_URL_2'] ?? '';
}
