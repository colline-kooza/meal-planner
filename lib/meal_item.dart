// Model for Meal Item
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

  Map<String, dynamic> toJson() => {
        'day': day,
        'name': name,
        'mealType': mealType,
        'imagePath': imagePath,
      };

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
        day: json['day'],
        name: json['name'],
        mealType: json['mealType'],
        imagePath: json['imagePath'],
      );
}
