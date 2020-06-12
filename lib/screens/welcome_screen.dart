// External
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

// Internal
import '../customs/custom_checkbox.dart' as custm;
import '../providers/user.dart';
import '../screens/metadata_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _agreedToTerms = false;
  User _user = User();
  GlobalKey cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double backNextHeight = 45.0;
  Widget _buildCartridge(
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
        100.0;
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
                  height: cardHeight - backNextHeight - titleHeight,
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

  void _nextPreviousPage(bool back) {
    if (back && _tabController.index >= 1) {
      setState(() {
        _agreedToTerms = false;
      });
      this._tabController.index--;
    } else if (!back && _tabController.index < _tabController.length - 1) {
      setState(() {});
      this._tabController.index++;
    }
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

    return SafeArea(
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
              key: cardKey,
              // margin: const EdgeInsets.all(0.0),
              elevation: 2.0,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      // physics: BouncingScrollPhysics(),
                      controller: _tabController,
                      children: <Widget>[
                        _buildCartridge(
                          'Welcome',
                          child: Text(
                            'This application is developed by Federal University of Technology, Minna, in collaboration with ITU. It is used to collect voice data specific to African dialects.',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Abel',
                            ),
                          ),
                        ),
                        // Must be the last Cartridge[agreedToTerms??]
                        _buildCartridge(
                          'Terms and Conditions',
                          child: Column(
                            children: <Widget>[
                              Text(
                                'You must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: 'Abel',
                                ),
                              ),
                            ],
                          ),
                          others: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  value: _agreedToTerms,
                                  // useTapTarget: false,
                                  activeColor: Colors.deepOrange[600],
                                  onChanged: (toggle) {
                                    // User user =
                                    //     Provider.of<User>(context, listen: false)
                                    //       ..setRememberMe(toggle);
                                    // print(user.rememberMe);
                                    setState(() {
                                      _agreedToTerms = toggle;
                                    });
                                  },
                                ),
                                RichText(
                                  // overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    children: <TextSpan>[
                                      const TextSpan(text: 'I agree to '),
                                      TextSpan(
                                        text: 'terms and conditions',
                                        // recognizer: TapGestureRecognizer()
                                        //   ..onTap = () {

                                        //     // Navigate to Terms and Conditions Page
                                        //     // Navigator.of(context)
                                        //     //     .pushNamed(
                                        //     //         TermsConditionsScreen.routeName);

                                        //     showModalBottomSheet(
                                        //       context: context,
                                        //       builder: (_) {
                                        //         return GestureDetector(
                                        //           onTap: () {},
                                        //           child: Container(
                                        //             height:
                                        //                 MediaQuery.of(context)
                                        //                         .size
                                        //                         .height *
                                        //                     .70,
                                        //             child: Center(
                                        //                 child: Padding(
                                        //               padding:
                                        //                   const EdgeInsets.all(
                                        //                       15.0),
                                        //               child: const Text(
                                        //                 'You must consent to this terms and conditions before you gain acces to wazobia.',
                                        //                 style: const TextStyle(
                                        //                     fontSize: 20.0,
                                        //                     fontFamily:
                                        //                         'PTSans'),
                                        //               ),
                                        //             )),
                                        //           ),
                                        //           behavior:
                                        //               HitTestBehavior.opaque,
                                        //     );
                                        //   },
                                        // );
                                        // },
                                        style: TextStyle(
                                          // color: Theme.of(context).accentColor,
                                          color: Colors.deepOrange[400],
                                          decoration: TextDecoration.underline,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0)
                        .copyWith(bottom: 15.0),
                    // padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: this.backNextHeight,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // RaisedButton(onPressed: () {
                        //   print(_tabController.index);
                        //   print(_agreedToTerms);
                        // }),
                        FlatButton(
                          child: Text(
                            'Back',
                            style: _welcomeStyle['button'],
                          ),
                          onPressed: () => _nextPreviousPage(true),
                        ),
                        TabPageSelector(
                          color: Colors.white,
                          selectedColor: Colors.black,
                          controller: _tabController,
                          indicatorSize: 5.0,
                        ),
                        FlatButton(
                          child: Text(
                            'Next',
                            style: _welcomeStyle['button'],
                          ),
                          onPressed: !(_tabController.index ==
                                  _tabController.length - 1)
                              ? () => _nextPreviousPage(false)
                              : _agreedToTerms
                                  ? () {
                                      this._user.setFirstTime(false);
                                      Navigator.of(context)
                                          .pushNamed(MetadataScreen.routeName);
                                    }
                                  : null,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
