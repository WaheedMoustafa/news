import 'package:flutter/material.dart';
import '../../../data/models/category.dart';
import 'app_category.dart';


class CategoriesTab extends StatelessWidget {
  final Function(Category) onCategoryClick;

  const CategoriesTab(this.onCategoryClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Pick your category of interest"),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GridView.builder(
              itemCount: Category.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    onCategoryClick(Category.categories[index]);
                  },
                  child: AppCategory(category: Category.categories[index])),
            ),
          ),
        )
      ],
    );
  }
}