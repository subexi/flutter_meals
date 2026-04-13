import 'package:flutter/material.dart';

/* import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/screens/tabs.dart'; */

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
var _glutenFreeFilterSet = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      /* drawer: MainDrawer(
        onSelectScreen: (identifier) {
          Navigator.of(context).pop();
          if (identifier == 'meals') {
            // Navigate back to the TabsScreen when 'meals' is selected
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const TabsScreen(),
              ),
            );
          }
        },
      ), */
      body: Column(
        children: [
          SwitchListTile(
            value: _glutenFreeFilterSet,
            onChanged: (isChecked) {
              setState(() {
                _glutenFreeFilterSet = isChecked;
              });
            },
            title: Text(
              'Gluten-free',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Only include gluten-free meals.',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            activeThumbColor: Theme.of(context).colorScheme.tertiary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
        ],
      ),
    );
  }
}