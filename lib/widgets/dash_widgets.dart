// External
import 'package:flutter/material.dart';

class DashWidgets {
  static Widget dashboard(List<Widget> dashes, double _dashWidth) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: Card(
        elevation: 2.0,
        child: Container(
          width: _dashWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[...dashes],
            ),
          ),
        ),
      ),
    );
  }

  static Widget dashItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Abel',
              fontWeight: FontWeight.bold,
              // color: Color(0xFF4FA978),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Abel',
              // color: Color(0xFF4FA978),
            ),
          ),
        ],
      ),
    );
  }
}
