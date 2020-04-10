// External
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Internal
import './providers/user.dart';
import './screens/authenticate_screen.dart';
import './screens/dashboard_screen.dart';
import './widgets/centrally_used.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: User()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Color(0xFF4FA978),
        ),
        home: Scaffold(
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
          AuthenticateScreen.routeName: (ctx) => AuthenticateScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
        },
      ),
    );
  }
}
