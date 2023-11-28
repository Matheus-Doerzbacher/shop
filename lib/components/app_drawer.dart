import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AppBar(
                title: const Text("Bem Vindo Usuário!"),
                automaticallyImplyLeading: false,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shop),
                title: const Text("Loja"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.AUTH_OR_HOME,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text("Pedidos"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.ORDERS,
                  );
                  // Navigator.of(context).pushReplacement(
                  //   CustomRoute(
                  //     builder: (ctx) => const OrdersPage(),
                  //   ),
                  // );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Gerenciar Produtos"),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.PRODUCTS,
                  );
                },
              ),
              const Divider(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                "Sair",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.AUTH_OR_HOME,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
