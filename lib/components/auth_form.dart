import 'package:flutter/material.dart';

enum AuthMode { signUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        height: 320,
        width: deviceSize.width * 0.75,
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (emailForm) {
                  final email = emailForm ?? '';

                  if (email.trim().isEmpty || !email.contains('@')) {
                    return "Informe um email válido";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Senha"),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (passwordForm) {
                  final password = passwordForm ?? '';

                  if (password.isEmpty || password.length < 5) {
                    return "Informe um senha válida";
                  }

                  return null;
                },
              ),
              if (_authMode == AuthMode.signUp)
                TextFormField(
                  decoration: const InputDecoration(labelText: "Confirmar senha"),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _authMode == AuthMode.login
                      ? null
                      : (passwordForm) {
                          final password = passwordForm ?? '';

                          if (password != _passwordController.text) {
                            return "Senhas informadas não conferem";
                          }

                          return null;
                        },
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  _authMode == AuthMode.login ? "Entrar" : "Registrar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
