import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/cart_Item_view.dart';

class CartScreen extends StatelessWidget {
  static final routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final order = Provider.of<OrdersProvider>(context, listen: false);
    // print("${cart.items.values.toList()[0].price}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  NewWidget()
                ],
              ),
            )),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) => CartItemView(
                    cart.items.values.toList()[index].id,
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].title,
                    cart.items.values.toList()[index].price,
                    cart.items.values.toList()[index].quantity)),
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final order = Provider.of<OrdersProvider>(context, listen: false);
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      child: _isLoading ? Center(child: CircularProgressIndicator(),) : Text('PRESS TO ORDER', style: TextStyle(fontSize: 18,),
      ),
      onPressed: (cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await order.addOrders(cart.items.values.toList(), cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              cart.clear();
            },
    );
  }
}
