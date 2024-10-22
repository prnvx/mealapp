import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:mealapp/models/mealmodel.dart';
import 'package:mealapp/screens/categoryscreen.dart';
import 'package:mealapp/screens/dishesscreen.dart';
import 'package:mealapp/screens/loginscreen.dart';
import 'package:mealapp/screens/welcomescreen.dart';
import '../services/mealapiservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  List<MealModel> _newDishes = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isDarkTheme = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchNewDishes();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _username = userDoc['username'];
          });
        } else {
          print("User document does not exist");
        }
      } catch (e) {
        print("Error fetching username: $e");
      }
    } else {
      print("No user logged in");
    }
  }

  Future<List<MealModel>?> _searchMeals(String query) async {
    if (query.isEmpty) return [];
    setState(() => _isLoading = true);
    try {
      final mealApiService = MealApiService();
      final searchMeals = await mealApiService.searchMeals(query);
      return searchMeals;
    } catch (e) {
      _showCustomSnackbar(context, "Error fetching meals: $e");
      return [];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final mealApiService = MealApiService();
      final categories = await mealApiService.fetchCategories();
      if (categories != null) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      _showCustomSnackbar(context, "Error fetching categories: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchNewDishes() async {
    setState(() => _isLoading = true);
    try {
      final mealApiService = MealApiService();
      _newDishes = [];
      for (int i = 0; i < 10; i++) {
        final meal = await mealApiService.fetchRandomMeal();
        if (meal != null) {
          _newDishes.add(meal);
        }
      }
    } catch (e) {
      _showCustomSnackbar(context, "Error fetching new dishes: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCustomSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _isDarkTheme ? Colors.grey[850]! : Colors.white70,
              _isDarkTheme ? Colors.black : Colors.white70,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'asset/images/ferr-studio-G2Qjx1y9aAM-unsplash.jpg', // Replace with your image URL
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, size: 80);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _username.isNotEmpty ? _username : 'User Name',
                    style: TextStyle(
                        color: _isDarkTheme ? Colors.white : Colors.black,                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ..._buildDrawerItems(),
            SwitchListTile(
              title: Text('Dark Theme', style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black,)),
              value: _isDarkTheme,
              onChanged: (value) {
                setState(() {
                  _isDarkTheme = value;
                });
              },
              activeColor: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    return [
      ListTile(
        title: Text(
          'Home',
          style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black),
        ),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Welcomescreen()), // Navigate to WelcomeScreen
          );
        },
      ),

      ListTile(
        title: Text('Logout', style: TextStyle(color: Colors.redAccent)),
        onTap: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loginscreen()),
          );
          _showCustomSnackbar(context, "Logged out successfully!");
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        drawer: _buildDrawer(),
        body: Stack(
          children: [
            _buildBackground(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildAppBar(),
                    const SizedBox(height: 20),
                    _buildSearchField(),
                    const SizedBox(height: 10),
                    if (_isLoading) CircularProgressIndicator() else if (_newDishes.isEmpty)
                      Text("No new dishes found.", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Lottie.asset('asset/images/Animation - 1727675310463.json', height: 150),
                    const SizedBox(height: 20),
                    _buildCategoriesContainer(),
                    const SizedBox(height: 20),
                    _buildNewDishesContainer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            _isDarkTheme
                ? 'asset/images/max-kuntscher-Cpb2HY41bs8-unsplash.jpg' // Dark theme background
                : 'asset/images/jens-riesenberg-3D1e1poh2P0-unsplash.jpg', // Light theme background
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,color: _isDarkTheme ? Colors.white : Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        Center(
          child: Text(
            "Meal Finder",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _isDarkTheme ? Colors.white : Colors.black,),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TypeAheadField<MealModel>(
      suggestionsCallback: (pattern) async {
        return await _searchMeals(pattern);
      },
      itemBuilder: (context, MealModel meal) {
        return ListTile(
          title: Text(meal.strMeal ?? 'Unknown Meal'),
        );
      },
      onSelected: (MealModel meal) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dishesscreen(meal: meal),
          ),
        );
      },
      builder: (context, controller, focusNode) {
        return Container(
          decoration: BoxDecoration(
            color: _isDarkTheme ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _isDarkTheme ? Colors.black45 : Colors.grey[300]!,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(
              color: _isDarkTheme ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search for meals',
              hintStyle: TextStyle(
                color: _isDarkTheme ? Colors.white30 : Colors.black38,
              ),
              filled: false,
              prefixIcon: Icon(
                Icons.search,
                color: _isDarkTheme ? Colors.white : Colors.black,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isDarkTheme ? Colors.grey[800]! : Colors.white,
            _isDarkTheme ? Colors.black : Colors.grey[300]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _isDarkTheme ? Colors.black26 : Colors.grey[300]!,
            blurRadius: 10.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(categoryName: category.strCategory!),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Card(
                      color: _isDarkTheme ? Colors.grey[850] : Colors.white,
                      elevation: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          category.strCategoryThumb != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              category.strCategoryThumb!,
                              width: 90,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(),
                          const SizedBox(width: 1),
                          Text(
                            category.strCategory ?? 'Unknown Category',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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

  Widget _buildNewDishesContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isDarkTheme ? Colors.grey[800]! : Colors.white,
            _isDarkTheme ? Colors.black : Colors.grey[300]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _isDarkTheme ? Colors.black26 : Colors.grey[300]!,
            blurRadius: 10.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Dishes",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.75,
            ),
            itemCount: _newDishes.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final meal = _newDishes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dishesscreen(meal: meal),
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: _isDarkTheme ? Colors.grey[850] : Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        meal.strMealThumb != null
                            ? Image.network(
                          meal.strMealThumb!,
                          fit: BoxFit.cover,
                          height: 120,
                          width: double.infinity,
                        )
                            : Container(),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            meal.strMeal ?? 'Unknown Dish',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _isDarkTheme ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.strArea ?? 'Unknown Cuisine',
                          style: TextStyle(
                            color: _isDarkTheme ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
