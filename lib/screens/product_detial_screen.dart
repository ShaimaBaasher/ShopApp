import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static final routeName = '/product_detail';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int rowIndex = -1;

  Color textColor = Colors.black26;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductProvider>(context).findById(productId);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loadedProduct.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Chip(
                            backgroundColor: Theme.of(context).primaryColor,
                            label: Text(
                              '\$ ${loadedProduct.price}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Select Size',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 100,
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productProvider.sizeList.length,
                        itemBuilder: (ctx, i) => Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(1.5),
                            width: 70,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 22),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[350],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                rowIndex = i;
                                setState(() {

                                });
                                print("rowIndex $rowIndex $i");

                              },
                              child: Text(
                                productProvider.sizeList[i],
                                style: TextStyle(
                                    color: rowIndex == i ? Colors.red : Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 15, horizontal: 22),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey[350],
                    //         ),
                    //         borderRadius: BorderRadius.all(Radius.circular(15)),
                    //         color: Colors.white,
                    //       ),
                    //       child: Text(
                    //         'S',
                    //         style: TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 15, horizontal: 22),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey[350],
                    //         ),
                    //         borderRadius: BorderRadius.all(Radius.circular(15)),
                    //         color: Colors.white,
                    //       ),
                    //       child: Text(
                    //         'M',
                    //         style: TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 15, horizontal: 22),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey[350],
                    //         ),
                    //         borderRadius: BorderRadius.all(Radius.circular(15)),
                    //         color: Colors.white,
                    //       ),
                    //       child: Text(
                    //         'L',
                    //         style: TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Item Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${loadedProduct.description}',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(17))),
                        onPressed: () {},
                        child: Text(
                          "Add to cart",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
