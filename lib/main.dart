// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal
import './helpers/auth.dart';
import './providers/firebase_helper.dart';
import './providers/sound_tin.dart';
import './providers/user.dart';
import './screens/account_select_screen.dart';
import './screens/authenticate_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/metadata_screen.dart';
import './screens/welcome_screen.dart';
import './screens/contribute/donate_voice_screen.dart';
import './screens/contribute/validate_screen.dart';
import './screens/legal/about_us_screen.dart';
import './screens/legal/terms_and_conditions_screen.dart';
import './screens/legal/privacy_policy_screen.dart';
import './widgets/centrally_used.dart';

// Sound _
import './helpers/listening_devil.dart';
import './helpers/sound_devil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  bool counterfeit = true;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: User()..setInstance(Auth().currentUser())
            // ..setPref(SharedPreferences.getInstance())
            ),
        ChangeNotifierProvider.value(value: FireBaseHelper()),
        ChangeNotifierProvider.value(value: SoundTin()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF4FA978),
          accentColor: Colors.deepOrange[600],
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              title: const TextStyle(
                  fontFamily: 'AdventPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 21.0),
            ),
          ),
        ),
        home: Scaffold(
          // body: ListeningDevil(dashWidth: double.infinity),
          // body: SoundDevil(),
          // body: WelcomeScreen(),
          // body: MetadataScreen(),
          // body: AccountSelectScreen(),

          body: Consumer<User>(
            builder: (ctx, user, _) {
              return StreamBuilder<FirebaseUser>(
                stream: Auth().onAuthStateChanged,
                builder: (ctx, snp) {
                  if (snp.connectionState == ConnectionState.waiting) {
                    return CentrallyUsed().waitingCircle();
                  }
                  // if (!snp.hasData) {
                  //   return AccountSelectScreen();
                  // }
                  // print('data: ${snp.data}');

                  return StreamBuilder(
                      stream:
                          Firestore.instance.collection('critical').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * .40),
                              margin: EdgeInsets.all(20.0),
                              child: Column(children: <Widget>[
                                CentrallyUsed().waitingCircle(),
                                Text(
                                  'Please wait a moment. If this message persists check your internet connection.',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Abel',
                                    // color: Colors.red,
                                  ),
                                ),
                              ]),
                            ),
                          );
                        }

                        return FutureBuilder(
                          future: user.getFirstTime,
                          builder: (ctxFirstTime, snpFirstTime) {
                            if (snpFirstTime.connectionState ==
                                ConnectionState.waiting) {
                              return CentrallyUsed().waitingCircle();
                            }
                            return FutureBuilder(
                              future: user.getLandingPage(snp.hasData),
                              builder: (ctx, userSnapshot) {
                                // print(snp.hasData);
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CentrallyUsed().waitingCircle();
                                } else if (userSnapshot.data == null) {
                                  return (snp.hasData)
                                      ? DashboardScreen()
                                      : snpFirstTime.data
                                          ? WelcomeScreen()
                                          : AccountSelectScreen();
                                }
                                return userSnapshot.data;
                              },
                            );
                          },
                        );
                      });
                },
              );
            },
          ),
        ),
        routes: {
          // AuthenticateScreen.routeName: (ctx) => AuthenticateScreen(),
          AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
          AccountSelectScreen.routeName: (ctx) => AccountSelectScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          DonateVoiceScreen.routeName: (ctx) => DonateVoiceScreen(),
          MetadataScreen.routeName: (ctx) => MetadataScreen(),
          PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
          TermsAndConditionsScreen.routeName: (ctx) =>
              TermsAndConditionsScreen(),
          ValidateScreen.routeName: (ctx) => ValidateScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
        },
      ),
    );
  }
}
