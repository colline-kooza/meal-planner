import 'package:flutter/material.dart';
import 'meal_item.dart';
import 'app_state_manager.dart';
import 'recipes_screen.dart';
import 'grocery_list_screen.dart';
import 'budget_screen.dart';
import 'preferences_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late AppStateManager _stateManager;
  List<MealItem> weeklyMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _stateManager = AppStateManager();
    await _stateManager.init();
    setState(() {
      weeklyMeals = _stateManager.getMealPlan();
      _isLoading = false;
    });
  }

  Future<void> _generateNewMealPlan() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF4CAF50)),
              SizedBox(height: 16),
              Text(
                'Generating meal plan...',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate meal plan generation
    await Future.delayed(Duration(seconds: 2));

    // Generate new meals based on preferences
    List<MealItem> newMeals = [
      MealItem(
        day: 'Monday',
        name: 'Mediterranean Quinoa Bowl',
        mealType: 'Dinner',
        imagePath: 'assets/images/quinoa.jpg',
      ),
      MealItem(
        day: 'Tuesday',
        name: 'Thai Green Curry',
        mealType: 'Dinner',
        imagePath: 'assets/images/curry.jpg',
      ),
      MealItem(
        day: 'Wednesday',
        name: 'Lemon Herb Chicken',
        mealType: 'Dinner',
        imagePath: 'assets/images/chicken_stirfry.jpg',
      ),
      MealItem(
        day: 'Thursday',
        name: 'Sushi Bowl',
        mealType: 'Dinner',
        imagePath: 'assets/images/salmon.jpg',
      ),
      MealItem(
        day: 'Friday',
        name: 'BBQ Pulled Jackfruit Tacos',
        mealType: 'Dinner',
        imagePath: 'assets/images/tacos.jpg',
      ),
      MealItem(
        day: 'Saturday',
        name: 'Homemade Margherita Pizza',
        mealType: 'Dinner',
        imagePath: 'assets/images/pizza.jpg',
      ),
      MealItem(
        day: 'Sunday',
        name: 'Herb Roasted Vegetables',
        mealType: 'Dinner',
        imagePath: 'assets/images/roast_chicken.jpg',
      ),
    ];

    await _stateManager.saveMealPlan(newMeals);

    Navigator.pop(context); // Close loading dialog

    setState(() {
      weeklyMeals = newMeals;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('New meal plan generated!'),
          ],
        ),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildMealListScreen() {
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
        title: Text(
          'Meal Plan',
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
            icon: Icon(Icons.settings_outlined, color: Colors.black, size: 22),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferencesScreen()),
              );
              if (result == true) {
                setState(() {
                  // Refresh UI after preferences change
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.black, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Share functionality coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // This Week Title
            Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'This Week',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            // Generate New Plan Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _generateNewMealPlan,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=800',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Generate New Plan',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Create a personalized meal plan for the week',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Preferences Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesScreen(),
                    ),
                  );
                  if (result == true) {
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: Color(0xFF4CAF50),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preferences',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${_stateManager.getDietaryPreference()} • \$${_stateManager.getWeeklyBudget().toStringAsFixed(0)}/week',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Color(0xFFD1D5DB),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 28),

            // Upcoming Meals Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Meals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${weeklyMeals.length} meals',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Meals List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: weeklyMeals.length,
              itemBuilder: (context, index) {
                final meal = weeklyMeals[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Meal Image
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Container(
                          width: 70,
                          height: 70,
                          child: Image.network(
                            _getMealImageUrl(meal.imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Color(0xFFE8F5E9),
                                child: Icon(
                                  Icons.restaurant,
                                  color: Color(0xFF4CAF50),
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Meal Details
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.day,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                meal.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Arrow Icon
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(0xFFD1D5DB),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getMealImageUrl(String imagePath) {
    if (imagePath.contains('chicken_stirfry')) {
      return 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400';
    } else if (imagePath.contains('curry')) {
      return 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400';
    } else if (imagePath.contains('pasta')) {
      return 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400';
    } else if (imagePath.contains('salmon')) {
      return 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400';
    } else if (imagePath.contains('tacos')) {
      return 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400';
    } else if (imagePath.contains('pizza')) {
      return 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400';
    } else if (imagePath.contains('roast_chicken') ||
        imagePath.contains('quinoa')) {
      return 'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400';
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildMealListScreen(),
      RecipesScreen(),
      GroceryListScreen(),
      BudgetScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF4CAF50),
        unselectedItemColor: Color(0xFF9CA3AF),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 22),
            activeIcon: Icon(Icons.calendar_today, size: 22),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined, size: 22),
            activeIcon: Icon(Icons.menu_book, size: 22),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted, size: 22),
            label: 'Grocery List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined, size: 22),
            activeIcon: Icon(Icons.account_balance_wallet, size: 22),
            label: 'Budget',
          ),
        ],
      ),
    );
  }
}
