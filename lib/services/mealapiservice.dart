import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mealapp/models/mealmodel.dart';

class MealApiService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fetches a list of meal categories from the API.
  Future<List<Category>?> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return (jsonData['categories'] as List)
            .map((category) => Category.fromJson(category))
            .toList();
      } else {
        throw Exception('Failed to load categories: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return null;
    }
  }

  // Fetches meals by the specified category.
  Future<List<MealModel>?> fetchMealsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return (jsonData['meals'] as List)
            .map((meal) => MealModel.fromJson(meal))
            .toList();
      } else {
        throw Exception('Failed to load meals for category: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching meals by category: $e");
      return null;
    }
  }

  // Fetches a list of random meals.
  Future<List<MealModel>?> fetchRandomMeals(int count) async {
    try {
      final List<Future<MealModel?>> requests = List.generate(
        count,
            (index) => fetchRandomMeal(),
      );

      final List<MealModel?> meals = await Future.wait(requests);
      return meals.where((meal) => meal != null).cast<MealModel>().toList();
    } catch (e) {
      print("Error fetching random meals: $e");
      return null;
    }
  }

  // Fetches a single random meal.
  Future<MealModel?> fetchRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MealModel.fromJson(jsonData['meals'][0]);
      } else {
        throw Exception('Failed to load random meal: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching random meal: $e");
      return null;
    }
  }

  // Searches for meals based on a query.
  Future<List<MealModel>?> searchMeals(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return (jsonData['meals'] as List)
            .map((meal) => MealModel.fromJson(meal))
            .toList();
      } else {
        throw Exception('Failed to search meals: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error searching meals: $e");
      return null;
    }
  }
}
