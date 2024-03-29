// External
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal
import './authenticate_screen.dart';
import './contribute/donate_voice_screen.dart';
import './contribute/validate_screen.dart';
import '../resources.dart';
import '../helpers/auth.dart';
import '../models/user.dart';
import '../providers/firebase_helper.dart';
import '../providers/user.dart' as user;
import '../screens/account_select_screen.dart';
import '../widgets/centrally_used.dart';
import '../widgets/dash_widgets.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _moreKey = GlobalKey();
  RelativeRect buttonMenuPosition(BuildContext c) {
    final RenderBox bar = c.findRenderObject();
    final RenderBox overlay = Overlay.of(c).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }

  user.User _user = user.User();
  @override
  Widget build(BuildContext context) {
    final double _dashWidth = MediaQuery.of(context).size.width * .93;
    // final FireBaseHelper _firebaseHelper = Provider.of<FireBaseHelper>(context);
    final user.User _user = Provider.of<user.User>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DashBoard',
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 15.0),
            key: this._moreKey,
            icon: const Icon(Icons.menu),
            onPressed: () async {
              final position = buttonMenuPosition(this._moreKey.currentContext);
              final _result = await showMenu(
                context: context,
                position: position,
                items: <PopupMenuItem<String>>[
                  const PopupMenuItem<String>(
                      child: const InkWell(
                        child: const Text('logout'),
                      ),
                      value: 'logout'),
                  // const PopupMenuItem<String>(
                  //     child: const InkWell(
                  //       child: const Text('update account'),
                  //     ),
                  //     value: 'update account'),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              );
              if (_result == 'logout') {
                // Navigator.of(context)
                //     .pushReplacementNamed(AuthenticateScreen.routeName);
                // Auth().signOut();
                // _user.setCurrentUser(null);
                // _user.setInstance(FirebaseAuth.instance.currentUser());
                _user.signOut();
                // print(_user.getCurrentUser());
                Navigator.of(context)
                    .pushReplacementNamed(AccountSelectScreen.routeName);
              }
              // if (_result == 'update account') {
              //   // TO DO
              //   // Show a dialog to update account details with circular progress indicator after
              // }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: this._user.getCurrentUser(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CentrallyUsed().waitingCircle();
          } else if (snapshot.connectionState == ConnectionState.done) {

            final User user = User.fromSharedPreference(snapshot.data);
                  final Country userCountry =
                      Country.findByIsoCode(user.country);

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  DashWidgets.dashboard([
                    // Info self
                    // FutureBuilder(
                    //   future: this._user.userNickname(),
                    //   builder: (ctx, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return CentrallyUsed().waitingCircle();
                    //     } else if (snapshot.connectionState ==
                    //         ConnectionState.done) {
                    //       return DashWidgets.dashItem(
                    //           'Nickname', snapshot.data);
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // DashWidgets.dashItem('ID', user.uid),
                    DashWidgets.dashItem('Country', userCountry.name),
                    // DashWidgets.dashItem('Telephone',
                    //     '+${userCountry.dialingCode}-${user.telephone.substring(1)}'),
                    DashWidgets.dashItem('Gender', user.gender),
                    DashWidgets.dashItem('Age', user.age),
                    DashWidgets.dashItem('Education', user.eduBG),
                  ], _dashWidth),
                  // DashWidgets.dashboard([
                  //   // Info wazobia
                  //   DashWidgets.dashItem(
                  //       'Texts read', user.textsRead.toString()),
                  //   DashWidgets.dashItem(
                  //       'Validations', user.validations.toString()),
                  //   DashWidgets.dashItem(
                  //       'invitations', user.invitations.toString()),
                  // ], _dashWidth),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 2.0,
                      child: Container(
                        width: _dashWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20.0),
                                child: const Text(
                                  'Contribute',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'ComicNeue',
                                    // fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              ListTile(
                                // selected: true,
                                leading: const Icon(
                                  Icons.mic,
                                  color: Colors.deepOrange,
                                ),
                                title: const Text('Donate your voice'),
                                onTap: () async {
                                  Navigator.of(context)
                                      .pushNamed(DonateVoiceScreen.routeName);
                                },
                              ),
                              ListTile(
                                // selected: true,
                                leading: const Icon(
                                  Icons.check,
                                  color: const Color(0xff2A6041),
                                ),
                                title: Text('Validate'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ValidateScreen.routeName);
                                },
                              ),
                              Divider(),
                              ListTile(
                                // selected: true,
                                leading: const Icon(
                                  Icons.share,
                                  color: const Color(0xff2A6041),
                                ),
                                title: const Text('Invite to wazobia'),
                                onTap: () {
                        
                                  final databaseRoot = this._user.databaseRoot;
                                  for (var resource in Resources) {
                                    final imin = resource.readTime.inMinutes.toString();
                                    final isec = (resource.readTime.inSeconds%60).toString();
                                    final omin = imin == '0' ? '' : (imin + 'min${(int.parse(imin)==1)? '' : 's'}');
                                    final osec = isec == '0' ? '' : (isec + 'sec${(int.parse(isec)==1)? '' : 's'}');

                                    databaseRoot.collection('resources').document(resource.uid).setData({
                                      'title': resource.title,
                                      'genre': resource.genre,
                                      'text': resource.text,
                                      'readtime': omin + ' ' + osec,
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            // return StreamBuilder(
            //     stream:
            //         _firebaseHelper.users.document(_snapshot.data).snapshots(),
            //     builder: (context, snapshot) {
            //       final _centrallyUsed = CentrallyUsed();
            //       if (!snapshot.hasData) return _centrallyUsed.waitingCircle();
            //       if (snapshot.data == null) {
            //         return Center(
            //           child: Text(
            //             'This user doesn\'t exist',
            //             style: TextStyle(
            //               fontSize: 25,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         );
            //       }
            //       final User user = User.fromFireStore(snapshot.data);
            //       final Country userCountry =
            //           Country.findByIsoCode(user.country);
            //       print(snapshot.data);

            //     });
          }
          return null;
        },
      ),
    );
  }
}
