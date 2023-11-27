import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String token;
  final List<Product> items;

  ProductList({
    required this.token,
    required this.items,
  });

  final _baseUrl = Constants.PRODUCT_BASE_URL;

  List<Product> get itemsList => [...items];
  List<Product> get favoriteItems => items.where((product) => product.isFavorite).toList();

  int get itemsCount {
    return items.length;
  }

  Future<void> loadProduct() async {
    items.clear();
    final response = await get(Uri.parse("$_baseUrl.json?auth=$token"));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      items.add(Product(
        id: productId,
        name: productData['name'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
      ));
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await post(
      Uri.parse("$_baseUrl.json?auth=$token"),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await patch(
        Uri.parse("$_baseUrl/${product.id}.json?auth=$token"),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = items[index];
      items.remove(product);
      notifyListeners();

      final response = await delete(
        Uri.parse("$_baseUrl/${product.id}.json?auth=$token"),
      );

      if (response.statusCode >= 400) {
        items.insert(index, product);
        notifyListeners();
        throw HttpExceptionNew(
          msg: "Não foi possivel excluir o produto",
          statusCode: response.statusCode,
        );
      }
    }
  }
}
