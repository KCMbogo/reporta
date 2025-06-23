import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    size: 64,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _buildSection(
              context,
              'Introduction',
              'Reporta is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our offline inventory management application.',
            ),

            _buildSection(
              context,
              'Data Collection',
              'Reporta operates as a fully offline application. All data is stored locally on your device and includes:\n\n'
              '• User account information (name, email, password)\n'
              '• Product inventory data\n'
              '• Stock transaction records\n'
              '• User feedback and complaints\n'
              '• App settings and preferences\n\n'
              'We do not collect, transmit, or store any data on external servers.',
            ),

            _buildSection(
              context,
              'Data Usage',
              'Your data is used solely for:\n\n'
              '• Providing inventory management functionality\n'
              '• Maintaining user accounts and authentication\n'
              '• Generating reports and analytics\n'
              '• Storing user preferences and settings\n'
              '• Managing feedback and support requests\n\n'
              'Your data remains on your device at all times.',
            ),

            _buildSection(
              context,
              'Data Security',
              'We implement appropriate security measures to protect your data:\n\n'
              '• Passwords are encrypted using industry-standard hashing\n'
              '• Local database is secured using SQLite encryption\n'
              '• No data transmission to external servers\n'
              '• Regular security updates and patches\n\n'
              'However, no method of electronic storage is 100% secure.',
            ),

            _buildSection(
              context,
              'Data Sharing',
              'Since Reporta operates entirely offline, we do not share, sell, or transmit your personal data to any third parties. Your information remains completely private and under your control.',
            ),

            _buildSection(
              context,
              'Data Retention',
              'Your data is retained locally on your device until:\n\n'
              '• You manually delete it\n'
              '• You uninstall the application\n'
              '• You reset your device\n\n'
              'We recommend regular backups of important data.',
            ),

            _buildSection(
              context,
              'Your Rights',
              'As a user of Reporta, you have the right to:\n\n'
              '• Access all your stored data\n'
              '• Modify or update your information\n'
              '• Delete your account and all associated data\n'
              '• Export your data for backup purposes\n'
              '• Control app permissions and settings',
            ),

            _buildSection(
              context,
              'Children\'s Privacy',
              'Reporta is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13.',
            ),

            _buildSection(
              context,
              'Changes to Privacy Policy',
              'We may update this Privacy Policy from time to time. Any changes will be reflected in the app with an updated "Last updated" date. Continued use of the app after changes constitutes acceptance of the new policy.',
            ),

            _buildSection(
              context,
              'Contact Information',
              'If you have any questions about this Privacy Policy or our data practices, please contact us through the app\'s feedback system or support channels.',
            ),

            const SizedBox(height: 32),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.security,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Privacy Matters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reporta is designed with privacy by design principles. Your data stays on your device, giving you complete control over your information.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
