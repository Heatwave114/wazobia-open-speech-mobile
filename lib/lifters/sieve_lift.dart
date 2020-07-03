// External
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Internal
import '../providers/firebase_helper.dart';
import '../providers/user.dart';
import '../widgets/centrally_used.dart';

class SieveLift extends StatefulWidget {
  final Widget child;

  const SieveLift({
    @required this.child,
  });

  @override
  _SieveLiftState createState() => _SieveLiftState();
}

class _SieveLiftState extends State<SieveLift> {
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
            return snpNotLanding.data ??
                Scaffold(
                  body: this.widget.child,
                );
          },
        );
      },
    );
  }
}
