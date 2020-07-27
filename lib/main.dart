// External
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
import './widgets/centrally_used.dart';

// Sound _
import './helpers/listening_devil.dart';
import './helpers/sound_devil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
              return FutureBuilder(
                future: user.getLandingPage(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CentrallyUsed().waitingCircle();
                  } else if (userSnapshot.connectionState ==
                      ConnectionState.done) {
                    return userSnapshot.data;
                  }
                  return null;
                },
              );
            },
          ),

        ),
        routes: {
          // AuthenticateScreen.routeName: (ctx) => AuthenticateScreen(),
          AccountSelectScreen.routeName: (ctx) => AccountSelectScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          DonateVoiceScreen.routeName: (ctx) => DonateVoiceScreen(),
          MetadataScreen.routeName: (ctx) => MetadataScreen(),
          ValidateScreen.routeName: (ctx) => ValidateScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
        },
      ),
    );
  }
}
