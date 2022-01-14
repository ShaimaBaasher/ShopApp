import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static final routeName = "/user_products_screen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productList = Provider.of<ProductProvider>(context).productList;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator(),)
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductProvider>(
                      builder: (ctx, provider, _) =>  Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: provider.productList.length,
                            itemBuilder: (ctx, index) => Column(
                                  children: [
                                    UserProductItem(
                                         provider.productList[index].id,
                                        provider.productList[index].title,
                                        provider.productList[index].imageUrl),
                                    Divider()
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
