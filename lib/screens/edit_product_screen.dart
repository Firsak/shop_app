import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriprtionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(() {
      _updateImageUrl();
    });
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _descriprtionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(() {
      _updateImageUrl();
    });
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.price);
    // print(_editedProduct.imageUrl);
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: value as String,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: Platform.isIOS
                    ? const TextInputType.numberWithOptions(
                        signed: true, decimal: true)
                    : TextInputType.number,
                focusNode: _priceFocusNode,
                // inputFormatters: <TextInputFormatter>[
                //   if (Platform.isIOS)
                //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                // ],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriprtionFocusNode);
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value as String) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value as String),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriprtionFocusNode,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value != null && value.length < 10) {
                    return 'Should be at least 10 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      description: value as String,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      right: 10,
                      top: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.contain,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (value != null &&
                            !value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter URL';
                        }
                        if (value != null &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpeg')) {
                          return 'you can only use .jpg / .jpeg / .png images';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: null,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value as String);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
