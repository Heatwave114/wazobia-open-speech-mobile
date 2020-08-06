// External
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

// Internal
import '../customs/custom_checkbox.dart' as custm;
import '../helpers/auth.dart';
import '../providers/user.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/centrally_used.dart';

enum AuthMode {
  JoinUs,
  Authenticate,
}

class AuthenticateScreen extends StatefulWidget {
  static const routeName = 'authenticate';
  AuthMode _authMode = AuthMode.Authenticate;

  void loadJoinUs() {
    this._authMode = AuthMode.JoinUs;
  }

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              height: kBottomNavigationBarHeight,
            ),
            Container(
              // Welcome
              padding: const EdgeInsets.only(left: 15.0),
              color: Theme.of(context).primaryColor,
              height: 60.0,
              width: double.infinity,
              child: const Text(
                'Welcome to Wazobia',
                style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontFamily: 'AdventPro'),
                // textAlign: TextAlign.left,
              ),
            ),
            // Text(this._authMode == AuthMode.Authenticate ? 'Authenticate with your telephone number' : 'Join the Wazobia community!'),
            Container(
                // Login/Join toggle
                height: 40.0,
                margin: const EdgeInsets.only(top: 25.00),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: _deviceSize.width * .8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          // Authenticate
                          child: Container(
                            // height: 100.00,
                            // width: 100.00,
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: const Radius.circular(10.0),
                                topLeft: const Radius.circular(10.0),
                              ),
                              child: Center(
                                  child: Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: 16.0,
                                  fontWeight: this.widget._authMode != null &&
                                          this.widget._authMode ==
                                              AuthMode.Authenticate
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Color(0xff2A6041),
                                ),
                              )),
                              onTap: () {
                                setState(() {
                                  this.widget._authMode = AuthMode.Authenticate;
                                });
                              },
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 0.0,
                          color: Colors.green,
                        ),
                        Expanded(
                          // JoinUs
                          child: Container(
                            // height: 100.00,
                            // width: 100.00,
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                bottomRight: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                              ),
                              child: Center(
                                  child: Text(
                                'Join Us',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: 16.0,
                                  fontWeight: this.widget._authMode != null &&
                                          this.widget._authMode ==
                                              AuthMode.JoinUs
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Color(0xff2A6041),
                                ),
                              )),
                              onTap: () {
                                setState(() {
                                  this.widget._authMode = AuthMode.JoinUs;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),

            Container(
              // AuthForm
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 35.0),
              // height: _deviceSize.height * .6,
              child: AuthForm(this.widget._authMode),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  final AuthMode authMode;

  const AuthForm(this.authMode);

  set setAuthMode(AuthMode authMode) => authMode = authMode;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _telephoneFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  GlobalKey<FormState> _formKeyAuthenticate = GlobalKey();
  GlobalKey<FormState> _formKeyJoinUs = GlobalKey();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    _genderController.dispose();
    _emailFocusNode.dispose();
    _countryFocusNode.dispose();
    _telephoneFocusNode.dispose();
    _genderFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  var _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'country': '',
    'telephone': '',
    'gender': '',
  };

  // String _smsCode;
  Auth _auth = Auth();
  User _user = User();
  Country _selectedCountry = Country.NG;

  // final _moreKey = GlobalKey<State<BottomNavigationBar>>();
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

  var _agreedToTerms = false;

  var _passwordIsVisible = false;
  void _togglePasswordVisibility() {
    setState(() {
      _passwordIsVisible = !_passwordIsVisible;
    });
  }

  Future<void> _authentiate({
    String email,
    String password,
  }) async {
    // final auth = Auth();
    try {
      if (this.widget.authMode == AuthMode.Authenticate) {
        await this
            ._auth
            .signInWithEmailAndPassword(email, password)
            .then((instance) {
          if (instance.isEmailVerified) {
            Navigator.of(context)
                .pushReplacementNamed(DashboardScreen.routeName);
          } else {
            // Have to verify before login
            _showDialog('Alert', 'Verify your email before you login');
          }
        });
      } else {
        await this
            ._auth
            .createUserWitEmailAndPassword(email, password)
            .then((instance) {
          instance.sendEmailVerification();
          _user.setUserdata(
            country: _authData['country'],
            telephone: _authData['telephone'],
            gender: _authData['gender'],
          );

          // Have to verify after sign up
          _showDialog('Welcome to wazobia',
              'We have sent you a verification email. Verify your email before you login');
        });
        //notifyListeners();
        // We have sent you verification email
        // Navigate to Login
        // Navigator.of(context)
        //     .pushReplacementNamed(AuthenticateScreen.routeName);

        // _showSnackBar(
        //   'we have sent you a verification email. Verify your email before you login',
        // );

      }

      // setState(() {
      //   _isLoading = false;
      // });

    } catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains(
          'There is no user record corresponding to this identifier. The user may have been deleted')) {
        errorMessage =
            'There is no user record corresponding to this credentials';
      } else if (error.toString().contains(
          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.')) {
        errorMessage = 'An error has occured. Check your internet connection';
      } else if (error
          .toString()
          .contains('The email address is already in use by another account')) {
        errorMessage = 'The email address is already in use by another account';
      } else if (error.toString().contains(
          'The password is invalid or the user does not have a password')) {
        errorMessage = 'Email or password invalid';
      } else if (error.toString().contains(
          'We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later ]')) {
        errorMessage = 'Too many unsuccessful login attempts. Try again later';
      }

      // setState(() {
      //   _isLoading = false;
      // });

      // print(error.message);
      // print(errorMessage);
      //_showAlertDialog(context: context, message: errorMessage);
      _showSnackBar(errorMessage);
    }
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

  // Updating dialog
  void _showDialog(String title, String content) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.green, width: 2.0),
        ),
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
              if (this.widget.authMode == AuthMode.JoinUs) {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AuthenticateScreen.routeName);
                return;
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (this.widget.authMode == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final formKey = this.widget.authMode == AuthMode.Authenticate
        ? _formKeyAuthenticate
        : _formKeyJoinUs;
    if (!formKey.currentState.validate()) {
      // Invalid
      setState(() {
        _isLoading = false;
      });
      return;
    }

// No need for this below because its above
    setState(() {
      _isLoading = true;
    });
// No need for this above because its above

    formKey.currentState.save();
    await _authentiate(
      email: _authData['email'],
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });

    // _user.setUserdata(
    //   country: _authData['country'],
    //   telephone: _authData['telephone'],
    //   gender: _authData['gender'],
    // );

    // if (this.widget.authMode == AuthMode.Authenticate) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   formKey.currentState.save();
    //   await _authentiate(
    //     email: _authData['email'],
    //     password: _passwordController.text,
    //   );
    //   setState(() {
    //     _isLoading = false;
    //   });
    // } else {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   formKey.currentState.save();
    //   await _authentiate(
    //     email: _authData['email'],
    //     password: _passwordController.text,
    //   );
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

// SMS SMS SMS
  // Future<bool> _smsCodeDialog(String message) {
  //   return showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('Enter verification code sent to your number'),
  //       content: TextField(
  //         onChanged: (value) {
  //           this._smsCode = value;
  //         },
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text('Submit'),
  //           onPressed: () {
  //             _auth.currentUser().then((user) {
  //               if (user != null) {
  //                 Navigator.of(ctx).pop();
  //                 Navigator.of(context)
  //                     .pushReplacementNamed(DashboardScreen.routeName);
  //               } else {}
  //             });
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  Map<String, dynamic> _style = {
    'formlabel': const TextStyle(fontFamily: 'Montserrat', fontSize: 14.0),
  };

  Widget _showAuthForm() {
    final Widget _spacer = const SizedBox(
      height: 8,
    );
    _countryController.text =
        _selectedCountry.name; // Selected the country name at Join Us
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Card(
        child: Form(
          key: this.widget.authMode == AuthMode.Authenticate
              ? _formKeyAuthenticate
              : _formKeyJoinUs,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      widget.authMode == AuthMode.Authenticate
                          ? 'Sign in to access you account '
                          : 'Join the Wazobia community!',
                      style: const TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: 16.00,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff2A6041),
                      ),
                    ),
                  ),
                ]),
                TextFormField(
                  // Email
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelStyle: _style['formlabel'],
                    labelText: 'Email',
                    hintText: this.widget.authMode == AuthMode.Authenticate
                        ? '' //Nickname or (TO DO)
                        : 'e.g wazobia@waz.net',
                  ),
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) {
                    final focusedFormEmail =
                        this.widget.authMode == AuthMode.Authenticate
                            ? _passwordFocusNode
                            : _countryFocusNode;
                    FocusScope.of(context).requestFocus(focusedFormEmail);
                  },
                  validator: (value) {
                    final RegExp regExp = RegExp(
                      r"[a-z0-9!#$%&'*+/=?^`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)\b",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if (value.isEmpty) {
                      return this.widget.authMode == AuthMode.Authenticate
                          ? 'This field is required'
                          : 'Email Field can not be empty';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Enter a valid Email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value.trim();
                  },
                ),
                if (this.widget.authMode == AuthMode.JoinUs) _spacer,
                if (this.widget.authMode == AuthMode.JoinUs)
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
                    focusNode: _countryFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_telephoneFocusNode);
                    },
                    onSaved: (value) {
                      _authData['country'] = _selectedCountry.isoCode;
                    },
                  ),
                if (this.widget.authMode == AuthMode.JoinUs) _spacer,
                if (this.widget.authMode == AuthMode.JoinUs)
                  TextFormField(
                    // Telephone
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: _style['formlabel'],
                      prefixText: '+${_selectedCountry.dialingCode} ',
                      labelText: 'Telephone',
                      // hintText: '8*********',
                      // fillColor: Theme.of(context).primaryColor.withOpacity(.45),
                    ),
                    focusNode: _telephoneFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_genderFocusNode);
                    }, // r'^[0-9]$'
                    validator: (value) {
                      final RegExp regExp = RegExp(
                        r'^[0-9]*$',
                        caseSensitive: false,
                        multiLine: false,
                      );
                      if (value.isEmpty) {
                        return 'Enter your Telephone number without leading 0';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Telephone number contains only numbers';
                      } else if (value.startsWith('0')) {
                        return 'Remove leading 0';
                      } else if (value.length <= 5) {
                        return 'Telephone number too short';
                      } else if (value.length >= 15) {
                        return 'Telephone number too long';
                      }

                      // else if (!(value.length == 10)) {
                      //   return value.length < 10
                      //       ? 'Telephone number too short'
                      //       : 'Telephone number too long';
                      // }

                      return null;
                    },
                    onSaved: (value) {
                      _authData['telephone'] = '0${value.trim()}';
                    },
                  ),
                if (this.widget.authMode == AuthMode.JoinUs) _spacer,
                if (this.widget.authMode == AuthMode.JoinUs)
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
                        key: this._moreKey,
                        child: const Icon(
                          Icons.arrow_drop_down,
                        ),
                        onTap: () async {
                          final position =
                              buttonMenuPosition(this._moreKey.currentContext);
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
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
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
                      _authData['gender'] = value.trim();
                    },
                  ),
                _spacer,
                TextFormField(
                  // Password Field
                  obscureText: !_passwordIsVisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_passwordIsVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: _togglePasswordVisibility,
                      ),
                      labelText: 'Password',
                      labelStyle: _style['formlabel']),
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (_) {
                    if (this.widget.authMode == AuthMode.Authenticate) {
                      _submit();
                    } else {
                      FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocusNode);
                    }
                  },
                  validator: (value) {
                    if (this.widget.authMode == AuthMode.Authenticate)
                      return null;
                    final RegExp regExp =
                        RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})");
                    if (value.isEmpty) {
                      return 'Password is required';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Use 1 of each [a-z, A-Z, 0-9] combine 8 or more';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                _spacer,
                if (this.widget.authMode == AuthMode.JoinUs)
                  TextFormField(
                    // ConfirmPassword Field
                    // toolbarOptions: ToolbarOptions(copy: true,),
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: _style['formlabel']),

                    focusNode: _confirmPasswordFocusNode,
                    onFieldSubmitted: (_) {
                      if (_agreedToTerms &&
                          _passwordController.text.isNotEmpty &&
                          _genderController.text.isNotEmpty) {
                        _submit();
                      }
                    },
                    validator: (value) {
                      if (_passwordController.text != value) {
                        return 'Passwords do not match';
                      } else {
                        return null;
                      }
                    },
                  ),
                _spacer,
                _spacer,
                if (this.widget.authMode == AuthMode.JoinUs)
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: custm.CustomCheckbox(
                          value: _agreedToTerms,
                          useTapTarget: false,
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                color: Theme.of(context).accentColor,
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
                  child: Center(
                    child: _isLoading
                        ? CentrallyUsed().waitingCircle()
                        : OutlineButton.icon(
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
                            label: const Text('Submit'),
                            icon: const Icon(
                              Icons.check,
                              color: const Color(0xff2A6041),
                            ),
                            onPressed:
                                this.widget.authMode == AuthMode.JoinUs &&
                                        !_agreedToTerms
                                    ? null
                                    : () {
                                        // print(_user);
                                        // () async {print((await Auth().currentUser()).uid);}();
                                        _submit();
                                        // print(this.widget.authMode.index);
                                        // print('${_selectedCountry.name}');

                                        // Persist Auth ?
                                        // print(_rememberMe);
                                        // SSSprint(ur.rememberMe);
                                      }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showAuthForm();
  }
}
