import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Excluir Produto?"),
            content: const Text("Tem certeza?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text("Não"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text("Sim"),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) async {
        try {
          await Provider.of<ProductList>(
            context,
            listen: false,
          ).removeProduct(product);
        } catch (err) {
          msg.showSnackBar(
            SnackBar(
              content: Text(err.toString()),
            ),
          );
        }
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
          backgroundColor: Colors.white,
        ),
        title: Text(product.name),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PRODUCT_FORM,
                    arguments: product,
                  );
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.delete),
              //   color: Theme.of(context).colorScheme.error,
              //   onPressed: () {
              //     showDialog<bool>(
              //       context: context,
              //       builder: (ctx) => AlertDialog(
              //         title: const Text("Excluir Produto?"),
              //         content: const Text("Tem certeza?"),
              //         actions: [
              //           TextButton(
              //             onPressed: () {
              //               Navigator.of(ctx).pop(false);
              //             },
              //             child: const Text("Não"),
              //           ),
              //           TextButton(
              //             onPressed: () {
              //               Provider.of<ProductList>(context, listen: false).removeProduct(product);
              //               Navigator.of(ctx).pop(true);
              //             },
              //             child: const Text("Sim"),
              //           ),
              //         ],
              //       ),
              //     ).then(
              //       (value) => {
              //         if (value ?? false)
              //           {
              //             Provider.of<ProductList>(
              //               context,
              //               listen: false,
              //             ).removeProduct(product)
              //           }
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
