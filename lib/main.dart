import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app state manager
  await AppStateManager().init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MealPlannerApp());
}

class MealPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        fontFamily: 'System',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4CAF50),
          primary: Color(0xFF4CAF50),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF4CAF50),
          unselectedItemColor: Color(0xFF9CA3AF),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF8F9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Meal Planner',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Plan • Shop • Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 48),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Global App State Manager
class AppStateManager {
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User Authentication
  Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool('is_logged_in', value);
  }

  bool isLoggedIn() {
    return _prefs?.getBool('is_logged_in') ?? false;
  }

  Future<void> setUserEmail(String email) async {
    await _prefs?.setString('user_email', email);
  }

  String getUserEmail() {
    return _prefs?.getString('user_email') ?? '';
  }

  // Meal Plan Management
  Future<void> saveMealPlan(String mealsJson) async {
    await _prefs?.setString('meal_plan', mealsJson);
  }

  String? getMealPlan() {
    return _prefs?.getString('meal_plan');
  }

  // Budget Management
  Future<void> saveMonthlyBudget(double budget) async {
    await _prefs?.setDouble('monthly_budget', budget);
  }

  double getMonthlyBudget() {
    return _prefs?.getDouble('monthly_budget') ?? 500.0;
  }

  Future<void> saveSpentAmount(double amount) async {
    await _prefs?.setDouble('spent_amount', amount);
  }

  double getSpentAmount() {
    return _prefs?.getDouble('spent_amount') ?? 0.0;
  }

  // Preferences Management
  Future<void> saveDietaryPreference(String diet) async {
    await _prefs?.setString('dietary_preference', diet);
  }

  String getDietaryPreference() {
    return _prefs?.getString('dietary_preference') ?? 'None';
  }

  Future<void> saveAllergies(String allergies) async {
    await _prefs?.setString('allergies', allergies);
  }

  String getAllergies() {
    return _prefs?.getString('allergies') ?? '';
  }

  Future<void> saveWeeklyBudget(double budget) async {
    await _prefs?.setDouble('weekly_budget', budget);
  }

  double getWeeklyBudget() {
    return _prefs?.getDouble('weekly_budget') ?? 100.0;
  }

  // Grocery List Management
  Future<void> saveGroceries(String groceriesJson) async {
    await _prefs?.setString('groceries', groceriesJson);
  }

  String? getGroceries() {
    return _prefs?.getString('groceries');
  }
}
