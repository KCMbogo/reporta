import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../models/stock_transaction.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';
import 'add_edit_product_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Product _product;
  List<StockTransaction> _transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final transactions = await _databaseService.getStockTransactions(
        productId: _product.id,
      );
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transactions: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _refreshProduct() async {
    try {
      final updatedProduct = await _databaseService.getProductById(
        _product.id!,
      );
      if (updatedProduct != null) {
        setState(() {
          _product = updatedProduct;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing product: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _showStockDialog(TransactionType type) async {
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              '${type.name == 'stockIn'
                  ? 'Stock In'
                  : type.name == 'stockOut'
                  ? 'Stock Out'
                  : 'Sale'} - ${_product.name}',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Enter quantity',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  if (type == TransactionType.sale) ...[
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Price',
                        hintText: 'Enter unit price',
                        prefixText: '\$',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Enter notes',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (quantityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter quantity'),
                        backgroundColor: AppTheme.warningColor,
                      ),
                    );
                    return;
                  }

                  final quantity = int.tryParse(quantityController.text);
                  if (quantity == null || quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid quantity'),
                        backgroundColor: AppTheme.warningColor,
                      ),
                    );
                    return;
                  }

                  // Check if stock out/sale quantity is available
                  if ((type == TransactionType.stockOut ||
                          type == TransactionType.sale) &&
                      quantity > _product.stockQuantity) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Insufficient stock available'),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pop(true);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );

    if (result == true) {
      await _processStockTransaction(
        type,
        int.parse(quantityController.text),
        priceController.text.isNotEmpty
            ? double.parse(priceController.text)
            : null,
        notesController.text.isNotEmpty ? notesController.text : null,
      );
    }
  }

  Future<void> _processStockTransaction(
    TransactionType type,
    int quantity,
    double? unitPrice,
    String? notes,
  ) async {
    setState(() => _isLoading = true);

    try {
      final transaction = StockTransaction(
        productId: _product.id!,
        transactionType: type,
        quantity: quantity,
        unitPrice: unitPrice,
        totalAmount: unitPrice != null ? unitPrice * quantity : null,
        notes: notes,
      );

      await _databaseService.insertStockTransaction(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${transaction.transactionTypeDisplayName} recorded successfully',
          ),
          backgroundColor: AppTheme.successColor,
        ),
      );

      await _refreshProduct();
      await _loadTransactions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing transaction: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getStockStatusColor() {
    if (_product.stockQuantity == 0) return AppTheme.errorColor;
    if (_product.isLowStock) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditProductScreen(product: _product),
                ),
              );
              if (result == true) {
                await _refreshProduct();
                if (mounted) {
                  Navigator.of(context).pop(true);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _product.name,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (_product.description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _product.description,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _product.category,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Price and Stock Info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Price',
                            '${_getCurrencySymbol(_product.currency)}${_product.price.toStringAsFixed(2)}',
                            Icons.attach_money,
                            AppTheme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Stock',
                            '${_product.stockQuantity}',
                            Icons.inventory,
                            _getStockStatusColor(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            'Status',
                            _product.stockStatus,
                            Icons.info,
                            _getStockStatusColor(),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            'Low Stock Alert',
                            '${_product.lowStockThreshold}',
                            Icons.warning,
                            AppTheme.warningColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stock Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Management',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () =>
                                      _showStockDialog(TransactionType.stockIn),
                          icon: const Icon(Icons.add_box),
                          label: const Text('Stock In'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () => _showStockDialog(
                                    TransactionType.stockOut,
                                  ),
                          icon: const Icon(Icons.remove_circle),
                          label: const Text('Stock Out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _isLoading
                              ? null
                              : () => _showStockDialog(TransactionType.sale),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Record Sale'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            if (_transactions.isEmpty)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions yet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stock movements will appear here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount:
                    _transactions.length > 10 ? 10 : _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionCard(transaction);
                },
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(StockTransaction transaction) {
    final isIncrease = transaction.increasesStock;
    final color = isIncrease ? AppTheme.successColor : AppTheme.errorColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(isIncrease ? Icons.add : Icons.remove, color: color),
        ),
        title: Text(transaction.transactionTypeDisplayName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${isIncrease ? '+' : '-'}${transaction.quantity}'),
            if (transaction.totalAmount != null)
              Text('Amount: \$${transaction.totalAmount!.toStringAsFixed(2)}'),
            if (transaction.notes != null && transaction.notes!.isNotEmpty)
              Text('Notes: ${transaction.notes}'),
          ],
        ),
        trailing: Text(
          '${transaction.createdAt.day}/${transaction.createdAt.month}/${transaction.createdAt.year}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'TZS':
        return 'TSh ';
      default:
        return '\$';
    }
  }
}
