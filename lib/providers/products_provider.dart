import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {

  List<String> _sizes = ['S', 'M', 'L', 'XL'];

  List<Product> _productList = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String authToken;
  String userId;

  void setTokenAndUserId(String token, List<Product> products, String id) {
    _productList = products;
    authToken = token;
    userId = id;
  }


  List<String> get sizeList {
    return [..._sizes];
  }
  List<Product> get productList {
    print("${_productList}");
    return [..._productList];
  }

  List<Product> get productFavoriteList {
    return _productList.where((element) => element.isFavorite).toList();
  }

  Future<void> updateFavorite(
    String Id,
    bool toggelFavoriteStatus,
  ) async {
    final url =
        'https://shaima-dac76.firebaseio.com/products/$Id.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'isFavorite': toggelFavoriteStatus,
        }));
  }

  Product findById(String Id) {
    return _productList.firstWhere((element) => element.id == Id);
  }

  Future<void> updateProducts(String Id, Product newProduct) async {
    final productIndex = _productList.indexWhere((product) => product.id == Id);
    if (productIndex >= 0) {
      final url =
          'https://shaima-dac76.firebaseio.com/products/$Id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _productList[productIndex] = newProduct;
      notifyListeners();
    }
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAl() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : '';
    var url =
        'https://shaima-dac76.firebaseio.com/products.json?auth=$authToken&$filterString';
    final favoriteUrl =
        'https://shaima-dac76.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;

      final List<Product> loadedProducts = [];
      final favoriteResults = await http.get(Uri.parse(favoriteUrl));
      final favoriteData = json.decode(favoriteResults.body);

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            imageUrl: prodData['imageUrl'],
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _productList = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    final url =
        "https://shaima-dac76.firebaseio.com/products.json?auth=$authToken";

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'createrId': userId
          }));

      // print("response ${json.decode(response.body)}");
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _productList.add(newProduct);
      // _productList.insert(0, newProduct); // at the start of the list
      notifyListeners();
      return Future.value();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shaima-dac76.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _productList.indexWhere((element) => element.id == id);
    var existingProduct = _productList[existingProductIndex];
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _productList.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product');
    } else {
      existingProduct = null;
      _productList.removeWhere((prod) => prod.id == id);
    }
    notifyListeners();
  }
}
