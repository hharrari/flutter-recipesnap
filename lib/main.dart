import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(RecipeSnapApp());
}

// ------------------------------------------------------
// Recipe Model (with TIP included)
// ------------------------------------------------------
class Recipe {
  final String title;
  final String image;
  final String description;
  final List<String> ingredients;
  final String tip; // NEW FIELD

  Recipe({
    required this.title,
    required this.image,
    required this.description,
    required this.ingredients,
    required this.tip, // NEW FIELD
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      image: json['image'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      tip: json['tip'], // NEW FIELD
    );
  }
}

// ------------------------------------------------------
// Main App
// ------------------------------------------------------
class RecipeSnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ------------------------------------------------------
// Recipe Screen (SPRINT 2)
// ------------------------------------------------------
class RecipeScreen extends StatelessWidget {
  RecipeScreen({Key? key}) : super(key: key);

  final String dataUrl =
      "https://raw.githubusercontent.com/hharrari/recipesnap-data/refs/heads/main/recipes.json";

  // Fetch data from the web service
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse(dataUrl));

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((r) => Recipe.fromJson(r)).toList();
    } else {
      throw Exception("Failed to load recipes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RecipeSnap"),
        centerTitle: true,
      ),

      // Load online JSON
      body: FutureBuilder<List<Recipe>>(
        future: fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No recipes found."));
          }

          final recipes = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe image from assets
                      Image.asset(
                        "assets/images/${recipe.image}",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(height: 12),

                      // Recipe title
                      Text(
                        recipe.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 12),

                      // Ingredients title
                      Text(
                        "Ingredients:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 6),

                      // Ingredients list
                      ...recipe.ingredients.map((item) => Text("• $item")),

                      SizedBox(height: 12),

                      // Description
                      Text(recipe.description),

                      SizedBox(height: 16),

                      // Cooking Tip Button (DYNAMIC)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Cooking Tip"),
                                content: Text(recipe.tip), // USES JSON TIP
                                actions: [
                                  TextButton(
                                    child: Text("Got it!"),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: Text("Show Tip"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
