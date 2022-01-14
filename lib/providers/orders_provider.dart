import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {

  String _token;
  String _userId;

  List<Order> _order = [];

  List<Order> get orders {
    return [..._order];
  }

  void setTokenAndOrderAndUserId(
      String token, List<Order> order, String userId) {
    _token = token;
    _order = order;
    _userId = userId;
  }

  Future<void> fetchAndInsert() async {
    final url =
        "https://shaima-dac76.firebaseio.com/order/$_userId .json?auth=$_token";
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Order> loadedOrders = [];
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(Order(
        Id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map((e) => CartItem(
                id: e['id'],
                title: e['title'],
                quantity: e['quantity'],
                price: e['price']))
            .toList(),
      ));
    });
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shaima-dac76.firebaseio.com/order/$_userId.json?auth=$_token";
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
          'quantity': 1,
          'dateTime': DateTime.now().toIso8601String()
        }));

    _order.insert(
        0,
        Order(
            Id: json.decode(response.body)["name"],
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));

    print("_orderAdd${_order[0].amount}");
    notifyListeners();
  }
}
