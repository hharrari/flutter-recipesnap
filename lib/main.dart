import 'package:flutter/material.dart';

void main() {
  runApp(RecipeSnapApp());
}

class RecipeSnapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecipeScreen extends StatelessWidget {
  // Hardcoded recipe data for Sprint 1
  final String title = "Classic Pancakes";
  final String description = "Fluffy homemade pancakes that are perfect for breakfast.";
  final List<String> ingredients = [
    "1 cup flour",
    "2 tbsp sugar",
    "1 cup milk",
    "1 egg",
    "2 tbsp melted butter"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RecipeSnap"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/pancakes.jpg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  Text(
                    "Ingredients:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Ingredient list
                  ...ingredients.map((item) => Text("• $item")).toList(),

                  SizedBox(height: 12),
                  Text(description),

                  // Popup dialogue button
                  SizedBox(height: 16),
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
                            content: Text("For extra fluffy pancakes, avoid overmixing the batter — small lumps are OK!"),
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
          ),
        ],
      ),
    );
  }
}