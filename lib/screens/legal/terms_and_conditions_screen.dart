// External
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const routeName = '/tandc';
  // double backNextHeight = 45.0;

  Widget _buildCartridge(
    BuildContext context,
    String title, {
    @required Widget child,
    List<Widget> others,
  }) {
    final MediaQueryData deviceCritical = MediaQuery.of(context);
    double titleHeight = 45.0;
    double heightBtwTitleChild = 5.0;
    double cardHeight = deviceCritical.size.height -
        deviceCritical.padding.vertical -
        (deviceCritical.size.height * .01 * 2) -
        50.0;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // height of title
            height: titleHeight,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0),
            width: double.infinity,
            decoration: BoxDecoration(
                // color: Colors.green,
                border: Border(bottom: BorderSide(color: Colors.green[200]))),
            child: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'ComicNeue',
                  color: Colors.green[900],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  // space btw child and title
                  height: heightBtwTitleChild,
                ),
                Container(
                  height: cardHeight - titleHeight,
                  padding: const EdgeInsets.all(10.0),
                  // padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0, right: 0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(5.0),
                    // color: Colors.grey,
                  ),
                  child: Scrollbar(
                    // controller: _scrollController,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: child,
                    ),
                  ),
                ),
                // if (others != null) Spacer(),
                if (others != null)
                  ...others,
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final Map<String, dynamic> _welcomeStyle = {
      'button': TextStyle(
        color: Theme.of(context).primaryColor,
        fontFamily: 'PTSans',
        fontSize: 18.0,
      ),
    };

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          // padding: EdgeInsets.all(10.0)
          //     .copyWith(top: MediaQuery.of(context).padding.top),
          padding: EdgeInsets.only(
            top: _deviceSize.height * .01,
            bottom: _deviceSize.height * .01,
            left: _deviceSize.height * .01,
            right: _deviceSize.height * .01,
          ),
          // height: double.infinity,
          // width: double.infinity,
          child: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.green,
            //     width: 2.0,
            //   ),
            // borderRadius: BorderRadius.circular(30.0),
            // color: Colors.white,
            // ),
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(30.0),
              child: Card(
                // margin: const EdgeInsets.all(0.0),
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _buildCartridge(
                        context,
                        'Terms and Conditions',
                        child: Text(
                          'You must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Abel',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
