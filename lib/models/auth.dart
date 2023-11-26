import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {
  static const _url =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC0CwERAmLZwV0FzSg5SINa-pXHsPeziAU";

  Future<void> signup(String email, String sennha) async {
    final response = await post(
      Uri.parse(_url),
      body: jsonEncode({
        "email": email,
        "password": sennha,
        "returnSecureToken": true,
      }),
    );
    print(jsonDecode(response.body));
  }
}
