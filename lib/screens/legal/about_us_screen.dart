// External
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/about';
  static const aEmail = 'acontact@email.com';
  static const bEmail = 'bcontact@email.com';
  static const supportEmail = 'support@wazobia.com.ng';

  // double backNextHeight = 45.0;

  Future<void> _sendEmail() async {
    final Email email = Email(
      // body: '',
      subject: 'From wazobia mobile app',
      recipients: [supportEmail],
      // cc: ['cc@example.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

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
        80.0;
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
                  // height: double.infinity,
                  // width: double.infinity,
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
                        'About Us',
                        child: Column(
                          children: <Widget>[
                            Text(
                              'This application is developed by students of Computer Engineering Department, Federal University of Technology, Minna, in collaboration with ITU, under their Machine Learning and 5G focus group. It is used to collect voice data for the African Automatic Speech Recognition project.',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Abel',
                              ),
                            ),
                          ],
                        ),
                        others: [
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    // overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Contact Us',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap =
                                                () async => this._sendEmail(),
                                          style: TextStyle(
                                            color: Colors.deepOrange[400],
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        // TextSpan(text: '\t\t\t\t\t'),
                                        // TextSpan(
                                        //   text: 'bcontact@email.com',
                                        //   recognizer: TapGestureRecognizer()
                                        //     ..onTap = () async => ,
                                        //   style: TextStyle(
                                        //     color: Colors.deepOrange[400],
                                        //     decoration:
                                        //         TextDecoration.underline,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
