import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/widgets/products_gridview.dart';

import 'cart_screen.dart';

enum FilterOptions { Favorites, All }

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  List<Map<String, Object>> _pages;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<ProductProvider>(context).fetchAndSetProducts();
    // });

    super.initState();
  }



  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBarrWidget(context);
    final pageBody = _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          ) : SafeArea(child: ProductsGridView(_showOnlyFavorites));
    return Scaffold(
      appBar: AppBar(
        title: Text(' my Shop '),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) => {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              })
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<CartProvider>(
              builder: (_, cartProvider, ch) => Badge(
                child: ch,
                value: cartProvider.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              )),
        ],
      ),
      drawer: MainDrawer() ,
      body: pageBody,
    );
  }

  Widget AppBarrWidget(BuildContext context) {
    return Platform.isIOS
      ? CupertinoNavigationBar(
          middle: Text('Personal Expenses'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PopupMenuButton(
              //   onSelected: (FilterOptions selectedValue) => {
              //     setState(() {
              //       if (selectedValue == FilterOptions.Favorites) {
              //         _showOnlyFavorites = true;
              //       } else {
              //         _showOnlyFavorites = false;
              //       }
              //     })
              //   },
              //   icon: Icon(Icons.more_vert),
              //   itemBuilder: (_) => [
              //     PopupMenuItem(
              //       child: Text('Only Favorites'),
              //       value: FilterOptions.Favorites,
              //     ),
              //     PopupMenuItem(
              //       child: Text('Show All'),
              //       value: FilterOptions.All,
              //     ),
              //   ],
              // ),
              Consumer<CartProvider>(
                  builder: (_, cartProvider, ch) => Badge(
                        child: ch,
                        value: cartProvider.itemCount.toString(),
                      ),
                  child: GestureDetector(
                    child: Icon(Icons.shopping_cart),
                    onTap: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ))
            ],
          ),
        )
      : AppBar(
          title: Text(' my Shop '),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) => {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                })
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<CartProvider>(
                builder: (_, cartProvider, ch) => Badge(
                      child: ch,
                      value: cartProvider.itemCount.toString(),
                    ),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                )),
          ],
        );
  }
}
