import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = "edit-products-screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;
  var _initValues = Product();

  var _editedProduct =
      Product(id: null, title: "", price: 0, description: "", imageUrl: "");

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);
        _initValues = Product(
            id: _editedProduct.id,
            title: _editedProduct.title,
            description: _editedProduct.description,
            price: _editedProduct.price,
            imageUrl: "");
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();

    if (!_isValid) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
    await Provider.of<ProductProvider>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);

    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("an error occurred"),
                  content: Text("something went wrong ${error.toString()}"),
                  actions: [
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      // finally {
      //
      // }

    }
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues.title,
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide a value";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            id: _editedProduct.id,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                        initialValue: _initValues.price == null
                            ? "" : _initValues.price.toString(),
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please provide a value";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please a valid number";
                          }
                          // if (double.parse(value) <= null) {
                          //   return "Please a number greater than zero";
                          // }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              price: double.parse(value),
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: _editedProduct.imageUrl);
                        }),
                    TextFormField(
                        initialValue: _initValues.description,
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please provide a value";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              description: value,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: _editedProduct.imageUrl);
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter Url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Text of Image"),
                              keyboardType: TextInputType.url,
                              focusNode: _imageFocusNode,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please provide a value";
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https'))
                                  return 'Please Enter a valid url';
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    id: _editedProduct.id,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    isFavorite: _editedProduct.isFavorite,
                                    imageUrl: value);
                              }),
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
