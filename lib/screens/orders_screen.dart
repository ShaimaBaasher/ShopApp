import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/cupertino_app_bar.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import 'dart:io';

class OrdersScreen extends StatelessWidget {
  static final routeName = '/order_screen';
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Widget build(BuildContext context) {
    // final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar:AppBar(
        title: Text("My Orders"),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndInsert(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.error != null) {
            Center(
              child: Text('Error'),
            );
          } else {
            return Consumer<OrdersProvider>(
              builder: (ctx, orderData, _) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) =>
                      OrderItem(orderData.orders[index])),
            );
          }
        },
      ),
    );
  }
}
