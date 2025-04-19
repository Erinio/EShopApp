import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/category_list.dart';
import 'cart_screen.dart';
import '../widgets/category_grid.dart';
import '../providers/products_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final String _selectedCategory = 'All';
  final String _searchQuery = '';

  final List<Widget> _pages = [
    const _HomePage(),
    const _CategoriesPage(),
    const ProfileScreen(), // Replace _ProfilePage with ProfileScreen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<ProductsProvider>(context, listen: false).fetchProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Shop'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, ch) => badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeContent: Text(
                cart.itemCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          CategoryList(
            onCategorySelected: (category) {
              productsProvider.setSelectedCategory(category);
            },
            selectedCategory: productsProvider.selectedCategory,
          ),
          Expanded(
            child: ProductGrid(
              category: productsProvider.selectedCategory,
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesPage extends StatelessWidget {
  const _CategoriesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: const CategoryGrid(),
    );
  }
}
