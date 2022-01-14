import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoAppBar extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> key;

  CupertinoAppBar(this.title, this.key);

  @override
  _CupertinoAppBarState createState() => _CupertinoAppBarState();
}

class _CupertinoAppBarState extends State<CupertinoAppBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(widget.title),
      leading: GestureDetector(
        child: Icon(Icons.menu),
        onTap: () {
          widget.key.currentState.openDrawer();
        },
      ),
    );
  }
}
