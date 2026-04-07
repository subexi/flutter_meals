import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.onToggleFavorite,
  });
  // The title is optional, because we also want to use this screen to display the favorite meals,
  // which don't have a category title.
  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  // Navigates to the meal details screen when the meal item is tapped.
  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(
      context,
    ).push(
      MaterialPageRoute(builder: (ctx) => MealDetailsScreen(
        meal: meal,
        onToggleFavorite: onToggleFavorite,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) => Text(
          meals[index].title
        ),
      );

    if (meals.isEmpty) {
      content = Center(
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            Text('Uh oh ... nothing here!',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(
                  (0.8 * 255).toInt(),
                )
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(
                  (0.8 * 255).toInt(),
                )
              ),
            ),
          ],
        ),
      );
    }

    if (meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx, index) => MealItem(
          meal: meals[index],
          onSelectMeal: () {
            selectMeal(context, meals[index]);
          },
        ),
      );
    }
    // If no title is provided, we don't want to display an app bar at all.
    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}