import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/complaint.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  
  final _titleController = TextEditingController();
  final _complaintController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  ComplaintPriority _selectedPriority = ComplaintPriority.medium;
  bool _isLoading = false;
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _complaintController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title for your complaint';
    }
    if (value.trim().length < 5) {
      return 'Title must be at least 5 characters long';
    }
    return null;
  }

  String? _validateComplaint(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please describe your complaint';
    }
    if (value.trim().length < 20) {
      return 'Complaint description must be at least 20 characters long';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (!_isAnonymous && (value == null || value.trim().isEmpty)) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (!_isAnonymous && (value == null || value.trim().isEmpty)) {
      return 'Please enter your email';
    }
    if (!_isAnonymous && value != null && value.isNotEmpty) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final complaint = Complaint(
        userId: authProvider.currentUser?.id,
        title: _titleController.text.trim(),
        complaint: _complaintController.text.trim(),
        priority: _selectedPriority,
        name: _isAnonymous ? null : _nameController.text.trim(),
        email: _isAnonymous ? null : _emailController.text.trim(),
        phoneNumber: _isAnonymous ? null : _phoneController.text.trim(),
      );

      await _databaseService.insertComplaint(complaint);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your complaint has been submitted successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting complaint: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitComplaint,
            child: Text(
              'Submit',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.report_problem,
                        size: 48,
                        color: AppTheme.warningColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Report an Issue',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We take all complaints seriously. Please provide as much detail as possible to help us resolve your issue quickly.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Priority Level
              Text(
                'Priority Level',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: ComplaintPriority.values.map((priority) {
                      return RadioListTile<ComplaintPriority>(
                        title: Text(_getPriorityDisplayName(priority)),
                        subtitle: Text(_getPriorityDescription(priority)),
                        value: priority,
                        groupValue: _selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Issue Title',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Brief description of the issue',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: _validateTitle,
              ),

              const SizedBox(height: 20),

              // Complaint Description
              Text(
                'Detailed Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _complaintController,
                decoration: const InputDecoration(
                  hintText: 'Please describe the issue in detail, including steps to reproduce if applicable...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: _validateComplaint,
              ),

              const SizedBox(height: 20),

              // Anonymous Option
              CheckboxListTile(
                title: const Text('Submit anonymously'),
                subtitle: const Text('Your contact information will not be stored'),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              if (!_isAnonymous) ...[
                const SizedBox(height: 16),

                // Contact Information
                Text(
                  'Contact Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We may need to contact you for additional information or to provide updates on your complaint.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validateName,
                ),

                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address *',
                    hintText: 'Enter your email address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),

                const SizedBox(height: 16),

                // Phone (Optional)
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Optional)',
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.warningColor,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Submit Complaint'),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),

              const SizedBox(height: 16),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.infoColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: AppTheme.infoColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Important Information',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.infoColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• All complaints are stored locally on your device\n'
                      '• We aim to address all issues promptly\n'
                      '• For urgent matters, please contact support directly\n'
                      '• Your privacy and data security are our priority',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityDisplayName(ComplaintPriority priority) {
    switch (priority) {
      case ComplaintPriority.low:
        return 'Low Priority';
      case ComplaintPriority.medium:
        return 'Medium Priority';
      case ComplaintPriority.high:
        return 'High Priority';
      case ComplaintPriority.urgent:
        return 'Urgent';
    }
  }

  String _getPriorityDescription(ComplaintPriority priority) {
    switch (priority) {
      case ComplaintPriority.low:
        return 'Minor issues or suggestions';
      case ComplaintPriority.medium:
        return 'General problems affecting functionality';
      case ComplaintPriority.high:
        return 'Significant issues impacting usage';
      case ComplaintPriority.urgent:
        return 'Critical problems requiring immediate attention';
    }
  }
}
