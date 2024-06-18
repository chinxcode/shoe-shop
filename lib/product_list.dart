import 'package:flutter/material.dart';
import 'package:shoe_shop/global_variables.dart';
import 'package:shoe_shop/product_card.dart';
import 'package:shoe_shop/product_detail_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = ["All", "Nike", "Adidas", "Bata", "Redtape"];
  late String selectedFilter;
  String searchQuery = '';

  List<Map<String, Object>> getSelectedProducts() {
    List<Map<String, Object>> selectedProducts = [];

    for (var product in products) {
      if ((selectedFilter == "All" ||
              product["company"] as String == selectedFilter) &&
          (product["title"] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
        selectedProducts.add(product);
      }
    }

    return selectedProducts;
  }

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)));

    return SafeArea(
        child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Shoes\nCollection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
                child: TextField(
              decoration: const InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: border,
                focusedBorder: border,
                enabledBorder: border,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ))
          ],
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: filters.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final filter = filters[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Chip(
                    backgroundColor: selectedFilter == filter
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromRGBO(245, 247, 249, 1),
                    side: const BorderSide(
                      color: Color.fromRGBO(196, 208, 218, 1),
                    ),
                    label: Text(filter),
                    labelStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: getSelectedProducts().length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final product = getSelectedProducts()[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to product details page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailPage(product: product);
                      },
                    ),
                  );
                },
                child: ProductCard(
                  title: product["title"] as String,
                  price: product["price"] as double,
                  image: product["imageUrl"] as String,
                  backgroundColor: index.isEven
                      ? const Color.fromRGBO(216, 240, 253, 1)
                      : const Color.fromRGBO(245, 247, 249, 1),
                ),
              );
            },
          ),
        ),
      ],
    ));
  }
}
