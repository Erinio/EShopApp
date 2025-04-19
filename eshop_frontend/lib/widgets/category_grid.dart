import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/home_screen.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  final Map<String, IconData> categoryIcons = const {
    'Electronics': Icons.devices,
    'Clothing': Icons.shopping_bag,
    'Books': Icons.book,
    'Sports': Icons.sports_soccer,
    'Home': Icons.home,
  };

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ProductsProvider>(context).categories;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (ctx, index) {
        final category = categories[index];
        return Card(
          elevation: 3,
          child: InkWell(
            onTap: () {
              Provider.of<ProductsProvider>(context, listen: false)
                  .setSelectedCategory(category);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  categoryIcons[category] ?? Icons.category,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
