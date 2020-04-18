// External
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:provider/provider.dart';

// Internal
import './authenticate_screen.dart';
import './contribute/donate_voice_screen.dart';
import './contribute/validate_screen.dart';
import '../helpers/auth.dart';
import '../models/user.dart';
import '../providers/firebase_helper.dart';
import '../providers/user.dart' as user;
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

  @override
  Widget build(BuildContext context) {
    final double _dashWidth = MediaQuery.of(context).size.width * .93;
    final FireBaseHelper _firebaseHelper = Provider.of<FireBaseHelper>(context);
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
                  const PopupMenuItem<String>(
                      child: const InkWell(
                        child: const Text('update account'),
                      ),
                      value: 'update account'),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              );
              if (_result == 'logout') {
                Navigator.of(context)
                    .pushReplacementNamed(AuthenticateScreen.routeName);
                Auth().signOut();
              }
              if (_result == 'update account') {
                // TO DO
                // Show a dialog to update account details with circular progress indicator after
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            StreamBuilder(
                stream: _firebaseHelper.users
                    .document(_user.instance.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final _centrallyUsed = CentrallyUsed();
                  if (!snapshot.hasData) return _centrallyUsed.waitingCircle();
                  final User user = User.fromFireStore(snapshot.data);
                  final Country userCountry =
                      Country.findByIsoCode(user.country);
                  return DashWidgets.dashboard([
                    // Info self
                    DashWidgets.dashItem('ID', user.uid),
                    DashWidgets.dashItem('Country', userCountry.name),
                    DashWidgets.dashItem('Telephone',
                        '+${userCountry.dialingCode}-${user.telephone.substring(1)}'),
                    DashWidgets.dashItem('Gender', user.gender),
                  ], _dashWidth);
                }),
            StreamBuilder(
                stream: _firebaseHelper.users
                    .document(_user.instance.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final _centrallyUsed = CentrallyUsed();
                  if (!snapshot.hasData) return _centrallyUsed.waitingCircle();
                  final User user = User.fromFireStore(snapshot.data);
                  return DashWidgets.dashboard([
                    // Info wazobia
                    DashWidgets.dashItem(
                        'Texts read', user.textsRead.toString()),
                    DashWidgets.dashItem(
                        'Validations', user.validations.toString()),
                    DashWidgets.dashItem(
                        'invitations', user.invitations.toString()),
                  ], _dashWidth);
                }),
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
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
