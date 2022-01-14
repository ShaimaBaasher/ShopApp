import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart_provider.dart';

class Order {
  final String Id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order(
      {@required this.Id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}
