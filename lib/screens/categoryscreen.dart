import 'package:flutter/material.dart';
import '../models/mealmodel.dart';
import '../services/mealapiservice.dart';
import 'categorizeddishdetailscreen.dart';
 // Ensure the import is correct

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<MealModel> _dishes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDishes();
  }

  Future<void> _fetchDishes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final mealApiService = MealApiService();
      final dishes = await mealApiService.fetchMealsByCategory(widget.categoryName);
      setState(() {
        _dishes = dishes ?? [];
      });
    } catch (e) {
      _showCustomSnackbar(context, "Error fetching dishes: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCustomSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Dishes"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchDishes,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _dishes.isEmpty
          ? Center(child: Text("No ${widget.categoryName} dishes found."))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
          ),
          itemCount: _dishes.length,
          itemBuilder: (context, index) {
            final meal = _dishes[index];
            return _buildDishCard(context, meal);
          },
        ),
      ),
    );
  }

  Widget _buildDishCard(BuildContext context, MealModel meal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DishDetailScreen(meal: meal), // Navigate to DishDetailScreen
          ),
        );
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.grey.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  meal.strMealThumb != null
                      ? Image.network(
                    meal.strMealThumb!,
                    fit: BoxFit.cover,
                    height: 120,
                    width: double.infinity,
                  )
                      : Container(
                    height: 120,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      meal.strMeal ?? 'Unknown Dish',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap to view",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
