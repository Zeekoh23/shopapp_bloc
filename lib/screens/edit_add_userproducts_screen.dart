import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../bloc/bloc_exports.dart';
import './user_products_screen.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    Key? key,
    required this.id,
    this.product,
  }) : super(key: key);
  final String id;
  final Product? product;
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (widget.id != '') {
        _editedProduct = widget
            .product!; /*Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);*/
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        titleController.text = _editedProduct.title;
        priceController.text = _editedProduct.price.toString();
        descController.text = _editedProduct.description;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https'))) {
        return;
      }
      setState(() {});
    }
  }

  /* Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }*/

  void _postEditProduct({
    required BuildContext context,
    required Product product,
    String? userId,
    String? id,
  }) {
    if (widget.id == '') {
      context.read<ProductBloc>().add(
            ProductCreate(
              titleController.text,
              descController.text,
              double.parse(priceController.text),
              _imageUrlController.text,
              _editedProduct.isFavorite,
              userId!,
            ),
          );
    } else {
      context.read<ProductBloc>().add(
            ProductEdited(
              titleController.text,
              descController.text,
              double.parse(priceController.text),
              _imageUrlController.text,
              _editedProduct.isFavorite,
              id!,
            ),
          );
    }
  }

  final productApi = ProductApi();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();
//TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(productApi),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product added'),
                duration: Duration(seconds: 5),
              ),
            );
          }
          if (state is ProductEdited1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product edited'),
                duration: Duration(seconds: 5),
              ),
            );
          }
          if (state is ProductErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductAdding) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Product'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        print(widget.id);
                        final pref = await SharedPreferences.getInstance();
                        final extractData =
                            json.decode(pref.getString('userData')!)
                                as Map<String, dynamic>;
                        final userId = extractData['userId'] as String;
                        if (widget.id == '') {
                          _postEditProduct(
                            context: context,
                            product: _editedProduct,
                            userId: userId,
                          );
                        } else {
                          _postEditProduct(
                            context: context,
                            product: _editedProduct,
                            id: widget.product!.productId,
                          );
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(UserProductsScreen.routeName);
                      }, //_saveForm,
                    ),
                  ],
                ),
                body: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _form,
                          child: ListView(
                            children: <Widget>[
                              TextFormField(
                                controller: titleController,
                                //initialValue: _initValues['title'],
                                decoration: InputDecoration(
                                    labelText: 'Title',
                                    hintText: _initValues['title']!),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_priceFocusNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      title: titleController.text,
                                      price: _editedProduct.price,
                                      description: _editedProduct.description,
                                      imageUrl: _editedProduct.imageUrl,
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                              ),
                              TextFormField(
                                controller: priceController,
                                // initialValue: _initValues['price'],
                                decoration: InputDecoration(
                                    labelText: 'Price',
                                    hintText: _initValues['price']!),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                focusNode: _priceFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_descriptionFocusNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a price.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number.';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Please enter a number greater than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      title: _editedProduct.title,
                                      price: double.parse(priceController.text),
                                      description: _editedProduct.description,
                                      imageUrl: _editedProduct.imageUrl,
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                              ),
                              TextFormField(
                                controller: descController,
                                //initialValue: _initValues['description'],
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: _initValues['description'],
                                ),
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                focusNode: _descriptionFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a description.';
                                  }
                                  if (value.length < 10) {
                                    return 'Should be at least 10 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: descController.text,
                                    imageUrl: _editedProduct.imageUrl,
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                  );
                                },
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: _imageUrlController.text.isEmpty
                                        ? const Text('Enter a URL')
                                        : FittedBox(
                                            child: Image.network(
                                              _imageUrlController.text,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Image URL'),
                                      keyboardType: TextInputType.url,
                                      textInputAction: TextInputAction.done,
                                      controller: _imageUrlController,
                                      focusNode: _imageUrlFocusNode,
                                      onFieldSubmitted: (_) async {
                                        print(widget.id);
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        final extractData = json.decode(
                                                pref.getString('userData')!)
                                            as Map<String, dynamic>;
                                        final userId =
                                            extractData['userId'] as String;

                                        if (widget.id == '') {
                                          _editedProduct = Product(
                                            title: titleController.text,
                                            price: double.parse(
                                                priceController.text),
                                            description: descController.text,
                                            imageUrl: _imageUrlController.text,
                                            id: _editedProduct.id,
                                            isFavorite:
                                                _editedProduct.isFavorite,
                                          );
                                          _postEditProduct(
                                            context: context,
                                            product: _editedProduct,
                                            userId: userId,
                                          );
                                        } else {
                                          _postEditProduct(
                                            context: context,
                                            product: _editedProduct,
                                            id: widget.product!.productId,
                                          );
                                        }
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                UserProductsScreen.routeName);

                                        //_saveForm();
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter an image URL.';
                                        }
                                        if (!value.startsWith('http') &&
                                            !value.startsWith('https')) {
                                          return 'Please enter a valid URL.';
                                        }

                                        return null;
                                      },
                                      onSaved: (value) {
                                        _editedProduct = Product(
                                          title: _editedProduct.title,
                                          price: _editedProduct.price,
                                          description:
                                              _editedProduct.description,
                                          imageUrl: value!,
                                          id: _editedProduct.id,
                                          isFavorite: _editedProduct.isFavorite,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
