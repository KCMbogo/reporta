import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'contact_screen.dart';
import 'feedback_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I add a new product?',
      answer:
          'To add a new product:\n1. Go to the Products tab\n2. Tap the "+" button\n3. Fill in the product details\n4. Set the initial stock quantity\n5. Tap "Save" to add the product',
    ),
    FAQItem(
      question: 'How do I update stock levels?',
      answer:
          'To update stock levels:\n1. Go to Products and select a product\n2. Tap on the product to view details\n3. Use "Stock In" to add inventory\n4. Use "Stock Out" to remove inventory\n5. Use "Record Sale" to track sales',
    ),
    FAQItem(
      question: 'How do I set low stock alerts?',
      answer:
          'Low stock alerts are set when creating or editing a product:\n1. Edit the product\n2. Set the "Low Stock Threshold" value\n3. The app will show warnings when stock falls below this number\n4. Check the Reports tab for low stock items',
    ),
    FAQItem(
      question: 'How do I view reports?',
      answer:
          'To view reports:\n1. Go to the Reports tab\n2. View the Overview for general statistics\n3. Check the Stock tab for low stock alerts\n4. Review the Transactions tab for recent activity\n5. Use date filters for specific periods',
    ),
    FAQItem(
      question: 'How do I backup my data?',
      answer:
          'Currently, all data is stored locally on your device. To backup:\n1. Ensure your device backup is enabled\n2. Consider exporting important data manually\n3. Keep your device secure and updated\n4. Future versions may include export features',
    ),
    FAQItem(
      question: 'How do I change my password?',
      answer:
          'To change your password:\n1. Go to Settings\n2. Tap on your profile at the top\n3. Tap "Change Password" in the Security section\n4. Enter your current password\n5. Enter and confirm your new password',
    ),
    FAQItem(
      question: 'What happens if I forget my password?',
      answer:
          'If you forget your password:\n1. On the login screen, tap "Forgot Password?"\n2. Enter your email address\n3. Answer the security question correctly\n4. Set a new password\n5. Your security question was set during registration',
    ),
    FAQItem(
      question: 'How do I delete a product?',
      answer:
          'To delete a product:\n1. Go to the Products tab\n2. Find the product you want to delete\n3. Tap the menu button (⋮) on the product card\n4. Select "Delete"\n5. Confirm the deletion\nNote: This will also delete all transaction history for that product.',
    ),
    FAQItem(
      question: 'How do I search for products?',
      answer:
          'To search for products:\n1. Go to the Products tab\n2. Use the search bar at the top\n3. Type the product name, description, or category\n4. Use category filters to narrow results\n5. Clear the search to see all products',
    ),
    FAQItem(
      question: 'Is my data secure?',
      answer:
          'Yes, your data is secure:\n• All data is stored locally on your device\n• Passwords are encrypted\n• No data is sent to external servers\n• The app works completely offline\n• You have full control over your data',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.help_center, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'How can we help you?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions about using Reporta',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Frequently Asked Questions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _faqItems.length,
                    itemBuilder: (context, index) {
                      return _buildFAQItem(_faqItems[index]);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Still Need Help Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.contact_support,
                    size: 48,
                    color: AppTheme.infoColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Still need help?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Can\'t find what you\'re looking for? Our support team is here to help.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ContactScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Contact Us'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.infoColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FeedbackScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.feedback),
                          label: const Text('Send Feedback'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item.answer,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
