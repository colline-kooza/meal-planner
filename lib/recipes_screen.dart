import 'package:flutter/material.dart';

// Model for Recipe
class Recipe {
  String name;
  String description;
  String time;
  String cuisine;
  String dietary;
  String imageUrl;

  Recipe({
    required this.name,
    required this.description,
    required this.time,
    required this.cuisine,
    required this.dietary,
    required this.imageUrl,
  });
}

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String searchQuery = '';
  String selectedDietary = 'All';
  String selectedCuisine = 'All';
  String selectedMeal = 'All';

  // Sample recipes with real images
  List<Recipe> allRecipes = [
    Recipe(
      name: 'Mediterranean Quinoa Salad',
      description: 'A refreshing and healthy salad.',
      time: '30 min',
      cuisine: 'Mediterranean',
      dietary: 'Vegetarian',
      imageUrl:
          'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400',
    ),
    Recipe(
      name: 'Spicy Chicken Stir-Fry',
      description: 'A quick and easy stir-fry.',
      time: '45 min',
      cuisine: 'Asian',
      dietary: 'None',
      imageUrl:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
    ),
    Recipe(
      name: 'Creamy Tomato Pasta',
      description: 'A comforting pasta dish.',
      time: '1 hr 15 min',
      cuisine: 'Italian',
      dietary: 'Vegetarian',
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400',
    ),
    Recipe(
      name: 'Grilled Salmon',
      description: 'Healthy and delicious salmon.',
      time: '25 min',
      cuisine: 'American',
      dietary: 'Pescatarian',
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
    ),
    Recipe(
      name: 'Vegetable Curry',
      description: 'Aromatic and flavorful curry.',
      time: '50 min',
      cuisine: 'Asian',
      dietary: 'Vegan',
      imageUrl:
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
    ),
    Recipe(
      name: 'Classic Margherita Pizza',
      description: 'Simple and delicious pizza.',
      time: '35 min',
      cuisine: 'Italian',
      dietary: 'Vegetarian',
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
    ),
  ];

  List<Recipe> get filteredRecipes {
    return allRecipes.where((recipe) {
      final matchesSearch = recipe.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesDietary =
          selectedDietary == 'All' || recipe.dietary == selectedDietary;
      final matchesCuisine =
          selectedCuisine == 'All' || recipe.cuisine == selectedCuisine;
      return matchesSearch && matchesDietary && matchesCuisine;
    }).toList();
  }

  void _showFilterDialog(String filterType) {
    List<String> options = [];
    String currentValue = '';

    if (filterType == 'Dietary') {
      options = ['All', 'Vegetarian', 'Vegan', 'Pescatarian', 'None'];
      currentValue = selectedDietary;
    } else if (filterType == 'Cuisine') {
      options = [
        'All',
        'Mediterranean',
        'Asian',
        'Italian',
        'American',
        'Mexican',
      ];
      currentValue = selectedCuisine;
    } else if (filterType == 'Meal') {
      options = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack'];
      currentValue = selectedMeal;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select $filterType',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              ...options.map((option) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Text(option, style: TextStyle(fontSize: 15)),
                  trailing: currentValue == option
                      ? Icon(Icons.check, color: Color(0xFF4CAF50), size: 22)
                      : null,
                  onTap: () {
                    setState(() {
                      if (filterType == 'Dietary')
                        selectedDietary = option;
                      else if (filterType == 'Cuisine')
                        selectedCuisine = option;
                      else if (filterType == 'Meal')
                        selectedMeal = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Recipes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar & Filters
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search recipes',
                      hintStyle: TextStyle(
                        color: Color(0xFF4CAF50).withOpacity(0.6),
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF4CAF50),
                        size: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 14),

                // Filter Chips
                Row(
                  children: [
                    _buildFilterChip('Dietary', selectedDietary),
                    SizedBox(width: 10),
                    _buildFilterChip('Cuisine', selectedCuisine),
                    SizedBox(width: 10),
                    _buildFilterChip('Meal', selectedMeal),
                  ],
                ),
              ],
            ),
          ),

          // Recipes List
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No recipes found',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Recipe details coming soon!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recipe Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.time,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF4CAF50),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        recipe.name,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        recipe.description,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 12),

                                // Recipe Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      recipe.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: Color(0xFFE8F5E9),
                                              child: Icon(
                                                Icons.restaurant,
                                                color: Color(0xFF4CAF50),
                                                size: 32,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String currentValue) {
    return GestureDetector(
      onTap: () => _showFilterDialog(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}
