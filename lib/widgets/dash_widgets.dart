// External
import 'package:flutter/material.dart';

class DashWidgets {
  static Widget dashboard(
      BuildContext context, double _dashWidth, List<Widget> dashes) {
    Function(List<Widget> trueDashes) dashColumn = (trueDashes) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...trueDashes
            // ...(trueDashes
            //     .map((dash) => Container(
            //           // width: _dashWidth,
            //           child: FittedBox(fit: BoxFit.cover,
            //             child: dash,
            //           ),
            //         ))
            //     .toList())
          ],
        );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: Card(
        elevation: 2.0,
        child: Container(
          // width: _dashWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: !(MediaQuery.of(context).textScaleFactor > 1.5)
                ? dashColumn(dashes)
                : dashColumn(
                    (dashes
                        .map((dash) => FittedBox(
                              // fit: BoxFit.cover,
                              child: dash,
                            ))
                        .toList()),
                  ),
          ),
        ),
      ),
    );
  }

  static Widget dashItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        // width: double.infinity,
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
            SizedBox(
              width: 50,
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
      ),
    );
  }

  static Widget customDashItem(String label, String value, {TextStyle style}) {
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
            style: style ??
                TextStyle(
                  fontSize: 18,
                  fontFamily: 'Abel',
                  // color: Color(0xFF4FA978),
                  // color: Colors.red[900],
                ),
          ),
        ],
      ),
    );
  }
}
