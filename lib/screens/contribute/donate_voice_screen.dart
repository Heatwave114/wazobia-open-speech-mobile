// Core
import 'dart:io';
import 'dart:math';

// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:timer_builder/timer_builder.dart';
import 'package:provider/provider.dart';

// Internal
import '../../helpers/sound_devil.dart';
import '../../models/resource.dart';
import '../../models/user.dart' as userM;
import '../../providers/firebase_helper.dart';
import '../../providers/sound_tin.dart';
import '../../providers/user.dart';
import '../../widgets/blinking_widget.dart';
import '../../widgets/centrally_used.dart';
import '../../widgets/dash_widgets.dart';

class DonateVoiceScreen extends StatelessWidget {
  static const routeName = '/voice';

  Random _random = Random();
  // bool shouldRefresh;
  // int _currentResourceIndex;

  // @override
  // void initState() {
  //   // _setDonatingResource();
  //   super.initState();
  // }

  // void _setDonatingResource(QuerySnapshot resources) {
  //   // final QuerySnapshot resourcesQuery =
  //   //     await Provider.of<FireBaseHelper>(context).resources.getDocuments();
  //   final int randomDocumentIndex = _random.nextInt(resources.documents.length);
  //   final DocumentSnapshot initialDonatingResourceDocument =
  //       resources.documents[randomDocumentIndex];
  //   final Resource initialDonatingResource =
  //       Resource.fromFireStore(initialDonatingResourceDocument);
  //   final SoundTin soundTin = Provider.of<SoundTin>(context);
  //   soundTin.setCurrentDonatingResource = initialDonatingResource;
  //   final Resource resource = soundTin.getCurrentDonatingResource;
  //   print(resource);
  //   return resource;
  // }

  // void currentResourceIndexGiver(int resourcesLenght) {
  //   final int index = Random().nextInt(resourcesLenght);
  //   this._currentResourceIndex = index;
  // }

  @override
  Widget build(BuildContext context) {
    // _scrollController
    final double _dashWidth = MediaQuery.of(context).size.width * .93;
    // final resourcesStream = Provider.of<FireBaseHelper>(context).resources.snapshots();
    final SoundTin soundTin = Provider.of<SoundTin>(context);
    // final SoundDevil soundDevil = SoundDevil();
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Your Voice'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: StreamBuilder(
            stream: Provider.of<FireBaseHelper>(context).resources.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .35),
                    child: CentrallyUsed().waitingCircle());
              final int resourceIndex = (soundTin
                              .getShouldRefreshDonatingResourceIndex ==
                          null ||
                      soundTin.getShouldRefreshDonatingResourceIndex)
                  ? () {
                      soundTin.setCurrentDonatingResourceIndex =
                          this._random.nextInt(snapshot.data.documents.length);
                      soundTin.setShouldRefreshDonatingResourceIndex = false;
                      // print(1);
                      return soundTin.getCurrentDonatingResourceIndex;
                    }()
                  : () {
                      // print(2);
                      return soundTin.getCurrentDonatingResourceIndex;
                    }();
              final Resource resource = Resource.fromFireStore(
                  snapshot.data.documents[resourceIndex]);
              soundTin.setCurrentDonatingResource = resource;
              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5.0,
                  ),
                  DashWidgets.dashboard([
                    DashWidgets.dashItem('Title', resource.title),
                    DashWidgets.dashItem('Genre', resource.genre),
                    if (!soundTin.inDanger)
                      DashWidgets.dashItem(
                          'Read time', resource.formatedReadTime),
                    if (soundTin.inDanger)
                      dangerDashItem('Read time', resource.formatedReadTime)
                  ], _dashWidth),
                  // MediaPanel(dashWidth: _dashWidth),
                  SoundDevil(),
                  // FlatButton(
                  //   onPressed: () async {
                  //     print((await soundTin.getDonatedVoiceDuration()));
                  //   },
                  //   child: null,
                  //   color: Colors.grey,
                  // ),
                  TextPanel(
                    dashWidth: _dashWidth,
                    resource: resource,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget dangerDashItem(String label, String value) {
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
                color: Colors.red[900]),
          ),
        ],
      ),
    );
  }
}

// class MediaPanel extends StatefulWidget {
//   final double dashWidth;

//   const MediaPanel({
//     Key key,
//     @required this.dashWidth,
//   }) : super(key: key);

//   @override
//   _MediaPanelState createState() => _MediaPanelState();
// }

// class _MediaPanelState extends State<MediaPanel> {
//   // Displays counter text xx:xx:xx
//   Widget _timeText(String timeText) {
//     return Text(timeText, style: TextStyle(fontSize: 35.0, fontFamily: 'Abel'));
//   }

//   // When recording started
//   DateTime _startedRecordingNow;
//   bool _readyToPlay = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // Record/Play Panel
//       width: double.infinity,
//       margin: const EdgeInsets.only(
//         bottom: 5.0,
//         left: 10.0,
//         right: 10.0,
//       ),
//       child: Card(
//         elevation: 2.0,
//         child: Container(
//           width: widget.dashWidth,
//           child: Container(
//             // height: MediaQuery.of(context).size.height * .45,
//             width: double.infinity,
//             padding: const EdgeInsets.all(10.0),

//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Expanded(
//                     child: Center(
//                   // child: Text('00:00:00',
//                   //     style: TextStyle(fontSize: 35.0, fontFamily: 'Abel')),
//                   child: _startedRecordingNow == null
//                       ? _timeText('00:00:00')
//                       : TimerBuilder.periodic(Duration(milliseconds: 100),
//                           builder: (context) {
//                           return _timeText(
//                               '${DateTime.now().difference(_startedRecordingNow).toString().split('.').first.padLeft(8, "0")}');
//                         }),
//                 )),
//                 () {
//                   return _startedRecordingNow == null
//                       ? OutlineButton(
//                           borderSide:
//                               BorderSide(color: Colors.green, width: 0.5),
//                           // padding: EdgeInsets.all(0.0),
//                           onPressed: () {
//                             setState(() {
//                               _startedRecordingNow = DateTime.now();
//                               _readyToPlay = !_readyToPlay;
//                             });
//                           },
//                           child: Icon(Icons.mic,
//                               color: Colors.deepOrange, size: 25.0),
//                           shape: CircleBorder(),
//                         )
//                       : OutlineButton(
//                           borderSide:
//                               BorderSide(color: Colors.green, width: 0.5),
//                           // padding: EdgeInsets.all(0.0),
//                           onPressed: () {
//                             setState(() {
//                               _startedRecordingNow = null;
//                             });
//                           },
//                           child:
//                               Icon(Icons.stop, color: Colors.red, size: 25.0),
//                           shape: CircleBorder(),
//                         );
//                 }(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class TextPanel extends StatefulWidget {
  final double dashWidth;
  final Resource resource;
  const TextPanel({
    Key key,
    @required this.dashWidth,
    @required this.resource,
  }) : super(key: key);

  @override
  _TextPanelState createState() => _TextPanelState();
}

class _TextPanelState extends State<TextPanel> {
  double _textSizePercent = .7;
  int _submitTapCounter = 0;

  // stopLoadingForDonation
  void stopLoadingForDonation() {
    setState(() {
      this._submitTapCounter = 0;
    });
  }

  // Whether to proceed with voice submission
  Future<void> confirmProceedWithDonation(String title, String content,
      {Function submitDonation}) async {
    bool proceedWithDonation;
    // print('before:' + proceedWithDonation.toString());
    // final bool evaluate = await showDialog(
      final user = Provider.of<User>(context, listen: false);
      user.setContext(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () => Future(() => false),
        child: AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Abel',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
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
              child: const Text(
                'Return',
                style: const TextStyle(
                  fontFamily: 'PTSans',
                  fontSize: 17.0,
                  // fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
               this.stopLoadingForDonation();
                proceedWithDonation = false;
                // this.stopLoadingForValidation();
                Navigator.of(context).pop();
                // return;
              },
            ),
            RaisedButton(
              color: Colors.lightGreen,
              child: const Text(
                'Donate',
                style: const TextStyle(
                  fontFamily: 'PTSans',
                  fontSize: 17.0,
                  // fontWeight: FontWeight.bold
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                final bool internet = await user.connectionStatus();
                if(!internet) {
                  user.showSnackBar('Check your internet');
                Navigator.of(context).pop();
                this.stopLoadingForDonation();
                return;
                }
                proceedWithDonation = true;
                Navigator.of(context).pop();
                // this.stopLoadingForValidation();
              },
            ),
          ],
        ),
      ),
    ).then((_) {
      // so that no duplicate
      if (proceedWithDonation && this._submitTapCounter != 0) {
        submitDonation();
      }
    });
    // print('after:' + proceedWithDonation.toString());
    // Navigator.of(context).pop();
    // return proceed;
  }

  @override
  Widget build(BuildContext context) {
    final SoundTin soundTin = Provider.of<SoundTin>(context);
    final user = Provider.of<User>(context);
    user.setContext(context);
    return Column(children: <Widget>[
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          // vertical: 5.0,
          horizontal: 10.0,
        ),
        child: Card(
          elevation: 2.0,
          child: Container(
            width: this.widget.dashWidth,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              // padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0, right: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 7.0),
                    height: 50.0,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: FittedBox(
                            child: Row(
                              children: <Widget>[
                                const Text(
                                  'Font Size',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Slider.adaptive(
                                  value: _textSizePercent,
                                  // divisions: 5,
                                  min: .5, activeColor: Colors.deepOrange,
                                  onChanged: (_textSizePercent) {
                                    setState(() => this._textSizePercent =
                                        _textSizePercent);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            child: (this._submitTapCounter > 0)
                                ? CircularProgressIndicator(
                                    backgroundColor: Color(0xff2A6041),
                                    strokeWidth: 2.0,
                                    // value: .5,
                                  )
                                : OutlineButton.icon(
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor, //Color of the border
                                      style: BorderStyle
                                          .solid, //Style of the border
                                      width: 1.0, //width of the border
                                    ),
                                    label: const Text(
                                      'Donate',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    icon: const Icon(
                                      Icons.check,
                                      color: const Color(0xff2A6041),
                                    ),
                                    onPressed: soundTin.getIsRecording
                                        ? null
                                        :
                                        // null
                                        () async {
                                            // if (this._submitTapCounter > 0) {
                                            //   print('waitForUpload');
                                            // }
                                            if (soundTin.getDonatedVoicePath ==
                                                null) {
                                              user.showSnackBar(
                                                'Make a recording first',
                                              );
                                              // print('No path yet');
                                              return;
                                            }

                                            if (!(await user
                                                .connectionStatus())) {
                                              user.showSnackBar(
                                                  'Check your internet');
                                              return;
                                            }
                                            // this._submitTapCounter++;
                                            setState(() {
                                              this._submitTapCounter++;
                                            });

                                            // No need for this
                                            // if ((await soundTin
                                            //         .getDonatedVoiceDuration()) >
                                            //     widget.resource.readTime.inSeconds) {
                                            //   user.showDialogue('Alert',
                                            //       'Alloted read time has been exceed.');
                                            //   // print('1: ${await soundTin.getDonatedVoiceDuration()}');
                                            //   return;
                                            // }

                                            if ((await soundTin
                                                    .getDonatedVoiceDuration()) <
                                                (.75 *
                                                    widget.resource.readTime
                                                        .inSeconds)) {
                                              user.showDialogue('Alert',
                                                  'Recording too short');
                                              // print('2: ${await soundTin.getDonatedVoiceDuration()}');
                                              setState(() {
                                                this._submitTapCounter = 0;
                                              });
                                              return;
                                            }

                                            // print(soundTin.getDonatedVoicePath);
                                            // print((await soundTin.getDonatedVoiceDuration())/3600);3

                                            this.confirmProceedWithDonation(
                                                'Alert',
                                                'Are you sure want to submit your donation?',
                                                submitDonation: () async {
                                              user.setContext(context);
                                              user
                                                  .uploadDonation(
                                                voiceToUpload: File(soundTin
                                                    .getDonatedVoicePath),
                                                resourceID:
                                                    this.widget.resource.uid,
                                                duration: await soundTin
                                                    .getDonatedVoiceDuration(),
                                              )
                                                  .then((_) {
                                                // Can now bring a new resource for donation
                                                soundTin.setShouldRefreshDonatingResourceIndex =
                                                    true;
                                                soundTin.setDonatedVoicePath =
                                                    null;
                                                this.stopLoadingForDonation();
                                                user.showDialogue('Thank you',
                                                    'We sincerely appreciate your donation. You can always make another',
                                                    whenFinished: () {
                                                      soundTin.setInDanger = false;
                                                  soundTin.setShouldInitDevil =
                                                      true;
                                                });
                                              });
                                            });

                                            // print(_user);
                                            // () async {print((await Auth().currentUser()).uid);}();
                                            // _submit();
                                            // print('${_selectedCountry.name}');

                                            // Persist Auth ?
                                            // print(_rememberMe);
                                            // SSSprint(ur.rememberMe);
                                          },
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .45,
                    padding: const EdgeInsets.all(10.0),
                    // padding: const EdgeInsets.only(left: 15.0, bottom: 15.0, top: 15.0, right: 0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(5.0),
                      // color: Colors.grey,
                    ),
                    child: Scrollbar(
                      // controller: _scrollController,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Text(
                          // 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making i t over 2000 years old. Richard McClintock, a latin professor at Hampden Sydney College Virginia, looked up one of the more obscure Lation words,consectetur, from a Lorem Ipsum passage, and going through the cities of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.\n\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
                          this.widget.resource.text,
                          style: TextStyle(
                            fontSize: 30.0 * _textSizePercent,
                            fontFamily: 'Abel',
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
