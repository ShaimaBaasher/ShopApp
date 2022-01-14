import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String userId;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.userId,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  //
  // Future<void> toggleFavoriteStatus() async {
  //   final oldStatus = isFavorite;
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  //   final url = 'https://shaima-dac76.firebaseio.com/products/$id.json';
  //   try {
  //     final response = await http.patch(
  //       url,
  //       body: json.encode({
  //         'isFavorite': isFavorite,
  //       }),
  //     );
  //     if (response.statusCode >= 400) {
  //       _setFavValue(oldStatus);
  //     }
  //   } catch (error) {
  //     _setFavValue(oldStatus);
  //   }
  // }
  Future<void> toggelFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shaima-dac76.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    try {
      await http.put(Uri.parse(url), body: json.encode(isFavorite));
    } catch (error) {
      isFavorite = oldStatus;
    }
  }

// bool toggelFavoriteStatus() {
//   final oldStatus = isFavorite;
//   isFavorite = !isFavorite;
//   notifyListeners();
//   notifyListeners();
//
// }

// bool toggelFavoriteStatus() {
//   isFavorite = !isFavorite;
//   notifyListeners();
//   return isFavorite;
// }
}
