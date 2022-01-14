import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildListTile(String title, IconData icon, Function handler) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: handler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          _buildListTile('Shop', Icons.shop, () {
            Navigator.of(context).pushReplacementNamed("/");
          }),
          Divider(),
          _buildListTile('My Orders', Icons.payment, () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          }),
          Divider(),
          _buildListTile('Manage Products', Icons.edit , () {
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          }),
          Divider(),
          _buildListTile('Logout', Icons.exit_to_app  , () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');
            Provider.of<AuthProvider>(context, listen: false).logout();
          }),
        ],
      ),
    );
  }
}
