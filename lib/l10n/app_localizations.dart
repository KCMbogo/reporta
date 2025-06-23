import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Common
  String get appName;
  String get ok;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get add;
  String get search;
  String get loading;
  String get error;
  String get success;
  String get warning;
  String get info;
  
  // Authentication
  String get login;
  String get logout;
  String get email;
  String get password;
  String get name;
  String get signUp;
  String get forgotPassword;
  String get resetPassword;
  String get confirmPassword;
  String get securityQuestion;
  String get securityAnswer;
  
  // Navigation
  String get dashboard;
  String get products;
  String get reports;
  String get settings;
  String get account;
  String get help;
  String get contact;
  String get feedback;
  String get complaints;
  String get privacyPolicy;
  
  // Products
  String get productName;
  String get description;
  String get price;
  String get category;
  String get currency;
  String get stockQuantity;
  String get lowStockThreshold;
  String get addProduct;
  String get editProduct;
  String get deleteProduct;
  String get stockIn;
  String get stockOut;
  String get recordSale;
  
  // Dashboard
  String get totalProducts;
  String get lowStockAlerts;
  String get totalSales;
  String get quickActions;
  String get recentActivity;
  String get stockHistory;
  
  // Reports
  String get overview;
  String get stockReport;
  String get transactionHistory;
  String get salesReport;
  String get lowStockReport;
  
  // Settings
  String get theme;
  String get language;
  String get notifications;
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  
  // Messages
  String get welcomeMessage;
  String get loginSuccess;
  String get loginError;
  String get productAdded;
  String get productUpdated;
  String get productDeleted;
  String get stockUpdated;
  String get saleRecorded;
  
  // Validation
  String get fieldRequired;
  String get invalidEmail;
  String get passwordTooShort;
  String get passwordsDoNotMatch;
  String get invalidPrice;
  String get invalidQuantity;
}
