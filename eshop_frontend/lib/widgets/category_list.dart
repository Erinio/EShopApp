import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class CategoryList extends StatelessWidget {
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const CategoryList({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  static const Map<String, IconData> categoryIcons = {
    'All': Icons.all_inclusive,
    'Electronics': Icons.devices,
    'Clothing': Icons.shopping_bag,
    'Books': Icons.book,
    'Sports': Icons.sports_soccer,
    'Home': Icons.home,
  };

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ProductsProvider>(context).categories;

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (ctx, index) {
          final category = index == 0 ? 'All' : categories[index - 1];
          final isSelected = category == selectedCategory;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () => onCategorySelected(category),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      categoryIcons[category] ?? Icons.category,
                      size: 30,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
