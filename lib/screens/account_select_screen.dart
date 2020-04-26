// Core
import 'dart:convert';
import 'dart:io';

// Extenral
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Internal
import './dashboard_screen.dart';
import './metadata_screen.dart';
import '../providers/user.dart';
import '../widgets/centrally_used.dart';

class AccountSelectScreen extends StatelessWidget {
  static const routeName = '/accsel';

  User _user = User();

  Widget _buildUserOption(
      BuildContext context, String userID, String nickname) {
    return InkWell(
      child: Container(
        height: 60.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(
                nickname,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Abel',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 6,
              child: FittedBox(
                child: Text(
                  userID,
                  style: TextStyle(fontSize: 17.0, fontFamily: 'ComicNeue'),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        this._user.setCurrentUserID(userID);
        Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, String> _users;
    // Provider.of<User>(context).getUsers().then((users) => _users = users);

    final _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            height: _deviceSize.height * .6,
            width: _deviceSize.width * .75,
            child: Column(
              children: <Widget>[
                Container(
                  height: 60.0,
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      border:
                          Border(bottom: BorderSide(color: Colors.green[200]))),
                  child: FittedBox(
                    child: Text(
                      'Choose your account',
                      style: TextStyle(
                        fontSize: 45.0,
                        fontFamily: 'ComicNeue',
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 20.0),
                RaisedButton(
                  onPressed: () => this._user.uploadVoice(voiceToUpload: File(r'C:\Users\sanis\Desktop\flaps\wazobia\nnf.mp3'), title: 'nnf')
                  // onPressed: () => this._user.clear(),
                  // onPressed: () {
                  //   Map<String, String> ty = {};
                  //   ty['t'] = '5';
                  //   ty['y'] = '7';
                  //   ty['y'] = '4';
                  //   print(ty);
                  // },
                ),
                Expanded(
                  child: FutureBuilder(
                    future: this._user.getUsers(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CentrallyUsed().waitingCircle();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        final users = snapshot.data != 'empty'
                            ? json.decode(snapshot.data)
                            : null;
                        return Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(5.0),
                            // color: Colors.grey,
                          ),
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              if (users != null)
                                ...users.entries
                                    .map((entry) => _buildUserOption(
                                        context, entry.value, entry.key))
                                    .toList(),
                              if (users == null) Text('There are no users'),
                              // Text(snapshot.data),
                            ],
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add User'),
                  // child: Text(),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(MetadataScreen.routeName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
