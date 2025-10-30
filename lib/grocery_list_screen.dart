import 'package:flutter/material.dart';
import 'dart:convert';
import 'app_state_manager.dart';

// Model for Grocery Item
class GroceryItem {
  String name;
  String quantity;
  double price;
  bool isChecked;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'price': price,
        'isChecked': isChecked,
      };

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
        name: json['name'],
        quantity: json['quantity'],
        price: json['price'],
        isChecked: json['isChecked'] ?? false,
      );
}

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final AppStateManager _stateManager = AppStateManager();
  List<GroceryItem> groceries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroceries();
  }

  Future<void> _loadGroceries() async {
    await _stateManager.init();
    final groceriesString = _stateManager.getGroceries();

    if (groceriesString != null) {
      try {
        final List<dynamic> groceriesJson = jsonDecode(groceriesString);
        setState(() {
          groceries =
              groceriesJson.map((g) => GroceryItem.fromJson(g)).toList();
          _isLoading = false;
        });
      } catch (e) {
        _setDefaultGroceries();
      }
    } else {
      _setDefaultGroceries();
    }

    // Update spent amount in budget
    _updateSpentAmount();
  }

  void _setDefaultGroceries() {
    setState(() {
      groceries = [
        GroceryItem(name: 'Chicken Breast', quantity: '2 lbs', price: 8.99),
        GroceryItem(name: 'Broccoli', quantity: '1 bunch', price: 2.49),
        GroceryItem(name: 'Whole Wheat Bread', quantity: '1 loaf', price: 3.29),
        GroceryItem(name: 'Eggs', quantity: '1 dozen', price: 2.99),
        GroceryItem(name: 'Ground Beef', quantity: '1 lb', price: 5.49),
        GroceryItem(name: 'Spinach', quantity: '1 bag', price: 2.79),
      ];
      _isLoading = false;
    });
    _saveGroceries();
  }

  Future<void> _saveGroceries() async {
    final groceriesJson = groceries.map((g) => g.toJson()).toList();
    await _stateManager.saveGroceries(jsonEncode(groceriesJson));
    _updateSpentAmount();
  }

  Future<void> _updateSpentAmount() async {
    final checkedTotal = groceries
        .where((item) => item.isChecked)
        .fold(0.0, (sum, item) => sum + item.price);
    await _stateManager.saveSpentAmount(checkedTotal);
  }

  double get totalPrice {
    return groceries.fold(0, (sum, item) => sum + item.price);
  }

  double get checkedTotal {
    return groceries
        .where((item) => item.isChecked)
        .fold(0.0, (sum, item) => sum + item.price);
  }

  int get checkedCount {
    return groceries.where((item) => item.isChecked).length;
  }

  void _showAddItemDialog() {
    String itemName = '';
    String itemQuantity = '';
    double itemPrice = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add Grocery Item',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => itemName = value,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  onChanged: (value) => itemQuantity = value,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  onChanged: (value) =>
                      itemPrice = double.tryParse(value) ?? 0.0,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(fontSize: 14),
                    prefixText: '\$ ',
                    filled: true,
                    fillColor: Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (itemName.isNotEmpty && itemQuantity.isNotEmpty) {
                  setState(() {
                    groceries.add(
                      GroceryItem(
                        name: itemName,
                        quantity: itemQuantity,
                        price: itemPrice,
                      ),
                    );
                  });
                  _saveGroceries();
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('$itemName added to list'),
                        ],
                      ),
                      backgroundColor: Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    final item = groceries[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Item',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: Text(
          'Are you sure you want to remove "${item.name}" from your list?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                groceries.removeAt(index);
              });
              _saveGroceries();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} removed'),
                  backgroundColor: Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCheckedItems() {
    if (checkedCount == 0) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear Checked Items',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: Text(
          'Remove all $checkedCount checked items from your list?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                groceries.removeWhere((item) => item.isChecked);
              });
              _saveGroceries();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Checked items cleared'),
                  backgroundColor: Color(0xFF4CAF50),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              'Clear',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Grocery List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (checkedCount > 0)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 22,
              ),
              onPressed: _clearCheckedItems,
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Card
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shopping Progress',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '$checkedCount of ${groceries.length} items',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$${checkedTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value:
                        groceries.isEmpty ? 0 : checkedCount / groceries.length,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Items for this week
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Items for this week',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Grocery Items List
                    ...groceries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Dismissible(
                        key: Key('${item.name}_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onDismissed: (direction) {
                          final deletedItem = item;
                          setState(() {
                            groceries.removeAt(index);
                          });
                          _saveGroceries();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${deletedItem.name} removed'),
                              backgroundColor: Color(0xFFEF4444),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    groceries.insert(index, deletedItem);
                                  });
                                  _saveGroceries();
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: item.isChecked
                                ? Border.all(color: Color(0xFF4CAF50), width: 2)
                                : null,
                          ),
                          child: Row(
                            children: [
                              // Checkbox
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item.isChecked = !item.isChecked;
                                  });
                                  _saveGroceries();
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: item.isChecked
                                        ? Color(0xFF4CAF50)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: item.isChecked
                                          ? Color(0xFF4CAF50)
                                          : Color(0xFFE8F5E9),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: item.isChecked
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: 14),

                              // Item Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: item.isChecked
                                            ? Colors.grey[400]
                                            : Colors.black,
                                        decoration: item.isChecked
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      item.quantity,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: item.isChecked
                                            ? Colors.grey[300]
                                            : Color(0xFF4CAF50),
                                        decoration: item.isChecked
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Price
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: item.isChecked
                                      ? Colors.grey[400]
                                      : Colors.black,
                                  decoration: item.isChecked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 24),

                    // Additional Items Section
                    Text(
                      'Additional Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Add Custom Item Button
                    GestureDetector(
                      onTap: _showAddItemDialog,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF4CAF50),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Color(0xFF4CAF50),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Add custom item',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    Text(
                      'Checked: \$${checkedTotal.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                backgroundColor: Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
          backgroundColor: Color(0xFF4CAF50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          icon: Icon(Icons.shopping_cart, color: Colors.white, size: 20),
          label: Text(
            'Total: \$${totalPrice.toStringAsFixed(2)} • ${groceries.length} items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
