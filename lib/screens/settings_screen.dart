import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/bottom_navigation.dart';
import 'account_screen.dart';
import 'feedback_screen.dart';
import 'complaints_screen.dart';
import 'help_screen.dart';
import 'contact_screen.dart';
import 'privacy_policy_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _lowStockAlerts = true;
  bool _salesNotifications = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );
      setState(() {
        _selectedTheme = themeProvider.getThemeDisplayName(
          themeProvider.themeMode,
        );
        _selectedLanguage = localeProvider.getLanguageDisplayName(
          localeProvider.locale,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.currentUser;
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user?.name ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user?.email ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // App Preferences Section
            _buildSectionHeader('App Preferences'),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Theme'),
                    subtitle: Text(_selectedTheme),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showThemeDialog(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showLanguageDialog(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notifications Section
            _buildSectionHeader('Notifications'),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications),
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive app notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                        if (!value) {
                          _lowStockAlerts = false;
                          _salesNotifications = false;
                        }
                      });
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.warning),
                    title: const Text('Low Stock Alerts'),
                    subtitle: const Text('Get notified when stock is low'),
                    value: _lowStockAlerts,
                    onChanged:
                        _notificationsEnabled
                            ? (value) {
                              setState(() {
                                _lowStockAlerts = value;
                              });
                            }
                            : null,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.shopping_cart),
                    title: const Text('Sales Notifications'),
                    subtitle: const Text('Get notified about sales activities'),
                    value: _salesNotifications,
                    onChanged:
                        _notificationsEnabled
                            ? (value) {
                              setState(() {
                                _salesNotifications = value;
                              });
                            }
                            : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Support Section
            _buildSectionHeader('Support & Feedback'),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text('Send Feedback'),
                    subtitle: const Text('Share your thoughts with us'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FeedbackScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.report_problem),
                    title: const Text('Report Issue'),
                    subtitle: const Text('Report bugs or problems'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ComplaintsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & FAQ'),
                    subtitle: const Text('Get help and find answers'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.contact_support),
                    title: const Text('Contact Us'),
                    subtitle: const Text('Get in touch with support'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ContactScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Legal Section
            _buildSectionHeader('Legal'),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('Read our privacy policy'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    subtitle: const Text('App version and information'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showAboutDialog(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account Actions Section
            _buildSectionHeader('Account'),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.errorColor),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
                subtitle: const Text('Sign out of your account'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.errorColor,
                ),
                onTap: () => _showLogoutDialog(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  AppThemeMode.values.map((themeMode) {
                    return RadioListTile<AppThemeMode>(
                      title: Text(themeProvider.getThemeDisplayName(themeMode)),
                      value: themeMode,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) async {
                        if (value != null) {
                          await themeProvider.setTheme(value);
                          setState(() {
                            _selectedTheme = themeProvider.getThemeDisplayName(
                              value,
                            );
                          });
                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Theme changed to ${themeProvider.getThemeDisplayName(value)}',
                                ),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          }
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showLanguageDialog() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  localeProvider.supportedLocales.map((locale) {
                    return RadioListTile<Locale>(
                      title: Text(
                        localeProvider.getLanguageDisplayName(locale),
                      ),
                      value: locale,
                      groupValue: localeProvider.locale,
                      onChanged: (value) async {
                        if (value != null) {
                          await localeProvider.setLocale(value);
                          setState(() {
                            _selectedLanguage = localeProvider
                                .getLanguageDisplayName(value);
                          });
                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Language changed to ${localeProvider.getLanguageDisplayName(value)}',
                                ),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          }
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Reporta',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.inventory_2, color: Colors.white, size: 32),
      ),
      children: [
        const Text(
          'Reporta is an offline inventory management app designed to help you manage your products, track stock levels, and generate reports.',
        ),
        const SizedBox(height: 16),
        const Text('Built with Flutter for academic purposes.'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }
}
