// Core
import 'dart:io';

// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal
import './account_select_screen.dart';
import './dashboard_screen.dart';
import '../helpers/auth.dart';
import '../lifters/sieve_lift.dart';
import '../models/user.dart' as userM;
import '../providers/user.dart';
import '../terms_about_help.dart';
import '../widgets/centrally_used.dart';
// import '../customs/custom_checkbox.dart' as custm;

class MetadataScreen extends StatefulWidget {
  static const routeName = '/meta';

  @override
  _MetadataScreenState createState() => _MetadataScreenState();
}

class _MetadataScreenState extends State<MetadataScreen> {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure',
              style: TextStyle(
                fontFamily: 'Abel',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: Text(
              'Do you want to exit wazobia?',
              style: const TextStyle(
                fontFamily: 'Abel',
                fontSize: 17.0,
                // fontWeight: FontWeight.bold
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  'Yes',
                  style: const TextStyle(
                    fontFamily: 'PTSans',
                    fontSize: 17.0,
                    // fontWeight: FontWeight.bold
                    // color: Colors.white,
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.lightGreen,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: const TextStyle(
                    fontFamily: 'PTSans',
                    fontSize: 17.0,
                    // fontWeight: FontWeight.bold
                    // color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).size.width);
    // final Size _deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SieveLift(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(
                //   height: 0.0,
                // ),
                Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 5.0,
                      left: 30.0,
                      right: 30.0),
                  // padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0),
                  width: double.infinity,
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      border:
                          Border(bottom: BorderSide(color: Colors.green[200]))),
                  child: FittedBox(
                    child: Text(
                      'Metadata',
                      style: TextStyle(
                        fontSize: 45.0,
                        fontFamily: 'ComicNeue',
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    // top: MediaQuery.of(context).padding.top + 20.0,
                    top: 15.0,
                    // left: 0.0,
                    // right: 0.0,
                  ),
                  child: MetadataForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MetadataForm extends StatefulWidget {
  @override
  _MetadataFormState createState() => _MetadataFormState();
}

class _MetadataFormState extends State<MetadataForm> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _eduBGController = TextEditingController();
  final TextEditingController _ageRangeController = TextEditingController();

  // final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _ageRangeFocusNode = FocusNode();
  final FocusNode _eduBGFocusNode = FocusNode();

  GlobalKey<FormState> _metaFormKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _countryController.dispose();
    _genderController.dispose();
    _eduBGController.dispose();
    _ageRangeController.dispose();
    // _countryFocusNode.dispose();
    _genderFocusNode.dispose();
    _nicknameFocusNode.dispose();
    _ageRangeFocusNode.dispose();
    _eduBGFocusNode.dispose();
  }

  bool _isLoading = false;
  bool _agreedToTerms = false;

  Map<String, String> _metaData = {
    'nickname': '',
    'country': '',
    'gender': '',
    'agerange': '',
    'edubg': '',
  };

  Country _selectedCountry = Country.NG;
  User _user = User();
  Auth _auth = Auth();

  final _eduBGExpansionKey = GlobalKey();
  final _genderExpansionKey = GlobalKey();
  final _ageRangeExpansionKey = GlobalKey();
  final _nicknameHelpExpansionKey = GlobalKey();
  final _proceedHelpExpansionKey = GlobalKey();

  // T show help text around where button pressed
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

  Firestore databaseRoot = Firestore.instance;
  userM.User _setUserData({
    String nickname,
    String country,
    String gender,
    // String nickname,
    String ageRange,
    String edubg,
  }) {
    // final user = Provider.of<User>(context);
    // final _userData = databaseRoot.collection('users').document();
    // print(_userData.documentID);
    try {
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // bool firstTime = pref.getBool('first_time');
      // String userID = pref.getString('userID');

      // if (userID != null) {
      //   // Not first time
      //   databaseRoot.collection('users').document(userID).setData({
      //     'country': country,
      //     'gender': gender,
      //     'age': age,
      //     'edubg': edubg,
      //     'textsread': 0,
      //     'validations': 0,
      //     'invitations': 0,
      //   });

      // } else {
      //   // First time
      //   final _userData = databaseRoot.collection('users').document();
      //   pref.setString('userID', _userData.documentID);
      //   _userData.setData({});

      //   // pref.setStringList('userIDs', []);
      //   // pref.setBool('first_time', false);
      // }

      // databaseRoot.collection('users').document(_userData.documentID).setData({
      //   'country': country,
      //   'gender': gender,
      //   // 'nickname': nickname,
      //   'age': age,
      //   'edubg': edubg,
      //   'textsread': 0,
      //   'validations': 0,
      //   'invitations': 0,
      // });
      final userM.User userModel = userM.User(
        nickname: nickname,
        country: country,
        gender: gender,
        ageRange: ageRange,
        eduBG: edubg,
      );

      this._user.setCurrentUser(nickname);

      return userModel;
    } catch (e) {
      // print(e);
      var errorMessage = 'Something went wrong. Try again later';
      if (e
          .toString()
          .contains('This nickname is already taken by another local user')) {
        // databaseRoot.collection('users').document(_userData.documentID).delete();
        errorMessage = 'This nickname is already taken by another local user';
        this._user.setContext(context);
        this._user.showSnackBar(errorMessage);
      }
      // _showSnackBar(e);
      // _showSnackBar('An error occured. Check your internet');
      _showDialog('Error', errorMessage);
    }
    return null;
  }

  Future<void> _submit() async {
    // this._isLoading = true;
    try {
      setState(() {
        _isLoading = true;
      });
      if (!_metaFormKey.currentState.validate()) {
        // Invalid
        // setState(() {
        //   _isLoading = false;
        // });
        return;
      }
      _metaFormKey.currentState.save();
      final userModel = _setUserData(
        nickname: _metaData['nickname'],
        country: _metaData['country'],
        gender: _metaData['gender'],
        // nickname: _metaData['nickname'],
        ageRange: _metaData['agerange'],
        edubg: _metaData['edubg'],
      );

      //print(currentUserID);
      //print(_metaData['nickname']);

      // this._user..setContext(context);

      this._auth.signInAnonymously().then((authenticatedUser) {
        this._user.addUser(userModel).then((_) {
          this._user.setCurrentUser(_metaData['nickname']);
          Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
        }).catchError((e) {
          this._user.setCurrentUser(null);
          authenticatedUser.delete();
          var errorMessage = 'Something went wrong. Try again later';
          if (e.toString().contains(
              'This nickname is already taken by another local user')) {
            // databaseRoot.collection('users').document(_userData.documentID).delete();
            errorMessage =
                'This nickname is already taken by another local user';
            this._user.setContext(context);
            this._user.showSnackBar(errorMessage);
            return;
          }
          _showDialog('Error', errorMessage);
        });
      }).catchError((e) async {
        this._user.setCurrentUser(null);
        var errorMessage = 'An error occured. Try again later.';
        if (e.message.toString().contains('network error')) {
          errorMessage = 'Check your internet connection';
        }
        this._user.setContext(context);
        this._user.showSnackBar(errorMessage);
      });

      // setState(() {
      //   _isLoading = false;
      // });
    } catch (e) {
      // setState(() {
      //   _isLoading = false;
      // });
      this._user.setCurrentUser(null);
      var errorMessage = 'Something went wrong. Try again later';
      if (e
          .toString()
          .contains('This nickname is already taken by another local user')) {
        // databaseRoot.collection('users').document(_userData.documentID).delete();
        errorMessage = 'This nickname is already taken by another local user';
        this._user.setContext(context);
        this._user.showSnackBar(errorMessage);
        return;
      } else if (e.message.toString().contains(
          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.')) {
        errorMessage = 'An error occured. Check your internet connection.';
      }
      _showDialog('Error', errorMessage);
      // print(e);
    }
  }

  // Updating dialog
  void _showDialog(String title, String content) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Abel', fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontFamily: 'Abel',
            fontSize: 17.0,
            // fontWeight: FontWeight.bold
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _onTapAgeRange() async {
    final position =
        buttonMenuPosition(this._ageRangeExpansionKey.currentContext);
    final _result = await showMenu(
      context: context,
      position: position,
      items: <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
            child: const Text('3-5(Parental control)'), value: '3-5'),
        const PopupMenuItem<String>(
            child: const Text('6-12(Parental control)'), value: '6-12'),
        const PopupMenuItem<String>(
            child: const Text('13-18(Parental control)'), value: '13-18'),
        const PopupMenuItem<String>(child: const Text('19-24'), value: '19-24'),
        const PopupMenuItem<String>(child: const Text('25-34'), value: '25-34'),
        const PopupMenuItem<String>(child: const Text('35-49'), value: '35-49'),
        const PopupMenuItem<String>(child: const Text('50-64'), value: '50-64'),
        const PopupMenuItem<String>(child: const Text('65-69'), value: '65-69'),
        const PopupMenuItem<String>(child: const Text('70-79'), value: '70-79'),
        const PopupMenuItem<String>(child: const Text('80-90'), value: '80-90'),
        const PopupMenuItem<String>(
            child: const Text('more than 90'), value: 'more than 90'),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );

    // if (_result == '3-5') {
    //   this._ageRangeController.text = '3-5';
    // } else if (_result == '6-12') {
    //   this._ageRangeController.text = '6-12';
    // } else if (_result == '13-18') {
    //   this._ageRangeController.text = '13-18';
    // } else if (_result == '19-24') {
    //   this._ageRangeController.text = '19-24';
    // } else if (_result == '25-34') {
    //   this._ageRangeController.text = '25-34';
    // } else if (_result == '35-49') {
    //   this._ageRangeController.text = '35-49';
    // } else if (_result == '50-64') {
    //   this._ageRangeController.text = '50-64';
    // } else if (_result == '65-69') {
    //   this._ageRangeController.text = '65-69';
    // } else if (_result == '70-79') {
    //   this._ageRangeController.text = '70-79';
    // } else if (_result == '80-89') {
    //   this._ageRangeController.text = '80-89';
    // } else if (_result == 'more than 90') {
    //   this._ageRangeController.text = 'more than 90';
    // }

    this._ageRangeController.text = _result;

    if (_result != null) {
      FocusScope.of(context).requestFocus(_eduBGFocusNode); // Redundant
      this._onTapEducation();
    }
  }

  void _onTapGender() async {
    final position =
        buttonMenuPosition(this._genderExpansionKey.currentContext);
    final _result = await showMenu(
      context: context,
      position: position,
      items: <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
            child: InkWell(
              child: Text('male'),
            ),
            value: 'male'),
        const PopupMenuItem<String>(
            child: const Text('female'), value: 'female'),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
    if (_result == 'male') {
      _genderController.text = 'male';
    } else if (_result == 'female') {
      _genderController.text = 'female';
    }
    if (_result != null)
      FocusScope.of(context).requestFocus(_nicknameFocusNode); // Redundant
    // Focus.of(context).unfocus();
  }

  void _onTapEducation() async {
    final position = buttonMenuPosition(this._eduBGExpansionKey.currentContext);
    final _result = await showMenu(
      context: context,
      position: position,
      items: <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
            child: const Text('nursery'), value: 'nursery'),
        const PopupMenuItem<String>(
            child: const Text('primary'), value: 'primary'),
        const PopupMenuItem<String>(
            child: const Text('secondary'), value: 'secondary'),
        const PopupMenuItem<String>(
            child: const Text('tertiary'), value: 'tertiary'),
        const PopupMenuItem<String>(child: const Text('msc'), value: 'msc'),
        const PopupMenuItem<String>(child: const Text('phd'), value: 'phd'),
        const PopupMenuItem<String>(child: const Text('none'), value: 'none'),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );

    // if (_result == 'nursery') {
    //   _eduBGController.text = 'nursery';
    // } else if (_result == 'primary') {
    //   _eduBGController.text = 'primary';
    // } else if (_result == 'secondary') {
    //   _eduBGController.text = 'secondary';
    // } else if (_result == 'tertiary') {
    //   _eduBGController.text = 'tertiary';
    // } else if (_result == 'msc') {
    //   _eduBGController.text = 'msc';
    // } else if (_result == 'phd') {
    //   _eduBGController.text = 'phd';
    // } else if (_result == 'none') {
    //   _eduBGController.text = 'none';
    // }

    this._eduBGController.text = _result;
  }

  void _onTapHelp(String helpText, BuildContext context) async {
    final position = buttonMenuPosition(context);
    showMenu(
      color: Colors.amber,
      context: context,
      position: position,
      items: <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: InkWell(
            // Inkwell redundant
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'PTSans',
              ),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  // void _onTapNicknameHelp() async {
  //   final position =
  //       buttonMenuPosition(this._genderExpansionKey.currentContext);
  //   showMenu(
  //     color: Colors.amber,
  //     context: context,
  //     position: position,
  //     items: <PopupMenuItem<String>>[
  //       const PopupMenuItem<String>(
  //           child: InkWell( // Inkwell redundant
  //             child: Text(
  //               'Any name you can recall. Preferably one that doesn\'t include your real name e.g "winterknight".',
  //               style: TextStyle(
  //                 fontSize: 15.0,
  //                 fontFamily: 'PTSans',
  //               ),
  //             ),
  //           ),
  //           value: 'male'),
  //     ],
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(5.0),
  //     ),
  //   );
  // }

  Map<String, dynamic> _style = {
    'formlabel': const TextStyle(fontFamily: 'Montserrat', fontSize: 14.0),
  };

  Widget _showMetaForm() {
    // final user = Provider.of<User>(context);
    final Widget _spacer = const SizedBox(
      height: 8,
    );
    _countryController.text = _selectedCountry.name;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Card(
            child: Form(
              key: _metaFormKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: const Text(
                              // 'Your data is private',
                              'Please fill the form  OR ',
                              style: const TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: 16.00,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff2A6041),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RaisedButton.icon(
                              color: Colors.lightGreen,
                              icon: Icon(Icons.keyboard_arrow_down),
                              label: const Text(
                                'Choose Existing',
                                style: const TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: 16.00,
                                  fontWeight: FontWeight.w600,
                                  // color: const Color(0xff2A6041),
                                  color: Colors.white,
                                ),
                              ),
                              // child: Text(),
                              onPressed: () => Navigator.of(context).pushNamed(
                                AccountSelectScreen.routeName,
                                arguments: true,
                              ),
                            ),
                          ),
                        ]),
                    _spacer,
                    _spacer,
                    _spacer,
                    TextFormField(
                      // Country
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelStyle: _style['formlabel'],
                        // prefixText: '+234-',

                        labelText: 'Country',
                        suffixIcon: IgnorePointer(
                          ignoring: true,
                          child: CountryPicker(
                            showDialingCode: false,
                            // showFlag: false,
                            showName: false,
                            dense: false,

                            onChanged: (Country country) {
                              _selectedCountry = country;
                              // setState(() {
                              // });
                            },
                            selectedCountry: _selectedCountry,
                          ),
                        ),

                        // fillColor: Theme.of(context).primaryColor.withOpacity(.45),
                      ),
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          defaultCountry: _selectedCountry,
                        ).then((country) {
                          if (country == null) return;
                          _selectedCountry = country;
                          FocusScope.of(context)
                              .requestFocus(this._genderFocusNode); //Redundant
                          this._onTapGender();
                        });
                      },
                      // focusNode: _countryFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_genderFocusNode);
                        this._onTapGender(); // Redundant
                      },
                      onSaved: (value) {
                        _metaData['country'] = _selectedCountry.isoCode;
                      },
                    ),
                    _spacer,
                    TextFormField(
                      // Gender
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      controller: _genderController,
                      decoration: InputDecoration(
                        labelStyle: _style['formlabel'],
                        // prefixText: '+234-',
                        labelText: 'Gender',
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          key: this._genderExpansionKey,
                        ),
                        // fillColor: Theme.of(context).primaryColor.withOpacity(.45),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Choose a gender';
                        } else if (!(value == 'male' || value == 'female')) {
                          return 'Gender must be male or female';
                        }
                        return null;
                      },
                      onTap: this._onTapGender,
                      focusNode: _genderFocusNode,
                      onSaved: (value) {
                        _metaData['gender'] = value.trim();
                      },
                    ),
                    _spacer,
                    TextFormField(
                      // Nickname Field
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: _style['formlabel'],
                        labelText: 'Nickname',
                        hintText: 'e.g winterknight',
                        suffixIcon: IconButton(
                          key: this._nicknameHelpExpansionKey,
                          // color: Colors.deepOrange[400],
                          icon: Icon(Icons.help),
                          onPressed: () => this._onTapHelp(
                            nicknameHelpText['help'],
                            this._nicknameHelpExpansionKey.currentContext,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (nickname) {
                        if (nickname == null || (nickname.trim() == '')) return;
                        FocusScope.of(context)
                            .requestFocus(_ageRangeFocusNode); // Redundant
                        this._onTapAgeRange();
                      },

                      validator: (value) {
                        final RegExp regExp = RegExp(
                          r'^[a-zA-Z0-9\s]{1,20}$',
                          caseSensitive: false,
                          multiLine: false,
                        );

                        if (value.isEmpty) {
                          // user['nickname'] = user['firstname'];
                          return null;
                        } else if (value.length > 20) {
                          return 'Nickname too long';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Exclude special characters';
                        } else {
                          return null;
                        }
                      },
                      focusNode: _nicknameFocusNode,
                      onSaved: (value) {
                        _metaData['nickname'] = value.trim();
                      },
                    ),
                    _spacer,
                    TextFormField(
                      // Age Range
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      controller: this._ageRangeController,
                      decoration: InputDecoration(
                        labelStyle: _style['formlabel'],
                        labelText: 'Age Range',
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          key: this._ageRangeExpansionKey,
                        ),
                      ),
                      focusNode: _ageRangeFocusNode,
                      // validator: (value) {
                      //   final RegExp regExp = RegExp(
                      //     r'^[0-9]*$',
                      //     caseSensitive: false,
                      //     multiLine: false,
                      //   );

                      //   if (value.isEmpty) {
                      //     return 'Enter your age range';
                      //   } else if (!regExp.hasMatch(value)) {
                      //     return 'Age is a positive integer';
                      //   } else if (!(int.parse(value) < 100 &&
                      //       int.parse(value) > 2)) {
                      //     return 'Age out of range';
                      //   }
                      //   return null;
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Choose an age range';
                        } else if (!(value == '3-5' ||
                            value == '6-12' ||
                            value == '13-18' ||
                            value == '19-24' ||
                            value == '25-34' ||
                            value == '35-49' ||
                            value == '50-64' ||
                            value == '65-69' ||
                            value == '70-79' ||
                            value == '80-90' ||
                            value == 'more than 90')) {
                          return 'Must select from options';
                        }
                        return null;
                      },
                      onTap: this._onTapAgeRange,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_eduBGFocusNode);
                      // },
                      onSaved: (value) {
                        _metaData['agerange'] = value.trim();
                      },
                    ),
                    _spacer,
                    TextFormField(
                      // Educational Background
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      controller: _eduBGController,
                      decoration: InputDecoration(
                        labelStyle: _style['formlabel'],
                        // prefixText: '+234-',
                        labelText: 'Education',
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          key: this._eduBGExpansionKey,
                        ),
                        // fillColor: Theme.of(context).primaryColor.withOpacity(.45),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Choose an educational background';
                        } else if (!(value == 'nursery' ||
                            value == 'primary' ||
                            value == 'secondary' ||
                            value == 'tertiary' ||
                            value == 'msc' ||
                            value == 'phd' ||
                            value == 'none')) {
                          return 'Must select from options';
                        }
                        return null;
                      },
                      onTap: this._onTapEducation,
                      focusNode: _eduBGFocusNode,
                      onSaved: (value) {
                        _metaData['edubg'] = value.trim();
                      },
                    ),
                    _spacer,
                    // _spacer,
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Checkbox(
                            value: _agreedToTerms,
                            activeColor: Colors.deepOrange[600],
                            // useTapTarget: false,
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
                        ),
                        RichText(
                          // overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Abel',
                              fontSize: 15.0,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'I agree to '),
                              TextSpan(
                                text: 'terms and conditions',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to Terms and Conditions Page
                                    // Navigator.of(context)
                                    //     .pushNamed(
                                    //         TermsConditionsScreen.routeName);

                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        final MediaQueryData deviceCritical =
                                            MediaQuery.of(context);
                                        double titleHeight = 30.0;
                                        double heightBtwTitleChild = 5.0;
                                        double sheetHeight =
                                            deviceCritical.size.height * .7 -
                                                16.0 -
                                                132.0;
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {},
                                          child: Container(
                                            alignment: Alignment.center,
                                            height:
                                                deviceCritical.size.height * .7,
                                            child: Center(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        // height of title
                                                        height: titleHeight,
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 1.0,
                                                                right: 1.0,
                                                                top: 1.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                // color: Colors.green,
                                                                border: Border(
                                                                    bottom: BorderSide(
                                                                        color: Colors
                                                                            .green[200]))),
                                                        child: FittedBox(
                                                          child: Text(
                                                            'Terms and Conditions',
                                                            style: TextStyle(
                                                              fontSize: 70.0,
                                                              fontFamily:
                                                                  'ComicNeue',
                                                              color: Colors
                                                                  .green[900],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        // space btw child and title
                                                        height:
                                                            heightBtwTitleChild,
                                                      ),
                                                      Container(
                                                        height: sheetHeight -
                                                            titleHeight,
                                                        // height: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        // padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0, right: 0.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.green),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          // color: Colors.grey,
                                                        ),
                                                        child: Scrollbar(
                                                          // controller: _scrollController,
                                                          child:
                                                              SingleChildScrollView(
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            child: const Text(
                                                              termsAndConditionsText,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  fontFamily:
                                                                      'PTSans'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        );
                                      },
                                    );

                                    // Navigator.of(context).pushNamed('/meta');
                                  },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: this._isLoading
                              ? CentrallyUsed().waitingCircle()
                              : OutlineButton.icon(
                                  label: const Text('Proceed'),
                                  icon: const Icon(
                                    Icons.check,
                                    color: const Color(0xff2A6041),
                                  ),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor, //Color of the border
                                    style:
                                        BorderStyle.solid, //Style of the border
                                    width: 1.5, //width of the border
                                  ),
                                  //child: _isLoading ? CircularProgressIndicator() : Text('Submit'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  onPressed: !this._agreedToTerms
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          final user = Provider.of<User>(
                                              context,
                                              listen: false);
                                          user.setContext(context);
                                          final bool internet =
                                              await user.connectionStatus();
                                          _submit().then((value) => setState(
                                              () => this._isLoading = false));
                                          // if (internet) {
                                          // } else {
                                          //   setState(() {
                                          //     _isLoading = false;
                                          //   });
                                          //   user.showSnackBar(
                                          //       'Check your internet');
                                          // }
                                          // setState(() {
                                          //   _isLoading = false;
                                          // });
                                        },
                                  // (){_showDialog('tt', 'content');}
                                ),
                        ),
                        IconButton(
                          key: this._proceedHelpExpansionKey,
                          color: Colors.green,
                          icon: Icon(Icons.help),
                          onPressed: () => this._onTapHelp(
                              proceedHelpText['help'],
                              this._proceedHelpExpansionKey.currentContext),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.info_outline,
                color: Color(0xffff0000),
              ),
              SizedBox(
                width: 2.0,
              ),
              Text(
                'Create a new user if someone else is contributing',
                style: TextStyle(
                  fontFamily: 'Abel',
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String userID;
  @override
  Widget build(BuildContext context) {
    // String _uid;
    // final user = Provider.of<User>(context).getCurrentUserID().then((uid) => _uid = uid);
    // this._context = context;

    // this._user.getCurrentUserID().then((uid) => userID = uid);
    // if(userID == null) setState((){});

    return Column(
      children: <Widget>[
        // Text(userID),
        _showMetaForm(),
      ],
    );
  }
}
