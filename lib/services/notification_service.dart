import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _lowStockAlertsKey = 'low_stock_alerts';
  static const String _salesNotificationsKey = 'sales_notifications';

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request notification permissions
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    // Handle notification tap
    debugPrint('Notification tapped: ${notificationResponse.payload}');
  }

  // Notification preference getters and setters
  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<bool> getLowStockAlertsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_lowStockAlertsKey) ?? true;
  }

  Future<void> setLowStockAlertsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_lowStockAlertsKey, enabled);
  }

  Future<bool> getSalesNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_salesNotificationsKey) ?? false;
  }

  Future<void> setSalesNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_salesNotificationsKey, enabled);
  }

  // Show low stock notification
  Future<void> showLowStockNotification({
    required String productName,
    required int currentStock,
    required int threshold,
  }) async {
    final notificationsEnabled = await getNotificationsEnabled();
    final lowStockAlertsEnabled = await getLowStockAlertsEnabled();

    if (!notificationsEnabled || !lowStockAlertsEnabled) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'low_stock_channel',
          'Low Stock Alerts',
          channelDescription: 'Notifications for low stock items',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Low Stock Alert',
      '$productName is running low! Only $currentStock left (threshold: $threshold)',
      platformChannelSpecifics,
      payload: 'low_stock:$productName',
    );
  }

  // Show sales notification
  Future<void> showSalesNotification({
    required String productName,
    required int quantity,
    required double totalAmount,
    required String currency,
  }) async {
    final notificationsEnabled = await getNotificationsEnabled();
    final salesNotificationsEnabled = await getSalesNotificationsEnabled();

    if (!notificationsEnabled || !salesNotificationsEnabled) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'sales_channel',
          'Sales Notifications',
          channelDescription: 'Notifications for sales activities',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Sale Recorded',
      'Sold $quantity x $productName for $currency ${totalAmount.toStringAsFixed(2)}',
      platformChannelSpecifics,
      payload: 'sale:$productName',
    );
  }

  // Show general notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final notificationsEnabled = await getNotificationsEnabled();
    if (!notificationsEnabled) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'general_channel',
          'General Notifications',
          channelDescription: 'General app notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
