import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { signUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signUp;

  void _switchAuthMode() {
    setState(
      () {
        if (_isLogin()) {
          _authMode = AuthMode.signUp;
        } else {
          _authMode = AuthMode.login;
        }
      },
    );
  }

  void _showErroDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ocorreu um erro"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValidade = _formKey.currentState?.validate() ?? false;

    if (!isValidade) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (err) {
      _showErroDialog(err.toString());
    } catch (err) {
      _showErroDialog("Ocorreu um erro inesperado");
    }

    setState(() => _isLoading = false);
  }

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
        height: _isLogin() ? 330 : 420,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
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
              if (_isSignup())
                TextFormField(
                  decoration: const InputDecoration(labelText: "Confirmar senha"),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _isLogin()
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _authMode == AuthMode.login ? "ENTRAR" : "REGISTRAR",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? "Deseja registrar?" : "Ja posui conta?",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
