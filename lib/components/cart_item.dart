import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text(
                "${cartItem.price}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        title: Text(cartItem.name),
        subtitle: Text("Total: R\$ ${cartItem.price * cartItem.quantity}"),
        trailing: Text(
          "${cartItem.quantity}x",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
