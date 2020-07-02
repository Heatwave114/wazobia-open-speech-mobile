// External
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Internal
import '../providers/firebase_helper.dart';
import '../providers/user.dart';
import '../widgets/centrally_used.dart';

class SieveLift extends StatelessWidget {
  final Widget child;

  const SieveLift({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final User user = User()..setContext(context);
    return StreamBuilder(
      stream: Provider.of<FireBaseHelper>(context).critical.snapshots(),
      builder: (ctxCritical, snpCritical) {
        if (!snpCritical.hasData)
          return Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .35),
              child: CentrallyUsed().waitingCircle());
        return FutureBuilder(
          future: user.notLandingSieve(),
          builder: (ctxNotLanding, snpNotLanding) {
            return snpNotLanding.data ?? Scaffold(body: this.child,);
          },
        );
      },
    );
  }
}
