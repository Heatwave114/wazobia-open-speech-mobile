// Core
import 'dart:math';
import 'dart:convert';

// External
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:timer_builder/timer_builder.dart';
import 'package:provider/provider.dart';

// Internal
import '../../helpers/sound_devil.dart';
import '../../models/donation.dart';
import '../../models/resource.dart';
import '../../providers/firebase_helper.dart';
import '../../providers/sound_tin.dart';
import '../../providers/user.dart';
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
    final FireBaseHelper fbHelper = Provider.of<FireBaseHelper>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Validate'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: StreamBuilder(
            stream: fbHelper.unvalidatedURLs.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .35),
                    child: CentrallyUsed().waitingCircle());
              if (snapshot.data.documents.length == 0 ||
                  snapshot.data.documents.length == null)
                return Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .35),
                  child: Center(
                    child: Text(
                      'No donations to validate. Please make a donation and invite to wazobia.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Abel',
                        // color: Colors.red,
                      ),
                    ),
                  ),
                );
              final int unvalidatedVoiceIndex = (soundTin
                              .getShouldRefreshValidatingDonationIndex ==
                          null ||
                      soundTin.getShouldRefreshValidatingDonationIndex)
                  ? () {
                      soundTin.setCurrentValidatingDonationIndex =
                          this._random.nextInt(snapshot.data.documents.length);
                      soundTin.setShouldRefreshValidatingDonationIndex = false;
                      // print(1);
                      return soundTin.getCurrentValidatingDonationIndex;
                    }()
                  : () {
                      // print(2);
                      return soundTin.getCurrentValidatingDonationIndex;
                    }();
              final DocumentSnapshot unvalidatedDonationAsDocument =
                  snapshot.data.documents[unvalidatedVoiceIndex];
              final String resourceID =
                  unvalidatedDonationAsDocument['resourceid'];
              // print(unvalidatedVoiceIndex);
              // print(unvalidatedDonationAsDocument);
              // print(resourceID);

              // print(unvalidatedVoiceIndex);

              // Tell sound devil to play this
              soundTin.setValidatingVoiceURL =
                  unvalidatedDonationAsDocument['url'];

              final Donation donation =
                  Donation.fromFireStore(unvalidatedDonationAsDocument);
              soundTin.setCurrentValidatingDonation = donation;
              // print(donation.reader);

              return StreamBuilder(
                  stream: fbHelper.resources.document(resourceID).snapshots(),
                  builder: (context, snapshot) {
                    // print(resourceID);
                    // print('zzzzzzzzzzzzzzzzzzzzzz');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .35),
                          child: CentrallyUsed().waitingCircle());
                    }
                    final Resource resource =
                        Resource.fromFireStore(snapshot.data);
                    // print('cccccccccccccccccc');
                    soundTin.setCurrentValidatingResource = resource;
                    return Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 5.0,
                        ),
                        DashWidgets.dashboard([
                          DashWidgets.dashItem('Title', resource.title),
                          DashWidgets.dashItem('Genre', resource.genre),
                          DashWidgets.dashItem(
                              'Duration', donation.formatedDurationTime),
                        ], _dashWidth),
                        // MediaPanel(dashWidth: _dashWidth),
                        SoundDevil()..validating(),
                        // FlatButton(
                        //   onPressed: () {
                        //     print(snapshot.data.documents.length);
                        //   },
                        //   child: null,
                        //   color: Colors.grey,
                        // ),
                        TextPanel(
                            dashWidth: _dashWidth,
                            resource: resource,
                            donation: donation),
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
  final Donation donation;
  const TextPanel({
    Key key,
    @required this.dashWidth,
    @required this.resource,
    @required this.donation,
  }) : super(key: key);

  @override
  _TextPanelState createState() => _TextPanelState();
}

class _TextPanelState extends State<TextPanel> {
  double _textSizePercent = .7;
  int _validateTapCounter = 0;
  int _invalidateTapCounter = 0;
  // bool proceedWithEvaluation;

  void stopLoadingForValidation() {
    if (this.mounted)
      setState(() {
        this._validateTapCounter = 0;
        this._invalidateTapCounter = 0;
      });
  }

  final TextEditingController _validationTextController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _validationTextController.dispose();
  }

  // int _validationTextReasonLength = 30;

  // Whether to proceed with validate or invalidate
  Future<void> confirmProceedWithDonation(
      {@required bool isValid, @required Function submitEvaluation}) async {
    // print('before:' + proceedWithEvaluation.toString());
    // final bool evaluate = await showDialog(
    final soundTin = Provider.of<SoundTin>(context, listen: false);
    final String validInvalidLowerPreText = isValid ? 'v' : 'i';
    final String validInvalidUpperPreText = isValid ? 'V' : 'I';
    final String validInvalidText = isValid ? 'alid' : 'nvalid';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () => Future(() => false),
        child: SubmitValidationAlertDialog(
          validateTapCounter: _validateTapCounter,
          invalidateTapCounter: _invalidateTapCounter,
          validInvalidUpperPreText: validInvalidUpperPreText,
          validInvalidText: validInvalidText,
          validInvalidLowerPreText: validInvalidLowerPreText,
        ),
      ),
    ).then((_) {
      print('ggg');
      if (soundTin.getProceedWithDonationEvaluation) {
        print('fff');
        submitEvaluation();
        soundTin.setProceedWithDonationEvaluation = false;
        soundTin.setShouldAllowValidation = false;
      }
      this.stopLoadingForValidation();
    });
    // print('after:' + proceedWithEvaluation.toString());
    // Navigator.of(context).pop();
    // return proceed;
  }

  @override
  Widget build(BuildContext context) {
    final SoundTin soundTin = Provider.of<SoundTin>(context);
    final fbHelper = Provider.of<FireBaseHelper>(context, listen: false);
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
                          flex: 5,
                          child: FittedBox(
                            child: Row(
                              children: <Widget>[
                                const Text(
                                  'Font Size',
                                  style: const TextStyle(
                                    fontSize: 30.0,
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
                            child: (this._invalidateTapCounter > 0)
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.red,
                                    strokeWidth: 2.0,
                                    // value: .5,
                                  )
                                : OutlineButton.icon(
                                    borderSide: BorderSide(
                                      color:
                                          Colors.red[900], //Color of the border
                                      style: BorderStyle
                                          .solid, //Style of the border
                                      width: 1.0, //width of the border
                                    ),
                                    label: const Text(
                                      'Invalidate',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    icon: const Icon(
                                      Icons.clear,
                                      // color: const Color(0xff2A6041),
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        // soundTin.getIsPlaying
                                        //     ? null
                                        //     : // null
                                        () async {
                                      if (!(await user.connectionStatus())) {
                                        user.showSnackBar(
                                            'Check your internet');
                                        return;
                                      }
                                      // if(soundTin.)
                                      // print(soundTin
                                      //     .currentValidatingResource.title);
                                      // soundTin.setShouldAllowValidate = false;

                                      if (!soundTin.getShouldAllowValidation) {
                                        user.showDialogue('Alert',
                                            'Ensure the whole audio corresponds to the this text resource. Listen more.',
                                            isRed: true);
                                        return;
                                      }

                                      setState(() {
                                        this._invalidateTapCounter++;
                                      });

                                      // Remain in unvalidated if validCount > -2 with the following valid count
                                      widget.donation.validCount++;
                                      widget.donation.bias--;

                                      this.confirmProceedWithDonation(
                                          isValid: false,
                                          submitEvaluation: () async {
                                            // print(
                                            //     widget.donation.invalidReasons);
                                            if (widget
                                                    .donation.invalidReasons ==
                                                null) {
                                              widget.donation
                                                  .setInvalidReasons = [];
                                              widget.donation.addInvalidReason({
                                                '${DateTime.now().millisecondsSinceEpoch}':
                                                    '${soundTin.getReasonForInvalidation}'
                                              });
                                            }
                                            // print(
                                            //     widget.donation.invalidReasons);
                                            // print(widget.donation.invalidReasons
                                            //     .length);

                                            if (widget.donation.bias > -2) {
                                              fbHelper.unvalidatedURLs
                                                  .document(
                                                      widget.donation.name)
                                                  .updateData({
                                                'bias': widget.donation.bias,
                                                if (soundTin
                                                        .getReasonForInvalidation
                                                        .trim() !=
                                                    '')
                                                  'invalidreasons': (widget
                                                              .donation
                                                              .invalidReasons
                                                              .length >
                                                          0)
                                                      ? FieldValue.arrayUnion([
                                                          {
                                                            '${DateTime.now().millisecondsSinceEpoch}':
                                                                '${soundTin.getReasonForInvalidation}'
                                                          }
                                                        ])
                                                      : FieldValue.arrayUnion(
                                                          widget.donation
                                                              .invalidReasons),
                                                'validcount':
                                                    widget.donation.validCount,
                                              }).then((_) {
                                                // Can now bring a new donation for validation
                                                soundTin.setShouldRefreshValidatingDonationIndex =
                                                    true;
                                                this.stopLoadingForValidation();

                                                // this._invalidateTapCounter = 0;

                                                // Appreciation
                                                user.showDialogue('Thank you',
                                                    'We sincerely appreciate your validation. You can always do another');
                                              });
                                            } else {
                                              // Change validation status in FBStorage
                                              user
                                                  .changeValidationStatus(
                                                donationName:
                                                    widget.donation.name,
                                                validationStatus: 'invalid',
                                              )
                                                  .then((_) async {
                                                // Move to invalid
                                                fbHelper.invalidURLs
                                                    .document(
                                                        widget.donation.name)
                                                    .setData({
                                                  'reader':
                                                      widget.donation.reader,
                                                  'donationdateniglocal': widget
                                                      .donation
                                                      .donationDateNIGLocal
                                                      .toIso8601String(),
                                                  'duration':
                                                      widget.donation.duration,
                                                  'cqi': widget.donation.cqi,
                                                  'snr': widget.donation.snr,
                                                  'invalidreasons': widget
                                                      .donation.invalidReasons,
                                                  'validcount': widget
                                                      .donation.validCount,
                                                  'resourceid': widget
                                                      .donation.resourceId,
                                                  'url': widget.donation.url,
                                                  'timeofvalidation':
                                                      DateTime.now()
                                                          .toIso8601String(),
                                                }).then((_) async {
                                                  // Delete from unvalidated
                                                  await fbHelper.unvalidatedURLs
                                                      .document(
                                                          widget.donation.name)
                                                      .delete()
                                                      .then((_) {
                                                    // setState(() {});

                                                    // Can now bring a new donation for validation
                                                    soundTin.setShouldRefreshValidatingDonationIndex =
                                                        true;
                                                  });
                                                  this.stopLoadingForValidation();

                                                  // this._invalidateTapCounter =
                                                  //     0; // redundant because of this.stopLoadingForValidation ??
                                                  // Appreciation
                                                  user.showDialogue('Thank you',
                                                      'We sincerely appreciate your validation. You can always do another');
                                                });
                                              });

                                              // fbHelper.validatedURLs
                                              //     .document(widget.donation.name)
                                              //     .setData({

                                              //     });
                                            }
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
                        ),
                        VerticalDivider(
                          thickness: 0.1,
                        ),
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            child: (this._validateTapCounter > 0)
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
                                      'Validate',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    icon: const Icon(
                                      Icons.check,
                                      color: const Color(0xff2A6041),
                                    ),
                                    onPressed:
                                        // soundTin.getIsPlaying
                                        //     ? null
                                        //     : // null
                                        () async {
                                      if (!(await user.connectionStatus())) {
                                        user.showSnackBar(
                                            'Check your internet');
                                        return;
                                      }
                                      // if(soundTin.)
                                      // print(soundTin
                                      //     .currentValidatingResource.title);
                                      // soundTin.setShouldAllowValidate = false;

                                      if (!soundTin.getShouldAllowValidation) {
                                        user.showDialogue('Alert',
                                            'Ensure the whole audio corresponds to the this text resource. Listen more.');
                                        return;
                                      }

                                      setState(
                                          () => this._validateTapCounter++);

                                      // Remain in unvalidated with the following validcount
                                      widget.donation.validCount++;
                                      widget.donation.bias++;

                                      this.confirmProceedWithDonation(
                                          isValid: true,
                                          submitEvaluation: () {
                                            if (widget.donation.bias < 2) {
                                              fbHelper.unvalidatedURLs
                                                  .document(
                                                      widget.donation.name)
                                                  .updateData({
                                                'bias': widget.donation.bias,
                                                'validcount':
                                                    widget.donation.validCount,
                                              }).then((_) {
                                                // Can now bring a new donation for validation
                                                soundTin.setShouldRefreshValidatingDonationIndex =
                                                    true;
                                                this.stopLoadingForValidation();
                                                // this._validateTapCounter = 0;
                                                // Appreciation
                                                user.showDialogue('Thank you',
                                                    'We sincerely appreciate your validation. You can always do another');
                                              });
                                            } else {
                                              // Change validation status in FBStorage
                                              user
                                                  .changeValidationStatus(
                                                donationName:
                                                    widget.donation.name,
                                                validationStatus: 'validated',
                                              )
                                                  .then((_) async {
                                                // Move to validated
                                                fbHelper.validatedURLs
                                                    .document(
                                                        widget.donation.name)
                                                    .setData({
                                                  'reader':
                                                      widget.donation.reader,
                                                  'donationdateniglocal': widget
                                                      .donation
                                                      .donationDateNIGLocal
                                                      .toIso8601String(),
                                                  'duration':
                                                      widget.donation.duration,
                                                  'cqi': widget.donation.cqi,
                                                  'snr': widget.donation.snr,
                                                  'invalidreasons': widget
                                                      .donation.invalidReasons,
                                                  'validcount': widget
                                                      .donation.validCount,
                                                  'resourceid': widget
                                                      .donation.resourceId,
                                                  'url': widget.donation.url,
                                                  'timeofvalidation':
                                                      DateTime.now()
                                                          .toIso8601String(),
                                                }).then((_) async {
                                                  // Delete from unvalidated
                                                  await fbHelper.unvalidatedURLs
                                                      .document(
                                                          widget.donation.name)
                                                      .delete()
                                                      .then((_) {
                                                    // setState(() {});

                                                    // Can now bring a new donation for validation
                                                    soundTin.setShouldRefreshValidatingDonationIndex =
                                                        true;

                                                    this.stopLoadingForValidation();
                                                    // this._validateTapCounter =
                                                    //     0; // redundant because of this.stopLoadingForValidation ??
                                                    // Appreciation
                                                    user.showDialogue(
                                                        'Thank you',
                                                        'We sincerely appreciate your validation. You can always do another');
                                                  });
                                                });
                                              });
                                            }
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
                        ),
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
                          // 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a latin professor at Hampden Sydney College Virginia, looked up one of the more obscure Lation words,consectetur, from a Lorem Ipsum passage, and going through the cities of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.\n\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
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

class SubmitValidationAlertDialog extends StatefulWidget {
  SubmitValidationAlertDialog({
    Key key,
    @required int validateTapCounter,
    @required int invalidateTapCounter,
    @required this.validInvalidUpperPreText,
    @required this.validInvalidText,
    @required this.validInvalidLowerPreText,

    // @required this.mounted,
  })  : _validateTapCounter = validateTapCounter,
        super(key: key);

  int _validateTapCounter;
  int _invalidateTapCounter;
  final String validInvalidUpperPreText;
  final String validInvalidText;
  final String validInvalidLowerPreText;

  // final bool mounted;

  @override
  _SubmitValidationAlertDialogState createState() =>
      _SubmitValidationAlertDialogState();
}

class _SubmitValidationAlertDialogState
    extends State<SubmitValidationAlertDialog> {
  TextEditingController _validationTextController;
  @override
  initState() {
    _validationTextController = new TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    _validationTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SoundTin soundTin = Provider.of<SoundTin>(context, listen: false);
    return AlertDialog(
      title: Text(
        'Submit ${widget.validInvalidUpperPreText}${widget.validInvalidText}ation',
        style: TextStyle(
          fontFamily: 'Abel',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: (this.widget._validateTapCounter > 0)
              ? Colors.green
              : Colors.red[700],
        ),
      ),
      content: Container(
        height: (this.widget._validateTapCounter > 0) ? null : 90.0,
        child: (this.widget._validateTapCounter > 0)
            ? Text(
                'Are you sure you want to submit your evaluation?',
                style: const TextStyle(
                  fontFamily: 'Abel',
                  fontSize: 17.0,
                  // fontWeight: FontWeight.bold
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '(Optional) Tell us why this recording is ${widget.validInvalidLowerPreText}${widget.validInvalidText}',
                    style: const TextStyle(
                      fontFamily: 'Abel',
                      fontSize: 17.0,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  TextFormField(
                    controller: this._validationTextController,
                    cursorColor: (this.widget._validateTapCounter > 0)
                        ? Colors.lightGreen[900]
                        : Colors.redAccent,
                    maxLength: 30,
                    decoration: InputDecoration(
                      counterText: '',

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          // color: (this._validateTapCounter > 0)
                          //     ? Colors.lightGreen
                          //     : Colors.red[900],
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: (this.widget._validateTapCounter > 0)
                              ? Colors.lightGreen
                              : Colors.red[900],
                        ),
                      ),
                      // counter: Text(
                      //   '$_validationTextReasonLength',
                      //   style: TextStyle(
                      //     fontFamily: 'ComicNeue',
                      //     color: Colors.red[700],
                      //   ),
                      // ),

                      labelStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                      ),
                      // prefixText: '+234-',
                      // labelText:
                      //     '(Optional) Tell us why this recording is $validInvalidLowerPreText$validInvalidText',
                      // hintText:
                      //     'Tell us why this recording is $validInvalidText',

                      // fillColor: Theme.of(context).primaryColor.withOpacity(.45),
                    ),
                    // onChanged: (value) {
                    //   if(this.mounted)
                    //   setState(() {});
                    // },
                  ),
                ],
              ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Re-evaluate',
            style: TextStyle(
              fontFamily: 'PTSans',
              fontSize: 17.0,
              // fontWeight: FontWeight.bold
              color: (this.widget._validateTapCounter > 0)
                  ? Colors.lightGreen
                  : Colors.red[400],
            ),
          ),
          onPressed: () {
            setState(() {
              // soundTin.setProceedWithDonationEvaluation = false;
              Navigator.of(context).pop();
            });
          },
        ),
        RaisedButton(
          color: (this.widget._validateTapCounter > 0)
              ? Colors.lightGreen
              : Colors.red,
          child: Text(
            (this.widget._validateTapCounter > 0) ? 'Validate' : 'Invalidate',
            style: const TextStyle(
              fontFamily: 'PTSans',
              fontSize: 17.0,
              // fontWeight: FontWeight.bold
              color: Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              soundTin.setReasonForInvalidation =
                  this._validationTextController.text;
              soundTin.setProceedWithDonationEvaluation = true;
              Navigator.of(context).pop();
            });
          },
        ),
      ],
    );
  }
}
