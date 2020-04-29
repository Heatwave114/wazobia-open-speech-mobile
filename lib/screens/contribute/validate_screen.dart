// Core
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
import '../../providers/firebase_helper.dart';
import '../../providers/sound_tin.dart';
import '../../widgets/centrally_used.dart';
import '../../widgets/dash_widgets.dart';

class ValidateScreen extends StatelessWidget {
  static const routeName = '/validate';

  Random _random = Random();
  // final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // _scrollController
    final double _dashWidth = MediaQuery.of(context).size.width * .93;
    final SoundTin soundTin = Provider.of<SoundTin>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Validate'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: StreamBuilder(
            stream: Provider.of<FireBaseHelper>(context)
                .unvalidatedURLs
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CentrallyUsed().waitingCircle();
              final int unvalidatedVoiceIndex = (soundTin
                              .getShouldRefreshValidatingResourceIndex ==
                          null ||
                      soundTin.getShouldRefreshValidatingResourceIndex)
                  ? () {
                      soundTin.setCurrentValidatingResourceIndex =
                          this._random.nextInt(snapshot.data.documents.length);
                      soundTin.setShouldRefreshValidatingResourceIndex = false;
                      // print(1);
                      return soundTin.getCurrentValidatingResourceIndex;
                    }()
                  : () {
                      // print(2);
                      return soundTin.getCurrentValidatingResourceIndex;
                    }();
              final DocumentSnapshot unvalidatedVoiceAsDocument =
                  snapshot.data.documents[unvalidatedVoiceIndex];
              final String resourceID = unvalidatedVoiceAsDocument['resource'];

              soundTin.setValidatingVoiceURL = unvalidatedVoiceAsDocument['url'];

              return FutureBuilder(
                  future: Provider.of<FireBaseHelper>(context)
                      .resources
                      .document(resourceID)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CentrallyUsed().waitingCircle();
                    }
                    final Resource resource =
                        Resource.fromFireStore(snapshot.data);
                    soundTin.setCurrentValidatingResource = resource;
                    return Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10.0,
                        ),
                        DashWidgets.dashboard([
                          DashWidgets.dashItem('Title', resource.title),
                          DashWidgets.dashItem('Genre', resource.genre),
                          DashWidgets.dashItem('Read time', resource.readTime),
                        ], _dashWidth),
                        // MediaPanel(dashWidth: _dashWidth),
                        SoundDevil()..validating(),
                        TextPanel(dashWidth: _dashWidth, resource: resource),
                      ],
                    );
                  });
            }),
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
//                           child: Icon(Icons.play_arrow,
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

  @override
  Widget build(BuildContext context) {
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
                            child: OutlineButton.icon(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor, //Color of the border
                                style: BorderStyle.solid, //Style of the border
                                width: 1.0, //width of the border
                              ),
                              label: const Text(
                                'Validate',
                                overflow: TextOverflow.ellipsis,
                              ),
                              icon: const Icon(
                                Icons.check,
                                color: const Color(0xff2A6041),
                              ),
                              onPressed:
                                  // null
                                  () {
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
                    height: MediaQuery.of(context).size.height * .50,
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
