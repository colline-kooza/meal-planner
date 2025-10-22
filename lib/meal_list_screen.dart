import 'package:flutter/material.dart';
import 'meal_plan_screen.dart';
import 'recipes_screen.dart';
import 'grocery_list_screen.dart';
import 'budget_screen.dart';
import 'preferences_screen.dart';

// Model for Meal
class MealItem {
  String day;
  String name;
  String mealType;
  String imagePath;

  MealItem({
    required this.day,
    required this.name,
    required this.mealType,
    required this.imagePath,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Sample weekly meals
  List<MealItem> weeklyMeals = [
    MealItem(
      day: 'Monday',
      name: 'Chicken Stir-Fry',
      mealType: 'Dinner',
      imagePath: 'assets/images/chicken_stirfry.jpg',
    ),
    MealItem(
      day: 'Tuesday',
      name: 'Vegetable Curry',
      mealType: 'Dinner',
      imagePath: 'assets/images/curry.jpg',
    ),
    MealItem(
      day: 'Wednesday',
      name: 'Pasta with Pesto',
      mealType: 'Dinner',
      imagePath: 'assets/images/pasta.jpg',
    ),
    MealItem(
      day: 'Thursday',
      name: 'Grilled Salmon',
      mealType: 'Dinner',
      imagePath: 'assets/images/salmon.jpg',
    ),
    MealItem(
      day: 'Friday',
      name: 'Taco Night',
      mealType: 'Dinner',
      imagePath: 'assets/images/tacos.jpg',
    ),
    MealItem(
      day: 'Saturday',
      name: 'Pizza Night',
      mealType: 'Dinner',
      imagePath: 'assets/images/pizza.jpg',
    ),
    MealItem(
      day: 'Sunday',
      name: 'Roast Chicken',
      mealType: 'Dinner',
      imagePath: 'assets/images/roast_chicken.jpg',
    ),
  ];

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildMealListScreen(),
      RecipesScreen(),
      GroceryListScreen(),
      BudgetScreen(),
    ];
  }

  Widget _buildMealListScreen() {
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferencesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.black, size: 22),
            onPressed: () {},
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
                        Colors.black.withOpacity(0.4),
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
              ),
            ),

            SizedBox(height: 16),

            // Preferences Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesScreen(),
                    ),
                  );
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
                              'Set dietary preferences & budget',
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
              child: Text(
                'Upcoming Meals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
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

  // Get real meal images from Unsplash
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
    } else if (imagePath.contains('roast_chicken')) {
      return 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400';
    }
    return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
