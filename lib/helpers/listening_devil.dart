// Core
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' show Uint8List;

// External
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flauto.dart';
// import 'package:flutter_sound/flutter_sound_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound/track_player.dart';
import 'package:flutter_sound/flutter_sound_recorder.dart';

enum t_MEDIA {
  FILE,
  BUFFER,
  ASSET,
  // STREAM,
  // REMOTE_EXAMPLE_FILE,
}

/// Boolean to specify if we want to test the Rentrance/Concurency feature.
/// If true, we start two instances of FlautoPlayer when the user hit the "Play" button.
/// If true, we start two instances of FlautoRecorder and one instance of FlautoPlayer when the user hit the Record button
const bool REENTRANCE_CONCURENCY = false;

class ListeningDevil extends StatefulWidget {
  final double dashWidth;

  ListeningDevil({
    @required this.dashWidth,
  });

  @override
  _ListeningDevilState createState() => _ListeningDevilState();
}

class _ListeningDevilState extends State<ListeningDevil> {
  bool _isRecording = false;
  List<String> _path = [null, null, null, null, null, null, null];
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;

  FlutterSoundRecorder recorderModule;
  // FlutterSoundRecorder recorderModule_2; // Used if REENTRANCE_CONCURENCY

  String _recorderTxt = '00:00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_MEDIA _media = t_MEDIA.FILE;
  t_CODEC _codec = t_CODEC.CODEC_AAC;

  bool _encoderSupported = true; // Optimist
  bool _decoderSupported = true; // Optimist

  double _duration = null;

  Future<void> init() async {
    recorderModule = await FlutterSoundRecorder().initialize();
    await recorderModule.setDbPeakLevelUpdate(0.8);
    await recorderModule.setDbLevelEnabled(true);
    await recorderModule.setDbLevelEnabled(true);
    // if (REENTRANCE_CONCURENCY) {
    //   recorderModule_2 = await FlutterSoundRecorder().initialize();
    //   await recorderModule_2.setSubscriptionDuration(0.01);
    //   await recorderModule_2.setDbPeakLevelUpdate(0.8);
    //   await recorderModule_2.setDbLevelEnabled(true);
    // }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  t_AUDIO_STATE get audioState {
    if (recorderModule != null) {
      if (recorderModule.isPaused) return t_AUDIO_STATE.IS_RECORDING_PAUSED;
      if (recorderModule.isRecording) return t_AUDIO_STATE.IS_RECORDING;
    }
    return t_AUDIO_STATE.IS_STOPPED;
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
    if (_dbPeakSubscription != null) {
      _dbPeakSubscription.cancel();
      _dbPeakSubscription = null;
    }
  }

  // Future<void> releaseFlauto() async {
  //   try {
  //     await recorderModule.release();
  //     await recorderModule_2.release();
  //   } catch (e) {
  //     print(
  //         'Released unsuccessful'); /////////////////// TO Implement with dialog?
  //     print(e);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    cancelRecorderSubscriptions();
    // releaseFlauto();
  }

  static const List<String> paths = [
    'flutter_sound_example.aac', // DEFAULT
    'flutter_sound_example.aac', // CODEC_AAC
    'flutter_sound_example.opus', // CODEC_OPUS
    'flutter_sound_example.caf', // CODEC_CAF_OPUS
    'flutter_sound_example.mp3', // CODEC_MP3
    'flutter_sound_example.ogg', // CODEC_VORBIS
    'flutter_sound_example.wav', // CODEC_PCM
  ];

  void startRecorder() async {
    try {
      // String path = await flutterSoundModule.startRecorder
      // (
      //   paths[_codec.index],
      //   codec: _codec,
      //   sampleRate: 16000,
      //   bitRate: 16000,
      //   numChannels: 1,
      //   androidAudioSource: AndroidAudioSource.MIC,
      // );
      Directory tempDir = await getTemporaryDirectory();

      String path = await recorderModule.startRecorder(
        uri: '${tempDir.path}/${recorderModule.slotNo}-${paths[_codec.index]}',
        codec: _codec,
      );
      print('startRecorder: $path');

      _recorderSubscription = recorderModule.onRecorderStateChanged.listen((e) {
        if (e != null && e.currentPosition != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

          this.setState(() {
            this._recorderTxt = txt.substring(0, 8);
          });
        }
      });

      _dbPeakSubscription =
          recorderModule.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      // if (REENTRANCE_CONCURENCY) {
      //   try
      //   {
      //     Uint8List dataBuffer = (await rootBundle.load( assetSample[_codec.index] )).buffer.asUint8List( );
      //     await playerModule_2.startPlayerFromBuffer( dataBuffer, codec: _codec, whenFinished: ( )
      //     {
      //       //await playerModule_2.startPlayer(exampleAudioFilePath, codec: t_CODEC.CODEC_MP3, whenFinished: () {
      //       print( 'Secondary Play finished' );
      //     } );
      //   } catch(e) {
      //     print('startRecorder error: $e');
      //   }
      //   await recorderModule_2.startRecorder(
      //     uri: '${tempDir.path}/flutter_sound_recorder2.aac',
      //     codec: t_CODEC.CODEC_AAC,
      //   );
      //   print("Secondary record is '${tempDir.path}/flutter_sound_recorder2.aac'");
      // }

      this.setState(() {
        this._isRecording = true;
        this._path[_codec.index] = path;
      });
    } catch (err) {
      print('startRecorder error: $err');
      setState(() {
        stopRecorder();
        this._isRecording = false;
        if (_recorderSubscription != null) {
          _recorderSubscription.cancel();
          _recorderSubscription = null;
        }
        if (_dbPeakSubscription != null) {
          _dbPeakSubscription.cancel();
          _dbPeakSubscription = null;
        }
      });
    }
  }

  // Future<void> getDuration() async {
  //   switch (_media) {
  //     case t_MEDIA.FILE:
  //     // case t_MEDIA.STREAM:
  //     case t_MEDIA.BUFFER:
  //       int d = await flutterSoundHelper.duration(this._path[_codec.index]);
  //       _duration = d != null ? d / 1000.0 : null;
  //       break;
  //     case t_MEDIA.ASSET:
  //       _duration = null;
  //       break;
  //     // case t_MEDIA.REMOTE_EXAMPLE_FILE:
  //     //   _duration = null;
  //     //   break;
  //   }
  //   setState(() {});
  // }

  void stopRecorder() async {
    try {
      String result = await recorderModule.stopRecorder();
      print('stopRecorder: $result');
      cancelRecorderSubscriptions();
      // if (REENTRANCE_CONCURENCY) {
      //   await recorderModule_2.stopRecorder();
      //   await playerModule_2.stopPlayer();
      // }

      // getDuration();

    } catch (err) {
      print('stopRecorder error: $err');
    }
    this.setState(() {
      this._isRecording = false;
    });
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  // In this simple example, we just load a file in memory.This is stupid but just for demonstration  of startPlayerFromBuffer()
  Future<Uint8List> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      print('The file is ${contents.length} bytes long.');
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<String> assetSample = [
    'assets/samples/sample.aac',
    'assets/samples/sample.aac',
    'assets/samples/sample.opus',
    'assets/samples/sample.caf',
    'assets/samples/sample.mp3',
    'assets/samples/sample.ogg',
    'assets/samples/sample.wav',
  ];

  pauseResumeRecorder() {
    if (recorderModule.isPaused) {
      {
        recorderModule.resumeRecorder();
        // if (REENTRANCE_CONCURENCY) {
        //   recorderModule_2.resumeRecorder();
        // }
      }
    } else {
      recorderModule.pauseRecorder();
      // if (REENTRANCE_CONCURENCY) {
      //   recorderModule_2.pauseRecorder();
      // }
    }
  }

  onPauseResumeRecorderPressed() {
    switch (audioState) {
      case t_AUDIO_STATE.IS_PAUSED:
        return null;
        break;
      case t_AUDIO_STATE.IS_PLAYING:
        return null;
        break;
      case t_AUDIO_STATE.IS_STOPPED:
        return null;
        break;
      case t_AUDIO_STATE.IS_RECORDING:
        return pauseResumeRecorder;
        break;
      case t_AUDIO_STATE.IS_RECORDING_PAUSED:
        return pauseResumeRecorder;
        break;
    }
  }

  void startStopRecorder() {
    if (recorderModule.isRecording || recorderModule.isPaused)
      stopRecorder();
    else
      startRecorder();
  }

  onStartRecorderPressed() {
    if (_media == t_MEDIA.ASSET || _media == t_MEDIA.BUFFER
        // || _media == t_MEDIA.REMOTE_EXAMPLE_FILE
        ) return null;
    // Disable the button if the selected codec is not supported
    if (!_encoderSupported) return null;
    if (audioState != t_AUDIO_STATE.IS_RECORDING &&
        audioState != t_AUDIO_STATE.IS_RECORDING_PAUSED &&
        audioState != t_AUDIO_STATE.IS_STOPPED) return null;
    return startStopRecorder;
  }

  bool isStopped() => (audioState == t_AUDIO_STATE.IS_STOPPED);

  Widget _timeText(String timeText) {
    return Text(timeText, style: TextStyle(fontSize: 35.0, fontFamily: 'Abel'));
  }

  @override
  Widget build(BuildContext context) {
    // Widget recorderSection = Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Container(
    //         margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
    //         child: Text(
    //           this._recorderTxt,
    //           style: TextStyle(
    //             fontSize: 35.0,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //       _isRecording
    //           ? LinearProgressIndicator(
    //               value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
    //               valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    //               backgroundColor: Colors.red)
    //           : Container(),
    //       Row(
    //         children: <Widget>[
    //           Container(
    //             width: 56.0,
    //             height: 50.0,
    //             child: ClipOval(
    //               child: FlatButton(
    //                 onPressed: () {
    //                   print(audioState);
    //                   onStartRecorderPressed();
    //                 },
    //                 padding: EdgeInsets.all(8.0),
    //                 child: Image(
    //                   image: recorderAssetImage(),
    //                 ),
    //                 child: Text('mic'),
    //               ),
    //             ),
    //           ),
    //           Container(
    //             width: 56.0,
    //             height: 50.0,
    //             child: ClipOval(
    //               child: FlatButton(
    //                 onPressed: onPauseResumeRecorderPressed(),
    //                 disabledColor: Colors.white,
    //                 padding: EdgeInsets.all(8.0),
    //                 child: Image(
    //                   width: 36.0,
    //                   height: 36.0,
    //                   image: AssetImage(onPauseResumeRecorderPressed() != null
    //                       ? 'res/icons/ic_pause.png'
    //                       : 'res/icons/ic_pause_disabled.png'),
    //                 ),
    //                 child: Text('Rpause'),
    //               ),
    //             ),
    //           ),
    //         ],
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //       ),
    //     ]);

    return Container(
      // Record/Play Panel
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 5.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Card(
        elevation: 2.0,
        child: Container(
          width: widget.dashWidth,
          child: Container(
            // height: MediaQuery.of(context).size.height * .45,
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Center(
                  // child: Text('00:00:00',
                  //     style: TextStyle(fontSize: 35.0, fontFamily: 'Abel')),
                  child: _timeText(this._recorderTxt),
                )),
                OutlineButton( // Record/Stop
                  borderSide: BorderSide(color: Colors.green, width: 0.5),
                  // padding: EdgeInsets.all(0.0),
                  onPressed: () {
                    print(audioState);
                    onStartRecorderPressed();
                  },
                  child: Icon(
                      audioState == t_AUDIO_STATE.IS_STOPPED
                          ? Icons.mic
                          : Icons.stop,
                      color: audioState == t_AUDIO_STATE.IS_STOPPED
                          ? Colors.green
                          : Colors.deepOrange,
                      size: 25.0),
                  shape: CircleBorder(),
                ),
                OutlineButton( // Pause/Resume
                  borderSide: BorderSide(color: Colors.green, width: 0.5),
                  // padding: EdgeInsets.all(0.0),
                  onPressed: onPauseResumeRecorderPressed() != null ? null : onPauseResumeRecorderPressed(),
                  child: Icon(Icons.pause, color: Colors.deepOrange, size: 25.0),
                  shape: CircleBorder(),
                )
                // () {
                //   return !(audioState == t_AUDIO_STATE.IS_STOPPED)
                //       ? OutlineButton(
                //           borderSide:
                //               BorderSide(color: Colors.green, width: 0.5),
                //           // padding: EdgeInsets.all(0.0),
                //           onPressed: () {
                //             print(audioState);
                //             onStartRecorderPressed();
                //           },
                //           child: Icon(Icons.mic,
                //               color: Colors.deepOrange, size: 25.0),
                //           shape: CircleBorder(),
                //         )
                //       : OutlineButton(
                //           borderSide:
                //               BorderSide(color: Colors.green, width: 0.5),
                //           // padding: EdgeInsets.all(0.0),
                //           onPressed: () {
                //             setState(() {
                //               _startedRecordingNow = null;
                //             });
                //           },
                //           child:
                //               Icon(Icons.stop, color: Colors.red, size: 25.0),
                //           shape: CircleBorder(),
                //         );
                // }(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
