// External
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:provider/provider.dart';

// Internal
import './authenticate_screen.dart';
import './contribute/donate_voice_screen.dart';
import './contribute/validate_screen.dart';
import '../helpers/auth.dart';
import '../helpers/listen_devil.dart';
import '../models/user.dart';
import '../providers/firebase_helper.dart';
import '../providers/user.dart' as user;
import '../widgets/centrally_used.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ListenDevil _listenDevil;

  // @override
  // void initState() {
  //   super.initState();
  //   _listenDevil.init();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _listenDevil.cancelRecorderSubscriptions();
  //   _listenDevil.releaseFlauto();
  // }

  @override
  Widget build(BuildContext context) {
    final double _dashWidth = MediaQuery.of(context).size.width * .93;
    final FireBaseHelper _firebaseHelper = Provider.of<FireBaseHelper>(context);
    final user.User _user = Provider.of<user.User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard',
            style: TextStyle(
              fontFamily: 'AdventPro',
              fontWeight: FontWeight.bold,
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AuthenticateScreen.routeName);
                Auth().signOut();
                // print(Auth().currentUser());
              }),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () =>
                Navigator.of(context).pushNamed(AuthenticateScreen.routeName),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: _firebaseHelper.users.document(_user.instance.uid).snapshots(),
                builder: (context, snapshot) {
                  final _centrallyUsed = CentrallyUsed();
                  if (!snapshot.hasData) return _centrallyUsed.waitingCircle();
                  final User user = User.fromFireStore(snapshot.data);
                  final Country userCountry = Country.findByIsoCode(user.country);
                  return _dashboard([
                    // Info self
                    _dashItem('ID', user.uid),
                    _dashItem('Country', userCountry.name),
                    _dashItem('Telephone', '+${userCountry.dialingCode}-${user.telephone.substring(1)}'),
                    _dashItem('Gender', user.gender),
                  ], _dashWidth);
                }),
            StreamBuilder(
                stream: _firebaseHelper.users.document(_user.instance.uid).snapshots(),
                builder: (context, snapshot) {
                  final _centrallyUsed = CentrallyUsed();
                  if (!snapshot.hasData) return _centrallyUsed.waitingCircle();
                  final User user = User.fromFireStore(snapshot.data);
                  return _dashboard([
                    // Info wazobia
                    _dashItem('Texts read', user.textsRead.toString()),
                    _dashItem('Validations', user.validations.toString()),
                    _dashItem('invitations', user.invitations.toString()),
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
                          child: Text(
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
                          leading: Icon(
                            Icons.mic,
                            color: Colors.deepOrange,
                          ),
                          title: Text('Donate your voice'),
                          onTap: () async {
                            Navigator.of(context).pushNamed(DonateVoiceScreen.routeName);
                          },
                        ),
                        ListTile(
                          // selected: true,
                          leading: Icon(
                            Icons.check,
                            color: Color(0xff2A6041),
                          ),
                          title: Text('Validate'),
                          onTap: () {},
                        ),
                        Divider(),
                        ListTile(
                          // selected: true,
                          leading: Icon(
                            Icons.share,
                            color: Color(0xff2A6041),
                          ),
                          title: Text('Invite to wazobia'),
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

  Widget _dashboard(List<Widget> dashes, double _dashWidth) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Card(
        elevation: 2.0,
        child: Container(
          width: _dashWidth,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[...dashes],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashItem(String label, String value) {
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
