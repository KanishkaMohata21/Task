import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/components/product_card.dart';
import 'package:task/models/product.dart';
import 'package:task/provider/cart_provider.dart';
import 'package:task/provider/product_provider.dart';
import 'package:task/screens/cart.dart';

class ProductListPage extends ConsumerStatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  int page = 0;
  String selectedFilter = 'No Filters';

  final List<String> filterOptions = [
    'No Filters',
    'Discounted',
    'Price Low to High',
    'Price High to Low',
  ];

  void loadNextPage() {
    setState(() {
      page += 1;
    });
  }

  void loadPreviousPage() {
    if (page > 0) {
      setState(() {
        page -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productProvider(page));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: const Text(
          'Catalogue',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false, 
        elevation: 0,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: selectedFilter,
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  iconSize: 24,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.pink,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
                  items: filterOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  ),
                  Positioned(
                    right: 1,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final cartItems = ref.watch(cartProvider).length;
                          return Text(
                            cartItems > 0 ? '$cartItems' : '0',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.pink[50],
        child: Column(
          children: [
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  List<Product> filteredProducts = products;
                  if (selectedFilter == 'Discounted') {
                    filteredProducts = products
                        .where((product) => product.discountPercentage > 0)
                        .toList();
                  } else if (selectedFilter == 'Price Low to High') {
                    filteredProducts.sort((a, b) =>
                        a.discountedPrice.compareTo(b.discountedPrice));
                  } else if (selectedFilter == 'Price High to Low') {
                    filteredProducts.sort((a, b) =>
                        b.discountedPrice.compareTo(a.discountedPrice));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(product: product);  
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text('Error: ${error.toString()}')),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: loadPreviousPage,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: loadNextPage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
