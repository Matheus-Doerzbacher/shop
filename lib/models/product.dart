import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorito() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorito(String token, String userId) async {
    _toggleFavorito();

    final response = await put(
      Uri.parse(
        "${Constants.USER_FAVORITES_URL}/$userId/$id.json?auth=$token",
      ),
      body: jsonEncode(isFavorite),
    );

    if (response.statusCode >= 400) {
      throw HttpExceptionNew(
        msg: "Não foi possivel favoritar o produto",
        statusCode: response.statusCode,
      );
    }
  }
}
