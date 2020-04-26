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
import '../providers/user.dart';
import '../widgets/centrally_used.dart';
// import '../customs/custom_checkbox.dart' as custm;

class MetadataScreen extends StatefulWidget {
  static const routeName = '/meta';

  @override
  _MetadataScreenState createState() => _MetadataScreenState();
}

class _MetadataScreenState extends State<MetadataScreen> {
  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              height: 60.0,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20.0,
                  left: 30.0,
                  right: 30.0),
              // padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0),
              width: double.infinity,
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                  // color: Colors.green,
                  border: Border(bottom: BorderSide(color: Colors.green[200]))),
              child: FittedBox(
                child: Text(
                  'Metadata',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'ComicNeue',
                    color: Colors.green[900],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  // top: MediaQuery.of(context).padding.top + 20.0,
                  top: _deviceSize.height * .10,
                  left: 30.0,
                  right: 30.0),
              child: MetadataForm(),
            ),
          ],
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

  // final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _eduBGFocusNode = FocusNode();

  GlobalKey<FormState> _metaFormKey = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _countryController.dispose();
    _genderController.dispose();
    _eduBGController.dispose();
    // _countryFocusNode.dispose();
    _genderFocusNode.dispose();
    _nicknameFocusNode.dispose();
    _ageFocusNode.dispose();
    _eduBGFocusNode.dispose();
  }

  var _isLoading = false;
  bool _agreedToTerms = false;

  Map<String, String> _metaData = {
    'country': '',
    'gender': '',
    'age': '',
    'edubg': '',
  };

  Country _selectedCountry = Country.NG;
  User _user = User();

  final _eduBGExpansionKey = GlobalKey();
  final _genderExpansionKey = GlobalKey();
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
  Future<String> _setUserData({
    String country,
    String gender,
    // String nickname,
    String age,
    String edubg,
  }) async {
    // final user = Provider.of<User>(context);
    final _userData = databaseRoot.collection('users').document();
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

      databaseRoot.collection('users').document(_userData.documentID).setData({
        'country': country,
        'gender': gender,
        // 'nickname': nickname,
        'age': age,
        'edubg': edubg,
        'textsread': 0,
        'validations': 0,
        'invitations': 0,
      });

      this._user.setCurrentUserID(_userData.documentID);

      return _userData.documentID;
    } catch (e) {
      // print(e);
      var errorMessage = 'Something went wrong. Try again later';
      if (e.toString().contains('This user already exists')) {
        // databaseRoot.collection('users').document(_userData.documentID).delete();
        errorMessage = 'This user already exists';
      }
      _showSnackBar(e);
      // _showSnackBar('An error occured. Check your internet');
      _showDialog('Error', errorMessage);
    }
    return null;
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (!_metaFormKey.currentState.validate()) {
        // Invalid
        setState(() {
          _isLoading = false;
        });
        return;
      }
      _metaFormKey.currentState.save();
      final currentUserID = await _setUserData(
        country: _metaData['country'],
        gender: _metaData['gender'],
        // nickname: _metaData['nickname'],
        age: _metaData['age'],
        edubg: _metaData['edubg'],
      );

      //print(currentUserID);
      //print(_metaData['nickname']);

      // this._user..setContext(context);
      this._user.addUser(_metaData['nickname'], currentUserID).then((_) {
        Navigator.of(context)
            .pushReplacementNamed(DashboardScreen.routeName)
            .then((_) {
          _showDialog('Welcome', 'Thank you for joining us');
        });
      }).catchError((e) {
        _showDialog('Error', e.toString());
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      var errorMessage = 'Something went wrong. Try again later';
      this._user.setCurrentUserID(null);
      if (e.toString().contains('This user already exists')) {
        // databaseRoot.collection('users').document(_userData.documentID).delete();
        errorMessage = 'This user already exists';
      }
      _showDialog('Error', errorMessage);
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

  // Updating snackbar
  void _showSnackBar(String message) {
    Scaffold.of(this.context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(this.context).appBarTheme.color,
        // behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'ComicNeue',
          ),
        ),
        action: SnackBarAction(
          // textColor: Theme.of(this.context).primaryColor,
          label: 'ok',
          onPressed: () {
            Scaffold.of(this.context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

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
      child: Card(
        child: Form(
          key: _metaFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: const Text(
                          // 'Your data is private',
                          'Please fill the form',
                          style: const TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: 16.00,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2A6041),
                          ),
                        ),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.keyboard_arrow_down),
                        label: const Text(
                          'Choose Existing',
                          style: const TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: 16.00,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2A6041),
                          ),
                        ),
                        // child: Text(),
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(
                                AccountSelectScreen.routeName),
                      ),
                    ]),
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
                    suffix: CountryPicker(
                      showDialingCode: false,
                      // showFlag: false,
                      showName: false,
                      dense: false,

                      onChanged: (Country country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                      },
                      selectedCountry: _selectedCountry,
                    ),

                    // fillColor: Theme.of(context).primaryColor.withOpacity(.45),
                  ),
                  // focusNode: _countryFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_genderFocusNode);
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
                    suffix: GestureDetector(
                      key: this._genderExpansionKey,
                      child: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      onTap: () async {
                        final position = buttonMenuPosition(
                            this._genderExpansionKey.currentContext);
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
                        FocusScope.of(context).requestFocus(_nicknameFocusNode);
                        // Focus.of(context).unfocus();
                      },
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
                    // hintText: 'e.g Abba',
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_ageFocusNode);
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
                  // Age
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: _style['formlabel'],
                    labelText: 'Age',
                  ),
                  focusNode: _ageFocusNode,
                  validator: (value) {
                    final RegExp regExp = RegExp(
                      r'^[0-9]*$',
                      caseSensitive: false,
                      multiLine: false,
                    );

                    if (value.isEmpty) {
                      return 'Enter your age';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Age is a positive integer';
                    } else if (!(int.parse(value) < 100 &&
                        int.parse(value) > 2)) {
                      return 'Age out of range';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_eduBGFocusNode);
                  },
                  onSaved: (value) {
                    _metaData['age'] = value.trim();
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
                    suffix: GestureDetector(
                      key: this._eduBGExpansionKey,
                      child: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      onTap: () async {
                        final position = buttonMenuPosition(
                            this._eduBGExpansionKey.currentContext);
                        final _result = await showMenu(
                          context: context,
                          position: position,
                          items: <PopupMenuItem<String>>[
                            const PopupMenuItem<String>(
                                child: const Text('nursery'), value: 'nursery'),
                            const PopupMenuItem<String>(
                                child: const Text('primary'), value: 'primary'),
                            const PopupMenuItem<String>(
                                child: const Text('secondary'),
                                value: 'secondary'),
                            const PopupMenuItem<String>(
                                child: const Text('tertiary'),
                                value: 'tertiary'),
                            const PopupMenuItem<String>(
                                child: const Text('msc'), value: 'msc'),
                            const PopupMenuItem<String>(
                                child: const Text('phd'), value: 'phd'),
                            const PopupMenuItem<String>(
                                child: const Text('none'), value: 'none'),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        );
                        if (_result == 'nursery') {
                          _eduBGController.text = 'nursery';
                        } else if (_result == 'primary') {
                          _eduBGController.text = 'primary';
                        } else if (_result == 'secondary') {
                          _eduBGController.text = 'secondary';
                        } else if (_result == 'tertiary') {
                          _eduBGController.text = 'tertiary';
                        } else if (_result == 'msc') {
                          _eduBGController.text = 'msc';
                        } else if (_result == 'phd') {
                          _eduBGController.text = 'phd';
                        } else if (_result == 'none') {
                          _eduBGController.text = 'none';
                        }
                      },
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
                      return 'Must be one of [primary, secondary, tertiary, msc, phd, none]';
                    }
                    return null;
                  },
                  focusNode: _eduBGFocusNode,
                  onSaved: (value) {
                    _metaData['edubg'] = value.trim();
                  },
                ),
                _spacer,
                _spacer,
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
                        style: TextStyle(color: Colors.black, fontSize: 14),
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
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .70,
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: const Text(
                                            'You must consent to this terms and conditions before you gain acces to wazobia.',
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'PTSans'),
                                          ),
                                        )),
                                      ),
                                      behavior: HitTestBehavior.opaque,
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
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: _isLoading
                        ? CentrallyUsed().waitingCircle()
                        : OutlineButton.icon(
                            label: const Text('Submit'),
                            icon: const Icon(
                              Icons.check,
                              color: const Color(0xff2A6041),
                            ),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .primaryColor, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 1.5, //width of the border
                            ),
                            //child: _isLoading ? CircularProgressIndicator() : Text('Submit'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onPressed:
                                !this._agreedToTerms ? null : () => _submit(),
                            // (){_showDialog('tt', 'content');}
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  String userID;
  @override
  Widget build(BuildContext context) {
    // String _uid;
    // final user = Provider.of<User>(context).getCurrentUserID().then((uid) => _uid = uid);
    // this._context = context;

    this._user.getCurrentUserID().then((uid) => userID = uid);
    // if(userID == null) setState((){});

    return Column(
      children: <Widget>[
        // Text(userID),
        _showMetaForm(),
      ],
    );
  }
}
