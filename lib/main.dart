import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductList(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
