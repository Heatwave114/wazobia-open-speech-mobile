// External
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

// Internal
import '../customs/custom_checkbox.dart' as custm;
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

  Widget _buildCartridge(
    String title, {
    @required Widget child,
    List<Widget> others,
  }) {
    return Column(
      children: <Widget>[
        Container(
          height: 60.0,
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .45,
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
                if (others != null) Spacer(),
                if (others != null) ...others,
              ],
            ),
          ),
        )
      ],
    );
  }

  void _nextPreviousPage(bool back) {
    if (back && _tabController.index >= 1) {
      setState(() {
        _agreedToTerms = false;
      });
      _tabController.index--;
    } else if (!back && _tabController.index < _tabController.length - 1) {
      _tabController.index++;
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
        // padding: EdgeInsets.all(10.0)
        //     .copyWith(top: MediaQuery.of(context).padding.top),
        padding: EdgeInsets.only(
          top: _deviceSize.height * .10,
          bottom: _deviceSize.height * .10,
          left: _deviceSize.height * .03,
          right: _deviceSize.height * .03,
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
                          child: Text(
                            'You must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions\n\nYou must consent to this terms and conditions',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Abel',
                            ),
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15.0),
                    // padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 45.0,
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
                          selectedColor: Colors.green,
                          controller: _tabController,
                          indicatorSize: 4,
                        ),
                        FlatButton(
                          child: Text(
                            'Next',
                            style: _welcomeStyle['button'],
                          ),
                          onPressed: !(_tabController.index ==
                                  _tabController.length - 1)
                              ? () => _nextPreviousPage(false)
                              : () => _agreedToTerms
                                  ? Navigator.of(context)
                                      .pushNamed(MetaDataScreen.routeName)
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

// // Core
// import 'dart:math';

// // External
// import 'package:flutter/material.dart';

// class WelcomeScreen extends StatefulWidget {
//   static const routeName = '/welcome';
//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }

// class _WelcomeScreenState extends State<WelcomeScreen>
//     with SingleTickerProviderStateMixin {
//   // static const List<String> placeholders = [
//   //   'darkblue',
//   //   'greener',
//   //   'greenwater',
//   //   'grey',
//   //   'lemon',
//   //   'peach',
//   //   'peacher',
//   //   'silver',
//   //   'whitesand',
//   //   'yellow'
//   // ];

//   final _random = new Random();
//   TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(vsync: this, length: 5);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Map<String, dynamic> _promotionTheme = {
//     'color': Color(0xffede0d1),
//     'textsize': 15.0,
//   };

//   // void _nextPage(int delta) {
//   //   final int newIndex = _tabController.index + delta;
//   //   if (newIndex < 0 || newIndex >= _tabController.length) return;
//   //   _tabController.animateTo(newIndex);
//   // }

//   void _nextPromotion() {
//     // while (true) {
//     //   Future.delayed(const Duration(seconds: 3), () {
//     //     _tabController.index++;
//     //     //print(_tabController.index);
//     //     if (_tabController.index == 5) _tabController.index = 0;
//     //     //print(_tabController.index);
//     //     setState(() {});
//     //   });
//     // }

//     // Future.delayed(Duration(seconds: 3), () {
//     //   (_) {
//     //     setState(() {
//     //       this._tabController.animateTo(this._tabController.index++);
//     //       if (this._tabController.index == 5) this._tabController.index = 0;
//     //       sleep(const Duration(seconds: 3));
//     //     });
//     //   }
//     // });

//     Future.delayed(
//       Duration(seconds: 5),
//       () {
//         this._tabController.animateTo(
//               // not 4 but promotions.length - 1;
//               this._tabController.index == 4 ? 0 : this._tabController.index++,
//             );
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildPromotion(String link) {
//     return Stack(
//       fit: StackFit.expand,
//       children: <Widget>[

//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(this._tabController.index);
//     // WidgetsBinding.instance.addPostFrameCallback((_) => (){})

//     this._nextPromotion();

//     final internalHeight = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.vertical -
//         //Scaffold.of(context).appBarMaxHeight -
//         43; // Note 43 set in home_screen as Bnav height
//     return
//         // ClipRRect(
//         //   // borderRadius: BorderRadius.circular(10),
//         //   borderRadius: BorderRadius.circular(0.0),
//         //   child:
//         SizedBox(
//       // width: MediaQuery.of(context).size.width,
//       // width: double.infinity,
//       // height: internalHeight * .25,
//       height: internalHeight * .30,
//       child: Stack(
//         // fit: StackFit.expand,
//         children: <Widget>[
//           TabBarView(
//             physics: const BouncingScrollPhysics(),
//             controller: _tabController,
//             children: <Widget>[

//               // _buildPromotion('https://picsum.photos/700/400'),
//               // _buildPromotion('https://picsum.photos/700/350'),
//               // _buildPromotion('https://picsum.photos/700/360'),
//               // _buildPromotion('https://picsum.photos/700/370'),
//               // _buildPromotion('https://picsum.photos/700/380'),

//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               // label was here before
//               // const SizedBox(height: 5.0),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 5.0),
//                   child: TabPageSelector(
//                     color: Colors.white,
//                     selectedColor: Colors.transparent,
//                     controller: _tabController,
//                     indicatorSize: 4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     // )
//     // ;
//   }
// }
