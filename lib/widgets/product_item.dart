import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/product_detial_screen.dart';
import 'dart:io';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id, this.title, this.imageUrl);

  void _addCartItems(
      BuildContext context, CartProvider cartItem, Product product) {
    cartItem.addItem(product.id, product.price, product.title);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Added Item to cart"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          cartItem.removeSingleItem(product.id);
        },
      ),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartItem = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => Platform.isIOS
                ? GestureDetector(
                    child: product.isFavorite
                        ? Icon(Icons.favorite, size: 15,)
                        : Icon(Icons.favorite_border, size: 15),
            onTap: ()  async {
              await product.toggelFavoriteStatus(
                  authProvider.token, authProvider.userId);
            },)
                : IconButton(
                    icon: product.isFavorite
                        ? Icon(
                            Icons.favorite,
                            size: 15,
                          )
                        : Icon(Icons.favorite_border, size: 15),
                    onPressed: () async {
                      await product.toggelFavoriteStatus(
                          authProvider.token, authProvider.userId);
                    },
                    color: Theme.of(context).accentColor,
                  ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          trailing: Platform.isIOS
              ? GestureDetector(
                  child: Icon(
                    Icons.shopping_cart,
                    size: 15,
                  ),
                  onTap: () {
                    _addCartItems(context, cartItem, product);
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 15,
                  ),
                  onPressed: () {
                    _addCartItems(context, cartItem, product);
                  },
                  color: Theme.of(context).accentColor,
                ),
        ),
      ),
    );
  }
}
