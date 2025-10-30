import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'meal_item.dart';

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
  Future<void> saveMealPlan(List<MealItem> meals) async {
    final mealsJson = meals.map((m) => m.toJson()).toList();
    await _prefs?.setString('meal_plan', jsonEncode(mealsJson));
  }

  List<MealItem> getMealPlan() {
    final mealsString = _prefs?.getString('meal_plan');
    if (mealsString == null) return _getDefaultMealPlan();

    try {
      final List<dynamic> mealsJson = jsonDecode(mealsString);
      return mealsJson.map((m) => MealItem.fromJson(m)).toList();
    } catch (e) {
      return _getDefaultMealPlan();
    }
  }

  List<MealItem> _getDefaultMealPlan() {
    return [
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
