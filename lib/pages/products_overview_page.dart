import 'package:flutter/material.dart';
import 'package:shop/components/product_grid.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minha Loja",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            iconColor: Colors.white,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text("Somente Favoritos"),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text("Todos"),
              ),
            ],
            onSelected: (FilterOptions selecValue) {
              setState(() {
                if (selecValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
        ],
      ),
      body: ProductGrid(showFavoriteOnly: _showFavoriteOnly),
    );
  }
}
