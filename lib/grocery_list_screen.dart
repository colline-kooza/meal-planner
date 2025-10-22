import 'package:flutter/material.dart';

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
}

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  // Store grocery items
  List<GroceryItem> groceries = [
    GroceryItem(name: 'Chicken Breast', quantity: '2 lbs', price: 8.99),
    GroceryItem(name: 'Broccoli', quantity: '1 bunch', price: 2.49),
    GroceryItem(name: 'Whole Wheat Bread', quantity: '1 loaf', price: 3.29),
    GroceryItem(name: 'Eggs', quantity: '1 dozen', price: 2.99),
    GroceryItem(
      name: 'Ground Beef',
      quantity: '1 lb',
      price: 5.49,
      isChecked: true,
    ),
    GroceryItem(name: 'Spinach', quantity: '1 bag', price: 2.79),
  ];

  // Calculate total price
  double get totalPrice {
    return groceries.fold(0, (sum, item) => sum + item.price);
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
                  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Items for this week
                    Text(
                      'Items for this week',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Grocery Items List
                    ...groceries.map((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Checkbox
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.isChecked = !item.isChecked;
                                });
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

                    SizedBox(height: 100), // Space for floating button
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
                content: Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                backgroundColor: Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
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
            'Total: \$${totalPrice.toStringAsFixed(2)}',
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
