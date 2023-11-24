import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_item.dart';
import 'package:shop/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meus Pedidos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) {
                  return OrderItem(order: orders.items[i]);
                },
              ),
            ),
    );
  }
}
