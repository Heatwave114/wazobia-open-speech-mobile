// External
import 'package:flutter/material.dart';

class CentrallyUsed {
  Widget waitingCircle() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xff2A6041),
        strokeWidth: 1.0,
      ),
    );
  }
}
