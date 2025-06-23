class AppConstants {
  static const String appName = 'Reporta';
  static const String appVersion = '1.0.0';
  static const String securityQuestion = "What's the name of the primary school you went to?";
  
  // Animation durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Validation patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 50;
  
  // Database constants
  static const String databaseName = 'reporta.db';
  static const int databaseVersion = 1;
}
