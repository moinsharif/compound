import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  
  final List<dynamic> navLinks;

  NavBar(this.navLinks);

  List<Widget> navItem() {
    return navLinks.map((navLink) {
      return Padding(
        padding: EdgeInsets.only(left: 18), 
        child: Text(navLink["titleLabel"], style: TextStyle(fontFamily: "Montserrat-Bold")),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[...navItem()]),
        ],
      ),
    );
  }
}