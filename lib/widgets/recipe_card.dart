import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_soup/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard(this.recipe);

  Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            recipe.title,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            recipe.caption,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
