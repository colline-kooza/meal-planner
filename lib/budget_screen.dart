import 'package:flutter/material.dart';
import 'app_state_manager.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final AppStateManager _stateManager = AppStateManager();
  double monthlyBudget = 500.0;
  double spentAmount = 0.0;
  bool _isLoading = true;

  // Spending by category
  List<Map<String, dynamic>> categorySpending = [
    {'category': 'Produce', 'amount': 0.0, 'color': Color(0xFF4CAF50)},
    {'category': 'Dairy', 'amount': 0.0, 'color': Color(0xFF2196F3)},
    {'category': 'Meat', 'amount': 0.0, 'color': Color(0xFFFF5722)},
    {'category': 'Pantry', 'amount': 0.0, 'color': Color(0xFFFF9800)},
  ];

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  Future<void> _loadBudgetData() async {
    await _stateManager.init();
    setState(() {
      monthlyBudget = _stateManager.getMonthlyBudget();
      spentAmount = _stateManager.getSpentAmount();
      _isLoading = false;
    });

    // Distribute spent amount across categories
    _distributeCategorySpending();
  }

  void _distributeCategorySpending() {
    if (spentAmount > 0) {
      // Distribute spending across categories with some variance
      setState(() {
        categorySpending[0]['amount'] = spentAmount * 0.35; // Produce
        categorySpending[1]['amount'] = spentAmount * 0.25; // Dairy
        categorySpending[2]['amount'] = spentAmount * 0.30; // Meat
        categorySpending[3]['amount'] = spentAmount * 0.10; // Pantry
      });
    }
  }

  double get remainingBudget => monthlyBudget - spentAmount;

  double get budgetPercentage =>
      monthlyBudget > 0 ? (spentAmount / monthlyBudget) : 0;

  String get budgetStatus {
    if (budgetPercentage >= 0.9) return 'Over Budget!';
    if (budgetPercentage >= 0.75) return 'Watch Spending';
    return 'On Track';
  }

  Color get budgetStatusColor {
    if (budgetPercentage >= 0.9) return Color(0xFFEF4444);
    if (budgetPercentage >= 0.75) return Color(0xFFFF9800);
    return Color(0xFF4CAF50);
  }

  void _showBudgetSettingsDialog() {
    double newBudget = monthlyBudget;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Set Monthly Budget',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newBudget = double.tryParse(value) ?? monthlyBudget;
                },
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Budget Amount',
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Set a realistic monthly budget for groceries',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
              onPressed: () async {
                setState(() {
                  monthlyBudget = newBudget;
                });
                await _stateManager.saveMonthlyBudget(newBudget);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Budget updated to \$${newBudget.toStringAsFixed(0)}',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetSpending() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Spending',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        content: Text(
          'This will reset your spending to \$0. Are you sure?',
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
            onPressed: () async {
              setState(() {
                spentAmount = 0.0;
              });
              await _stateManager.saveSpentAmount(0.0);
              _distributeCategorySpending();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Spending reset successfully'),
                  backgroundColor: Color(0xFF4CAF50),
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
              'Reset',
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
          'Budget',
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
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black, size: 22),
            onPressed: _showBudgetSettingsDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Status Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      budgetStatusColor,
                      budgetStatusColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: budgetStatusColor.withOpacity(0.3),
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
                              budgetStatus,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$${remainingBudget.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'remaining',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${(budgetPercentage * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: budgetPercentage.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Budget Overview Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Color(0xFF4CAF50),
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Budget',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$${monthlyBudget.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'per month',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag,
                                color: Color(0xFFFF5722),
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Spent',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$${spentAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'this month',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Spending Breakdown Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spending Breakdown',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (spentAmount > 0)
                    TextButton.icon(
                      onPressed: _resetSpending,
                      icon: Icon(
                        Icons.refresh,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                      label: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Category Chart
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending by Category',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Simple Bar Chart
                    Container(
                      height: 180,
                      child: spentAmount == 0
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 48,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No spending data yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: categorySpending.map((data) {
                                double maxAmount = spentAmount;
                                double heightPercentage = maxAmount > 0
                                    ? (data['amount'] / maxAmount).clamp(
                                        0.0,
                                        1.0,
                                      )
                                    : 0.0;

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${data['amount'].toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: data['color'],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      width: 50,
                                      height: heightPercentage * 100 + 20,
                                      decoration: BoxDecoration(
                                        color: data['color'],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      data['category'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Tips Section
              Text(
                'Tips to Save Money',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),

              _buildTipCard(
                icon: Icons.calendar_today,
                title: 'Plan Your Meals',
                description:
                    'Weekly meal planning helps avoid impulse purchases and reduces food waste.',
                color: Color(0xFF4CAF50),
              ),
              SizedBox(height: 12),
              _buildTipCard(
                icon: Icons.local_offer,
                title: 'Use Coupons & Sales',
                description:
                    'Check weekly flyers and use digital coupons to maximize savings.',
                color: Color(0xFF2196F3),
              ),
              SizedBox(height: 12),
              _buildTipCard(
                icon: Icons.shopping_bag,
                title: 'Buy Generic Brands',
                description:
                    'Store brands often offer the same quality at lower prices.',
                color: Color(0xFFFF9800),
              ),
              SizedBox(height: 12),
              _buildTipCard(
                icon: Icons.restaurant,
                title: 'Cook at Home',
                description:
                    'Preparing meals at home is significantly cheaper than dining out.',
                color: Color(0xFF9C27B0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
