import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageUrl'] as String,
    );

    print(newProduct.id);
    print(newProduct.name);
    print(newProduct.description);
    print(newProduct.price);
    print(newProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Formulário de Produto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (name) => _formData["name"] = name ?? "",
                validator: (nameForm) {
                  final name = nameForm ?? '';

                  if (name.trim().isEmpty) {
                    return "Nome é obrigatório";
                  }

                  if (name.trim().length < 3) {
                    return "Nome precisa no mínimo de 3 letras";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Preço"),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) => _formData["price"] = double.parse(price ?? "0"),
                validator: (price) {
                  if (price != null && price.isEmpty) {
                    return "É obrigatório informar um valor";
                  }

                  if (double.parse(price.toString()) < 0) {
                    return "O valor precisa ser positivo";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descrição"),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) => _formData["description"] = description ?? "",
                validator: (descriptionForm) {
                  final description = descriptionForm ?? '';

                  if (description.trim().isEmpty) {
                    return "Descrição é obrigatório";
                  }

                  if (description.trim().length < 10) {
                    return "Descrição precisa no mínimo de 10 letras";
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Url da Imagem"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => submitForm(),
                      onSaved: (imageUrl) => _formData["imageUrl"] = imageUrl ?? "",
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? const Text("Informe a Url")
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
