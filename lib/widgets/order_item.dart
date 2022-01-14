import 'package:flutter/material.dart';
import 'package:shop_app/models/order.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 10.0 + 220, 300) : 105,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(' order.amount '),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: _expanded
                  ? IconButton(
                      icon: Icon(Icons.expand_less),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: _expanded
                    ? min(widget.order.products.length * 20.0 + 70, 100)
                    : 0,
                child: Column(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: widget.order.products.length,
                          itemBuilder: (ctx, i) => ListTile(
                                subtitle: Text(
                                  "${widget.order.products[i].quantity} x",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),),
                                title: Text(
                                  "${widget.order.products[i].title}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Column(
                                  children: [
                                    Chip(
                                      label: Text(
                                          "\$ ${widget.order.products[i].price}"),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
