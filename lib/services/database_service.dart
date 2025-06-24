import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/product.dart';
import '../models/stock_transaction.dart';
import '../models/feedback.dart';
import '../models/complaint.dart';
import 'notification_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reporta.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _createTables,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Add missing columns to existing tables
      try {
        await db.execute(
          'ALTER TABLE products ADD COLUMN category TEXT NOT NULL DEFAULT "General"',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE products ADD COLUMN currency TEXT NOT NULL DEFAULT "USD"',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE stock_transactions ADD COLUMN unit_price REAL',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE stock_transactions ADD COLUMN total_amount REAL',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE stock_transactions ADD COLUMN reference TEXT',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE complaints ADD COLUMN title TEXT NOT NULL DEFAULT ""',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute('ALTER TABLE complaints ADD COLUMN phone_number TEXT');
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute('ALTER TABLE complaints ADD COLUMN resolved_at TEXT');
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE user_feedback ADD COLUMN type TEXT NOT NULL DEFAULT "general"',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute(
          'ALTER TABLE user_feedback ADD COLUMN rating INTEGER NOT NULL DEFAULT 5',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute('ALTER TABLE user_feedback ADD COLUMN email TEXT');
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute('ALTER TABLE user_feedback ADD COLUMN name TEXT');
      } catch (e) {
        // Column might already exist
      }
    }

    if (oldVersion < 3) {
      // Add missing columns that were causing errors
      try {
        await db.execute(
          'ALTER TABLE complaints ADD COLUMN priority TEXT NOT NULL DEFAULT "medium"',
        );
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute('ALTER TABLE products ADD COLUMN image_url TEXT');
      } catch (e) {
        // Column might already exist
      }
    }

    if (oldVersion < 4) {
      // Add missing email and name columns to complaints table
      try {
        await db.execute('ALTER TABLE complaints ADD COLUMN email TEXT');
      } catch (e) {
        // Column might already exist
      }

      try {
        await db.execute('ALTER TABLE complaints ADD COLUMN name TEXT');
      } catch (e) {
        // Column might already exist
      }
    }
  }

  Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        security_answer TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        stock_quantity INTEGER NOT NULL DEFAULT 0,
        low_stock_threshold INTEGER NOT NULL DEFAULT 10,
        category TEXT NOT NULL DEFAULT 'General',
        currency TEXT NOT NULL DEFAULT 'USD',
        image_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Stock transactions table
    await db.execute('''
      CREATE TABLE stock_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        transaction_type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL,
        total_amount REAL,
        notes TEXT,
        reference TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // User feedback table
    await db.execute('''
      CREATE TABLE user_feedback (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        feedback TEXT NOT NULL,
        type TEXT NOT NULL DEFAULT 'general',
        rating INTEGER NOT NULL DEFAULT 5,
        email TEXT,
        name TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Complaints table
    await db.execute('''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT NOT NULL,
        complaint TEXT NOT NULL,
        priority TEXT NOT NULL DEFAULT 'medium',
        status TEXT NOT NULL DEFAULT 'pending',
        email TEXT,
        name TEXT,
        phone_number TEXT,
        created_at TEXT NOT NULL,
        resolved_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  // Hash password for security
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    final hashedUser = user.copyWith(password: _hashPassword(user.password));
    return await db.insert('users', hashedUser.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> validateUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null) {
      return user.password == _hashPassword(password);
    }
    return false;
  }

  Future<bool> validateSecurityAnswer(String email, String answer) async {
    final user = await getUserByEmail(email);
    if (user != null) {
      return user.securityAnswer.toLowerCase() == answer.toLowerCase();
    }
    return false;
  }

  Future<int> updateUserPassword(String email, String newPassword) async {
    final db = await database;
    return await db.update(
      'users',
      {'password': _hashPassword(newPassword)},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Check if email already exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Get total products count (placeholder for dashboard)
  Future<int> getTotalProductsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
    return result.first['count'] as int;
  }

  // Get low stock products count (placeholder for dashboard)
  Future<int> getLowStockCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM products WHERE stock_quantity <= low_stock_threshold',
    );
    return result.first['count'] as int;
  }

  // Product operations
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> getLowStockProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM products WHERE stock_quantity <= low_stock_threshold ORDER BY stock_quantity ASC',
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ? OR description LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    // Also delete related stock transactions
    await db.delete(
      'stock_transactions',
      where: 'product_id = ?',
      whereArgs: [id],
    );
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateProductStock(int productId, int newQuantity) async {
    final db = await database;
    return await db.update(
      'products',
      {
        'stock_quantity': newQuantity,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // Stock transaction operations
  Future<int> insertStockTransaction(StockTransaction transaction) async {
    final db = await database;
    final notificationService = NotificationService();

    // Insert the transaction
    final transactionId = await db.insert(
      'stock_transactions',
      transaction.toMap(),
    );

    // Update product stock quantity
    final product = await getProductById(transaction.productId);
    if (product != null) {
      final newQuantity = product.stockQuantity + transaction.effectiveQuantity;
      await updateProductStock(transaction.productId, newQuantity);

      // Get updated product to check for low stock
      final updatedProduct = await getProductById(transaction.productId);
      if (updatedProduct != null) {
        // Check for low stock notification
        if (updatedProduct.isLowStock && updatedProduct.stockQuantity > 0) {
          await notificationService.showLowStockNotification(
            productName: updatedProduct.name,
            currentStock: updatedProduct.stockQuantity,
            threshold: updatedProduct.lowStockThreshold,
          );
        }

        // Check for sales notification
        if (transaction.transactionType == TransactionType.sale &&
            transaction.totalAmount != null) {
          await notificationService.showSalesNotification(
            productName: updatedProduct.name,
            quantity: transaction.quantity,
            totalAmount: transaction.totalAmount!,
            currency: updatedProduct.currency,
          );
        }
      }
    }

    return transactionId;
  }

  Future<List<StockTransaction>> getStockTransactions({int? productId}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (productId != null) {
      maps = await db.query(
        'stock_transactions',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'created_at DESC',
      );
    } else {
      maps = await db.query('stock_transactions', orderBy: 'created_at DESC');
    }

    return List.generate(maps.length, (i) => StockTransaction.fromMap(maps[i]));
  }

  Future<List<Map<String, dynamic>>> getStockTransactionsWithProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT st.*, p.name as product_name, p.category as product_category
      FROM stock_transactions st
      JOIN products p ON st.product_id = p.id
      ORDER BY st.created_at DESC
    ''');
    return maps;
  }

  Future<double> getTotalSalesAmount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = "transaction_type = 'sale'";
    List<dynamic> whereArgs = [];

    if (startDate != null) {
      whereClause += " AND created_at >= ?";
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereClause += " AND created_at <= ?";
      whereArgs.add(endDate.toIso8601String());
    }

    final result = await db.rawQuery(
      'SELECT SUM(total_amount) as total FROM stock_transactions WHERE $whereClause',
      whereArgs,
    );

    return (result.first['total'] as double?) ?? 0.0;
  }

  // Feedback operations
  Future<int> insertFeedback(UserFeedback feedback) async {
    final db = await database;
    return await db.insert('user_feedback', feedback.toMap());
  }

  Future<List<UserFeedback>> getAllFeedback() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_feedback',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => UserFeedback.fromMap(maps[i]));
  }

  Future<int> deleteFeedback(int id) async {
    final db = await database;
    return await db.delete('user_feedback', where: 'id = ?', whereArgs: [id]);
  }

  // Complaint operations
  Future<int> insertComplaint(Complaint complaint) async {
    final db = await database;
    return await db.insert('complaints', complaint.toMap());
  }

  Future<List<Complaint>> getAllComplaints() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'complaints',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Complaint.fromMap(maps[i]));
  }

  Future<int> updateComplaintStatus(int id, ComplaintStatus status) async {
    final db = await database;
    return await db.update(
      'complaints',
      {
        'status': status.name,
        'resolved_at':
            status == ComplaintStatus.resolved
                ? DateTime.now().toIso8601String()
                : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteComplaint(int id) async {
    final db = await database;
    return await db.delete('complaints', where: 'id = ?', whereArgs: [id]);
  }

  // Reset database (for development/testing)
  Future<void> resetDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'reporta.db');
    await deleteDatabase(dbPath);
    _database = null;
    await database; // This will recreate the database
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
