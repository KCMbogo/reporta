import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  // Common
  @override
  String get appName => 'Reporta';
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'Cancel';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get edit => 'Edit';
  @override
  String get add => 'Add';
  @override
  String get search => 'Search';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'Error';
  @override
  String get success => 'Success';
  @override
  String get warning => 'Warning';
  @override
  String get info => 'Info';
  
  // Authentication
  @override
  String get login => 'Login';
  @override
  String get logout => 'Logout';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get name => 'Name';
  @override
  String get signUp => 'Sign Up';
  @override
  String get forgotPassword => 'Forgot Password?';
  @override
  String get resetPassword => 'Reset Password';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get securityQuestion => 'Security Question';
  @override
  String get securityAnswer => 'Security Answer';
  
  // Navigation
  @override
  String get dashboard => 'Dashboard';
  @override
  String get products => 'Products';
  @override
  String get reports => 'Reports';
  @override
  String get settings => 'Settings';
  @override
  String get account => 'Account';
  @override
  String get help => 'Help';
  @override
  String get contact => 'Contact';
  @override
  String get feedback => 'Feedback';
  @override
  String get complaints => 'Complaints';
  @override
  String get privacyPolicy => 'Privacy Policy';
  
  // Products
  @override
  String get productName => 'Product Name';
  @override
  String get description => 'Description';
  @override
  String get price => 'Price';
  @override
  String get category => 'Category';
  @override
  String get currency => 'Currency';
  @override
  String get stockQuantity => 'Stock Quantity';
  @override
  String get lowStockThreshold => 'Low Stock Threshold';
  @override
  String get addProduct => 'Add Product';
  @override
  String get editProduct => 'Edit Product';
  @override
  String get deleteProduct => 'Delete Product';
  @override
  String get stockIn => 'Stock In';
  @override
  String get stockOut => 'Stock Out';
  @override
  String get recordSale => 'Record Sale';
  
  // Dashboard
  @override
  String get totalProducts => 'Total Products';
  @override
  String get lowStockAlerts => 'Low Stock Alerts';
  @override
  String get totalSales => 'Total Sales';
  @override
  String get quickActions => 'Quick Actions';
  @override
  String get recentActivity => 'Recent Activity';
  @override
  String get stockHistory => 'Stock History';
  
  // Reports
  @override
  String get overview => 'Overview';
  @override
  String get stockReport => 'Stock Report';
  @override
  String get transactionHistory => 'Transaction History';
  @override
  String get salesReport => 'Sales Report';
  @override
  String get lowStockReport => 'Low Stock Report';
  
  // Settings
  @override
  String get theme => 'Theme';
  @override
  String get language => 'Language';
  @override
  String get notifications => 'Notifications';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';
  @override
  String get systemTheme => 'System';
  
  // Messages
  @override
  String get welcomeMessage => 'Welcome to Reporta!';
  @override
  String get loginSuccess => 'Login successful';
  @override
  String get loginError => 'Invalid email or password';
  @override
  String get productAdded => 'Product added successfully';
  @override
  String get productUpdated => 'Product updated successfully';
  @override
  String get productDeleted => 'Product deleted successfully';
  @override
  String get stockUpdated => 'Stock updated successfully';
  @override
  String get saleRecorded => 'Sale recorded successfully';
  
  // Validation
  @override
  String get fieldRequired => 'This field is required';
  @override
  String get invalidEmail => 'Please enter a valid email address';
  @override
  String get passwordTooShort => 'Password must be at least 6 characters';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get invalidPrice => 'Please enter a valid price';
  @override
  String get invalidQuantity => 'Please enter a valid quantity';
}
