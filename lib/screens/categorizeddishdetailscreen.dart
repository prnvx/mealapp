import 'package:flutter/material.dart';
import '../models/mealmodel.dart';
import '../services/mealapiservice.dart';

class DishDetailScreen extends StatefulWidget {
  final MealModel meal; // Pass the MealModel instance to the screen

  const DishDetailScreen({Key? key, required this.meal}) : super(key: key);

  @override
  _DishDetailScreenState createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  late Future<MealModel?> futureMeal;

  @override
  void initState() {
    super.initState();
    futureMeal = MealApiService().fetchRandomMeal(); // Fetch a random meal if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MealModel?>(
        future: futureMeal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No meal found.'));
          } else {
            final meal = snapshot.data!;
            return _buildMealDetail(context, meal);
          }
        },
      ),
    );
  }

  Widget _buildMealDetail(BuildContext context, MealModel meal) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/images/tishine-ndiaye-rpPVZsMTZZc-unsplash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite, color: Colors.white),
                      onPressed: () {
                        // Handle favorite action
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (meal.strMealThumb != null)
                      ClipOval(
                        child: Image.network(
                          meal.strMealThumb!,
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      meal.strMeal ?? 'Unknown Meal',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${meal.strCategory ?? 'Unknown'}',
                      style: TextStyle(fontSize: 25, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Instructions: ${meal.strInstructions ?? 'No instructions available.'}',
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    _buildIngredientsList(context, meal),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(BuildContext context, MealModel meal) {
    final ingredients = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = meal.toJson()['strIngredient$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
      }
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? LinearGradient(
          colors: [Colors.black54, Colors.grey[850]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(
          colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                final imageUrl = 'https://www.themealdb.com/images/ingredients/$ingredient.png';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: isDarkMode ? Colors.grey[800] : Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              imageUrl,
                              height: 40,
                              width: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, size: 60);
                              },
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ingredient,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                            textAlign: TextAlign.center,
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
}
