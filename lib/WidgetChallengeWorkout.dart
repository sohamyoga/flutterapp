import 'dart:async';
import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:workout/DataFile.dart';
import 'package:workout/PrefData.dart';
import 'package:workout/customWidget/DotsIndicator.dart';
import 'package:workout/models/ModelChallengeExerciseList.dart';
import 'package:workout/models/ModelChallengesMainCat.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:workout/models/ModelHistory.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'HomeWidget.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'generated/l10n.dart';
import 'models/ModelExerciseDetail.dart';

// ignore: must_be_immutable
class WidgetChallengeWorkout extends StatefulWidget {
  ModelChallengesMainCat _modelDummySend;
  List<ModelChallengeExerciseList> _modelExerciseList;

  // int tableId;

  WidgetChallengeWorkout(this._modelExerciseList, this._modelDummySend);

  @override
  _WidgetChallengeWorkout createState() => _WidgetChallengeWorkout();
}

// ignore: must_be_immutable
class WidgetSkipData extends StatefulWidget {
  ModelExerciseDetail _modelExerciseDetail;
  ModelChallengeExerciseList _modelExerciseList;
  Function _functionSkip;
  Function _functionSkipTick;

  int totalPos;
  int currentPos;

  WidgetSkipData(
      this._modelExerciseDetail,
      this._modelExerciseList,
      this._functionSkip,
      this.currentPos,
      this.totalPos,
      this._functionSkipTick);

  @override
  _WidgetSkipData createState() => _WidgetSkipData();
}

class _WidgetSkipData extends State<WidgetSkipData>
    with WidgetsBindingObserver {
  int skiptime = 10;
  Timer? _timer;
  String currentTime = "";

  // FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    // initTTS();
    /* for ios only */

    /*await flutterTts.setSharedInstance(true);
    *
    *
    * await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
    *
    *
    * */
    super.initState();
  }

  // Future _speak(String txt) async{
  //   var result = await flutterTts.speak(txt);
  //   if (result == 1) setState(() {
  //
  //   }
  //   // ttsState = TtsState.playing
  //   );
  // }
  // Future initTTS() async{
  //   await flutterTts.awaitSpeakCompletion(true);
  //
  // }
  //
  // Future _stop() async{
  //   var result = await flutterTts.stop();
  //   if (result == 1) setState(() =>
  //       {
  //
  //       }
  //   // ttsState = TtsState.stopped
  //   );
  // }
  //

  void cancelSkipTimer() {
    _timer!.cancel();
    _timer = null;
  }

  // Future _getLanguages() async {
  //   languages = await flutterTts.getLanguages;
  //   if (languages != null) setState(() => languages);
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("getstate1==$state");

    if (state == AppLifecycleState.paused) {
      pauseSkip();
    } else if (state == AppLifecycleState.resumed) {
      if (!isSkipDialogOpen) {
        resumeSkip();
      }
    }
  }

  void setSkipTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => {
              if (mounted)
                {
                  setState(
                    () {
                      // currentTime = timer.tick.toString();
                      // if (skiptime < 1) {


                      if (skiptime < 1) {
                        cancelSkipTimer();
                        // widget.timerOverCallback();

                        // cancelTimer();
                        // widget.timerOverCallback();
                        widget._functionSkip();
                      } else {
                        skiptime = skiptime - 1;
                      }
                      if (skiptime < Constants.maxTime && skiptime > Constants.minTime) {

                        widget._functionSkipTick(skiptime.toString());
                      }
                      currentTime = skiptime.toString();
                    },
                  ),
                }
            });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (_timer != null) {
      cancelSkipTimer();
    }
    // disposeBannerAd(adsFile);
    super.dispose();
  }

  PageController controller = PageController();

  // InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  bool isSkipDialogOpen = false;





  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (_timer == null) {
      setSkipTimer();
    }

    return Container(
      key: scaffoldState,
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "REST",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left:30, right: 30, top: 15, bottom: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        skiptime = skiptime + 20;
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 7, bottom: 7, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.grey),
                        child: getSmallBoldTextWithMaxLine(
                            "+ 20 Sec", Colors.black, 1),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: getCustomText((currentTime=="0")?"Go":currentTime, Colors.white, 1,
                            TextAlign.center, FontWeight.w700, 40),
                      ),
                    ),
                    InkWell(
                      child: getCustomText("SKIP", Colors.grey, 1,
                          TextAlign.start, FontWeight.bold, 28),
                      onTap: () {
                        widget._functionSkip();
                      },
                    )
                  ],
                ),
              )

              // Text(
              //   "REST",
              //   style: TextStyle(
              //     fontSize: 50,
              //     fontFamily: Constants.fontsFamily,
              //     fontWeight: FontWeight.w900,
              //     color: Colors.grey,
              //   ),
              //   textAlign: TextAlign.center,
              // )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child:
                getMediumBoldText("Coming Up :", Colors.white, TextAlign.start),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 7, top: 7, bottom: 7, right: 15),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black12),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Image.asset(
                    "${Constants.assetsGifPath}${widget._modelExerciseDetail.image}${Constants.assetsImageFormat}",
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getMediumNormalTextWithMaxLine(
                          widget._modelExerciseDetail.name!,
                          Colors.black,
                          2,
                          TextAlign.start),
                      getExtraSmallNormalTextWithMaxLine(
                          widget._modelExerciseList.duration! + " Seconds",
                          Colors.black45,
                          1,
                          TextAlign.start)
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  onPressed: () {
                    ModelExerciseDetail exerciseDetail =
                        widget._modelExerciseDetail;
                    isSkipDialogOpen = true;
                    pauseSkip();
                    showModalBottomSheet<void>(
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: bgDarkWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: SizeConfig.safeBlockVertical! * 80,
                          child: ListView(
                            padding: EdgeInsets.all(7),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            children: [
                              Container(
                                width: double.infinity,
                                height: SizeConfig.safeBlockVertical! * 40,
                                child: PageView(
                                  controller: controller,
                                  children: <Widget>[
                                    // KeepAlivePage(child:
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(children: [
                                        Image.asset(
                                          "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.none,
                                          // )
                                        ),
                                        Visibility(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: () {
                                                // controller.jumpToPage(1);
                                                controller.animateToPage(1,
                                                    curve: Curves.decelerate,
                                                    duration: Duration(
                                                        milliseconds: 300));
                                              },
                                              padding: EdgeInsets.all(7),
                                              icon: Icon(
                                                Icons.videocam,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          visible: false,
                                        )
                                      ]),
                                    ),
                                    // // KeepAlivePage(
                                    // //     child:
                                    // Container(
                                    //     width: double.infinity,
                                    //     height: double.infinity,
                                    //     child: Column(children: <Widget>[
                                    //       Expanded(
                                    //         child: Container(
                                    //           width: double.infinity,
                                    //           height: double.infinity,
                                    //           child: InAppWebView(
                                    //             initialUrl:
                                    //                 "https://www.youtube.com/embed/ml6cT4AZdqI",
                                    //             initialHeaders: {},
                                    //             initialOptions:
                                    //                 InAppWebViewGroupOptions(
                                    //                     crossPlatform:
                                    //                         InAppWebViewOptions(
                                    //               debuggingEnabled: true,
                                    //             )),
                                    //             onWebViewCreated:
                                    //                 (InAppWebViewController
                                    //                     controller) {
                                    //               webView = controller;
                                    //             },
                                    //             onLoadStart:
                                    //                 (InAppWebViewController
                                    //                         controller,
                                    //                     String url) {},
                                    //             onLoadStop:
                                    //                 (InAppWebViewController
                                    //                         controller,
                                    //                     String url) {},
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ]))
                                    // // )
                                    // ,
                                  ],
                                ),
                                // Align(
                                //   alignment: Alignment.topRight,
                                //   child: IconButton(
                                //     onPressed: () {
                                //       // controller.jumpToPage(1);
                                //       controller.animateToPage(1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                                //     },
                                //     padding: EdgeInsets.all(7),
                                //     icon: Icon(
                                //       Icons.videocam,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // )
                                // ],
                                // ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(7),
                                child: Text(
                                  exerciseDetail.name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontFamily: Constants.fontsFamily,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              getCustomText("How to perform11", Colors.black, 1,
                                  TextAlign.start, FontWeight.w600, 18),
                              SizedBox(
                                height: 7,
                              ),
                              // Text(
                              //   exerciseDetail.detail,
                              //   textAlign: TextAlign.start,
                              //   style: TextStyle(
                              //     fontSize: 15,
                              //     fontFamily: Constants.fontsFamily,
                              //     fontWeight: FontWeight.normal,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              HtmlWidget(
                                exerciseDetail.detail!,
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    wordSpacing: 2,
                                    fontFamily: Constants.fontsFamily,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        );
                      },
                    ).whenComplete(() {
                      isSkipDialogOpen = false;
                      resumeSkip();
                    });
                  },
                  padding: EdgeInsets.all(7),
                )
              ],
            ),
          ),
          StepProgressIndicator(
            totalSteps: widget.totalPos,
            currentStep: widget.currentPos,
            selectedColor: Colors.green,
            unselectedColor: Colors.transparent,
          )
        ],
      ),
    );
  }

  void pauseSkip() {
    if (_timer != null) {
      cancelSkipTimer();
    }
  }

  void resumeSkip() {
    if (_timer == null) {
      setSkipTimer();
    }
  }
}

// ignore: must_be_immutable
class WidgetDetailData extends StatefulWidget {
  ModelChallengeExerciseList _modelExerciseList;
  ModelExerciseDetail _modelExerciseDetail;
  bool fromFirst;
  Function muteOverCallback;
  Function timerOverCallback;
  Function timerPreOverCallback;
  final int readyDuration;
  final bool isReady;
  Function setReadyFunction;
  Function _functionSkipTick;

  WidgetDetailData(
      this._modelExerciseList,
      this._modelExerciseDetail,
      this.timerOverCallback,
      this.timerPreOverCallback,
      this.fromFirst,
      this.isReady,
      this.readyDuration,
      this.setReadyFunction,
      this.muteOverCallback,this._functionSkipTick);

  @override
  State<StatefulWidget> createState() => _WidgetDetailData();
}

class _WidgetDetailData extends State<WidgetDetailData>
    with WidgetsBindingObserver {
  int totalTimerTime=0;
  String currentTime="";
  Timer? _timer;

  @override
  void initState() {
    _timer = null;
    // currentTime = widget._modelExerciseList.duration;
    // totalTimerTime = int.parse(widget._modelExerciseList.duration);
    // print("insetDatas111===${totalTimerTime}");
    // widget.fromFirst=false
    WidgetsBinding.instance!.addObserver(this);
    // setState(() {
    //   _controller = YoutubePlayerController(
    //     initialVideoId:
    //         YoutubePlayer.convertUrlToId(widget._modelExerciseDetail.video),
    //     // initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=ml6cT4AZdqI"),
    //     // initialVideoId: 'ml6cT4AZdqI',
    //     flags: YoutubePlayerFlags(
    //       autoPlay: true,
    //       hideControls: true,
    //       mute: true,
    //     ),
    //   );
    // });
    super.initState();
  }

  Future<String> showSoundDialog() async {
    bool isSwitched = await PrefData().getIsMute();
    bool isSwitchedSound = await PrefData().getIsSoundOn();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 300.0,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Sound Options", Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: Colors.black54,
                          ),
                          Expanded(
                            child: getSmallNormalTextWithMaxLine(
                                S.of(context).ttsVoice, Colors.black, 1),
                            flex: 1,
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: accentColor,
                            activeColor: accentColor,
                          )
                          // TextFormField(
                          //   decoration: InputDecoration(
                          //       labelText: 'Enter your username'
                          //   ),
                          // )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: Colors.black54,
                          ),
                          Expanded(
                            child: getSmallNormalTextWithMaxLine(
                                "Sound", Colors.black, 1),
                            flex: 1,
                          ),
                          Switch(
                            value: isSwitchedSound,
                            onChanged: (value) {
                              setState(() {
                                isSwitchedSound = value;
                              });
                            },
                            activeTrackColor: accentColor,
                            activeColor: accentColor,
                          )
                          // TextFormField(
                          //   decoration: InputDecoration(
                          //       labelText: 'Enter your username'
                          //   ),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              new TextButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        fontSize: 15,
                        color: accentColor,
                        fontWeight: FontWeight.normal),
                  ),
                  // textColor: accentColor,
                  onPressed: () {
                    widget.muteOverCallback();
                    PrefData().setIsMute(isSwitched);
                    PrefData().setIsSoundOn(isSwitchedSound);
                    // pauseTimer();
                    Navigator.pop(context);
                  }),
            ],
          );
        }).then((value) {
          pauseTimer();
          return "" ;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      if (_timer != null) {
        pauseTimer();
      }
    }else if (state == AppLifecycleState.resumed) {
      pauseTimer();
    }

  }

  IconData getPlayPauseIcon() {
    if (_timer == null) {
      return Icons.play_arrow_rounded;
    } else {
      return Icons.pause_rounded;
    }
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => {
              if (mounted)
                {
                  setState(
                    () {
                      // currentTime = timer.tick.toString();
                      if (totalTimerTime < 1) {

                        if (!widget.isReady) {
                          widget.setReadyFunction();
                        } else {
                          cancelTimer();
                          widget.timerOverCallback();
                        }

                        // cancelTimer();
                        // widget.timerOverCallback();
                      } else {
                        totalTimerTime = totalTimerTime - 1;
                      }
                      if(!widget.isReady)
                      {
                        if (totalTimerTime < Constants.maxTime &&
                            totalTimerTime > Constants.minTime) {
                          print("settime===$totalTimerTime");
                          widget._functionSkipTick(totalTimerTime.toString());
                        }
                      }

                      currentTime = totalTimerTime.toString();
                    },
                  ),
                }
            }
        //       // print("timertick==${timer.tick}")
        //     // if (mounted) {
        //   setState(
        //         () {
        //       // currentTime = timer.tick.toString();
        //       if (totalTimerTime < 1) {
        //         timer.cancel();
        //         widget.timerOverCallback();
        //       } else {
        //         totalTimerTime = totalTimerTime - 1;
        //       }
        //       currentTime = totalTimerTime.toString();
        //     },
        //   ),
        // // }

        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    cancelTimer();
    super.dispose();
  }

  void showBottomDialog(ModelExerciseDetail exerciseDetail, bool isVideo) {
    PageController controller =
        PageController(keepPage: true, initialPage: isVideo ? 1 : 0);

    YoutubePlayerController _controller = YoutubePlayerController(
      // initialVideoId: YoutubePlayer.convertUrlToId(exerciseDetail.video!)!,
      initialVideoId: 'ml6cT4AZdqI',
      // initialVideoId: 'iLnmTe5Q2Qw',
      // initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=ml6cT4AZdqI"),
      // initialVideoId: 'ml6cT4AZdqI',
      flags: YoutubePlayerFlags(
        // isLive: true,
        autoPlay: true,
        hideControls: false,
        mute: true,
      ),
    );
    const _kDuration = const Duration(milliseconds: 300);

    const _kCurve = Curves.ease;

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 80,
          child: ListView(
            padding: EdgeInsets.all(7),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            primary: false,
            children: [
              // Container(
              //   width: double.infinity,
              //   height: SizeConfig.safeBlockVertical! * 40,
              //   child: Stack(
              //     children: [
              //       Image.asset(
              //         "${Constants.ASSETS_GIF_PATH}${exerciseDetail.image}",
              //         height: double.infinity,
              //         width: double.infinity,
              //         fit: BoxFit.contain,
              //       ),
              //       Align(
              //         alignment: Alignment.topRight,
              //         child: IconButton(
              //           onPressed: () {},
              //           padding: EdgeInsets.all(7),
              //           icon: Icon(
              //             Icons.videocam,
              //             color: Colors.black,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical! * 40,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    // KeepAlive(
                    //   child:
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(children: [
                        Image.asset(
                          "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.none,
                          // )
                        ),
                        Visibility(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // controller.jumpToPage(1);
                                controller.animateToPage(1,
                                    curve: Curves.decelerate,
                                    duration: Duration(milliseconds: 300));
                              },
                              padding: EdgeInsets.all(7),
                              icon: Icon(
                                Icons.videocam,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          visible: true,
                        )
                      ]),
                    ),
                    //   keepAlive: true,
                    // ),

                    // KeepAlivePage(child:
                    // Container(
                    //   width: double.infinity,
                    //   height: double.infinity,
                    //   child: Stack(children: [
                    //     Image.asset(
                    //       "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
                    //       height: double.infinity,
                    //       width: double.infinity,
                    //       fit: BoxFit.none,
                    //       // )
                    //     ),
                    //     Visibility(
                    //       child: Align(
                    //         alignment: Alignment.topRight,
                    //         child: IconButton(
                    //           onPressed: () {
                    //             // controller.jumpToPage(1);
                    //             controller.animateToPage(1,
                    //                 curve: Curves.decelerate,
                    //                 duration: Duration(milliseconds: 300));
                    //           },
                    //           padding: EdgeInsets.all(7),
                    //           icon: Icon(
                    //             Icons.videocam,
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ),
                    //       visible: false,
                    //     )
                    //   ]),
                    // ),
                    // KeepAlivePage(
                    //     child:
                    // KeepAlive(
                    //     keepAlive: true,
                    //     child:
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.amber,
                            width: double.infinity,
                            onReady: () {})
                        // Column(children: <Widget>[
                        // Expanded(
                        //   child: Container(
                        //     width: double.infinity,
                        //     height: double.infinity,
                        //     child: InAppWebView(
                        //       initialUrl:
                        //           "https://www.youtube.com/embed/ml6cT4AZdqI",
                        //       initialHeaders: {},
                        //       initialOptions: InAppWebViewGroupOptions(
                        //           crossPlatform: InAppWebViewOptions(
                        //         debuggingEnabled: true,
                        //       )),
                        //       onWebViewCreated:
                        //           (InAppWebViewController controller) {
                        //         webView = controller;
                        //       },
                        //       onLoadStart: (InAppWebViewController controller,
                        //           String url) {},
                        //       onLoadStop: (InAppWebViewController controller,
                        //           String url) {},
                        //     ),
                        //   ),
                        // ),
                        // ]
                        )
                    // )

                    // )
                    // )
                    // )
                    // ,
                  ],
                ),

                // Align(
                //   alignment: Alignment.topRight,
                //   child: IconButton(
                //     onPressed: () {
                //       // controller.jumpToPage(1);
                //       controller.animateToPage(1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                //     },
                //     padding: EdgeInsets.all(7),
                //     icon: Icon(
                //       Icons.videocam,
                //       color: Colors.black,
                //     ),
                //   ),
                // )
                // ],
                // ),
              ),
              SizedBox(height: 3),
              Center(
                child: new DotsIndicator(
                  controller: controller,
                  color: Colors.black,
                  itemCount: 2,
                  onPageSelected: (int page) {
                    controller.animateToPage(
                      page,
                      duration: _kDuration,
                      curve: _kCurve,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(7),
                child: Text(
                  exerciseDetail.name!,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontFamily: Constants.fontsFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              getCustomText("How to perform", Colors.black, 1, TextAlign.start,
                  FontWeight.w600, 18),
              SizedBox(
                height: 7,
              ),
              // Text(
              //   exerciseDetail.detail,
              //   textAlign: TextAlign.start,
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontFamily: Constants.fontsFamily,
              //     fontWeight: FontWeight.normal,
              //     color: Colors.black,
              //   ),
              // ),
              HtmlWidget(
                exerciseDetail.detail!,
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    wordSpacing: 2,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        );
      },
    ).then((value) {
      pauseTimer();
    });
  }

  // InAppWebViewController webView;
  bool isShowVideo = false;

  @override
  Widget build(BuildContext context) {
    print("fromfirst===${widget.fromFirst}");
    // if (widget.fromFirst) {
    //   widget.fromFirst = false;
    //   print("fromfirst2===${widget.fromFirst}");
    //
    //   // currentTime = "10";
    //   // totalTimerTime = 10;
    //   currentTime = widget._modelExerciseList.duration;
    //   totalTimerTime = int.parse(widget._modelExerciseList.duration);
    //   print("insetDatas==={totalTimerTime}");
    //   if (_timer == null) {
    //     startTimer();
    //   }
    // }
    if (!widget.isReady) {
      if (_timer == null) {
        currentTime = widget.readyDuration.toString();
        totalTimerTime = widget.readyDuration;
        startTimer();
      }
    } else {
      if (widget.fromFirst) {
        widget.fromFirst = false;
        print("fromfirst2===${widget.fromFirst}");

        currentTime = widget._modelExerciseList.duration!;
        totalTimerTime = int.parse(widget._modelExerciseList.duration!);
        print("insetDatas==={totalTimerTime}");
        // currentTime = "10";
        // totalTimerTime = 10;
        // print("insetDatas==={totalTimerTime}");
        if (_timer == null) {
          startTimer();
        }
      }
    }


    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Center(
                  // child: (isShowVideo)
                  //     ? YoutubePlayer(
                  //         controller: _controller,
                  //         showVideoProgressIndicator: true,
                  //         progressIndicatorColor: Colors.amber,
                  //         width: double.infinity,
                  //         onReady: () {},
                  //       )
                  //     : Image.asset(
                  //         "${Constants.assetsGifPath}${widget._modelExerciseDetail.image}${Constants.assetsImageFormat}",
                  //         fit: BoxFit.none,
                  //         height: double.infinity,
                  //         width: double.infinity,
                  //       )

                  child: Image.asset(
                    "${Constants.assetsGifPath}${widget._modelExerciseDetail.image}${Constants.assetsImageFormat}",
                    fit: BoxFit.none,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.videocam),
                      //   color: Colors.black87,
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(Icons.videocam),
                        color: Colors.black87,
                        onPressed: () {
                          setState(() {
                            pauseTimer();
                            showBottomDialog(widget._modelExerciseDetail, true);
                            // isShowVideo = !isShowVideo;
                            // if (isShowVideo) {
                            //   _controller = YoutubePlayerController(
                            //     initialVideoId: YoutubePlayer.convertUrlToId(
                            //         widget._modelExerciseDetail.video),
                            //     // initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=ml6cT4AZdqI"),
                            //     // initialVideoId: 'ml6cT4AZdqI',
                            //     flags: YoutubePlayerFlags(
                            //       autoPlay: true,
                            //       hideControls: true,
                            //       mute: true,
                            //     ),
                            //   );
                            //   // try {
                            //   //   _controller.play();
                            //   // } catch (e) {
                            //   //   print(e);
                            //   // }
                            // }
                          });
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.volume_up_rounded),
                        color: Colors.black87,
                        onPressed: () {
                          pauseTimer();
                          showSoundDialog();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        color: Colors.black87,
                        onPressed: () {
                          pauseTimer();
                          showBottomDialog(widget._modelExerciseDetail, false);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Column(
          //     children: [
          //       IconButton(
          //         icon: Icon(Icons.videocam),
          //         color: Colors.black,
          //         onPressed: () {},
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.volume_up_rounded),
          //         color: Colors.black,
          //         onPressed: () {},
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.info),
          //         color: Colors.black,
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   flex: 1,
          //   child: Image.asset(
          //     "${Constants.ASSETS_GIF_PATH}${widget._modelExerciseDetail
          //         .image}",
          //     fit: BoxFit.contain,
          //     height: double.infinity,
          //     width: double.infinity,
          //   ),
          // ),
          SizedBox(
            height: 5,
          ),
          getCustomText(widget._modelExerciseDetail.name!, Colors.black87, 1,
              TextAlign.center, FontWeight.w600, 22),
          Padding(
            padding: EdgeInsets.all(7),
            child: getLargeBoldTextWithMaxLine(currentTime, Colors.black87, 1),
          ),
          Visibility(
            child:Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    cancelTimer();
                    widget.timerPreOverCallback();
                  },
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Image.asset(
                    Constants.assetsImagePath + "prev_arrow.png",
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),

                  // Icon(
                  //   Icons.arrow_back_rounded,
                  //   size: 24,
                  // ),
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder(),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      pauseTimer();
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      getPlayPauseIcon(),
                      size: 30,
                    ),
                    padding: EdgeInsets.all(18),
                    shape: CircleBorder(),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    cancelTimer();
                    widget.timerOverCallback();
                  },
                  color: Colors.black54,
                  textColor: Colors.white,
                  child: Image.asset(
                    Constants.assetsImagePath + "next_arrow.png",
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                  // Icon(
                  //   Icons.arrow_forward_rounded,
                  //   size: 30,
                  // ),
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder(),
                ),
              ],
            ) ,
            visible: (widget.isReady),
          ),
          Visibility(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getCustomText("Ready to go!", Colors.black87, 1,
                      TextAlign.center, FontWeight.w500, (18)),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: InkWell(
                      child: getCustomText("Skip", Colors.black87, 1,
                          TextAlign.center, FontWeight.w500, 16),
                      onTap: () {
                        setState(() {
                          cancelTimer();
                          widget.setReadyFunction();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            visible: (!widget.isReady),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    } else {
      startTimer();
    }
    setState(() {});
  }

// void setNextData() {
//
// }

}

class _WidgetChallengeWorkout extends State<WidgetChallengeWorkout> with WidgetsBindingObserver  {
  // PausableTimer timer=null;
  // PausableTimer timer = PausableTimer(Duration(seconds: int.parse(widget._modelExerciseList[0].duration)), () => print('Fired!'));
  // Timer _timer;

  int pos = 0;
  bool isSkip = false;
  bool isReady = false;

  // ModelWorkoutList _modelWorkoutList;
  double getCal = 0;
  int getTotalWorkout = 0;
  List<ModelHistory> priceList=[];
  int getTime = 0;

  FlutterTts? flutterTts;

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  int totalDuration = 0;
  String startTime = "";


  // AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("1");


  // TtsState ttsState = TtsState.stopped;

  // bool get isPlaying => ttsState == TtsState.playing;

  // bool get isStopped => ttsState == TtsState.stopped;

  // VoiceController _voiceController;

  // Function onNextDataSet;

  // int totalTimerTime;
  // String currentTime;

  void _calcTotal() async {
    // priceList = await _dataHelper.calculateTotalWorkout();
    // if (priceList.length > 0) {
    //   getTotalWorkout = priceList.length;
    //   priceList.forEach((price) {
    //     getCal = getCal + double.parse(price.kCal!);
    //   });
    //   getTime = getTotalWorkout * 2;
    //
    //   print("getval=$getCal");
    //   // setState(() {});
    // }


    setState(() {
      getTotalWorkout = 5;
      getCal = 15 + getCal;
      getTime = 10 + getTime;

    });
  }

  void setPrevDataByPos() {
    print("getpos===$pos");
    if (pos > 0) {
      pos--;
      isSkip = false;
    }
    // else {
    //   isSkip = false;
    // }
    setState(() {});
  }

  void setDataByPos() {
    print("getpos===$pos");
    if (pos < widget._modelExerciseList.length) {
      pos++;
      isSkip = true;
    } else {
      isSkip = false;
    }
    playSound(false);

    setState(() {});
  }

  void setAfterSkip() {
    print("getpos===$pos");
    isSkip = false;
    playSound(true);

    setState(() {});
  }

  //
  // Future _getEngines() async {
  //   var engines = await flutterTts.getEngines;
  //   if (engines != null) {
  //     for (dynamic engine in engines) {
  //       print(engine);
  //     }
  //   }
  // }

  @override
  void dispose() {
    // try {
    //   _voiceController.stop();
    // } catch (e) {
    //   print(e);
    // }
    WidgetsBinding.instance!.removeObserver(this);
    try {
      // if(player!=null)
      //     {
      //       player.dispose();
      //     }
      // if (assetsAudioPlayer != null) {
      //   assetsAudioPlayer.stop();
      //   assetsAudioPlayer.dispose();
      // }
    } catch (e) {
      print(e);
    }
    flutterTts!.stop();
    try {
      periodicAlDuration12!.cancel();
    } catch (e) {
      print(e);
    }
    super.dispose();
    //
    // flutterTts.stop();
    // flutterTts=null;
  }

  void initTts() {
    // flutterTts = FlutterTts();

    // flutterTts.getLanguages.then((dynamic valuesLangs) {
    //   setState(() {
    //     // languages = valuesLangs;
    //     print("Complete1");
    //   });
    // });
    // flutterTts.setStartHandler(() {
    //   setState(() {
    //     ttsState = TtsState.playing;
    //     print("Complete2=$ttsState");
    //   });
    // });
    //
    // flutterTts.setCompletionHandler(() {
    //   setState(() {
    //     print("Complete");
    //     ttsState = TtsState.stopped;
    //     print("Complete3==$ttsState");
    //   });
    // });
    //
    // flutterTts.setErrorHandler((dynamic msg) {
    //   setState(() {
    //     ttsState = TtsState.stopped;
    //     print("Complete4==$ttsState");
    //   });
    // });
  }

  Timer? periodicAlDuration12;
  bool isTtsOn=true;
  bool isSoundOn = false;
  AudioCache audioCache = AudioCache();

  getMutesNoRefresh() async {
    isTtsOn = await PrefData().getIsMute();
    isSoundOn = await PrefData().getIsSoundOn();
    // try {
    //       if(isSoundOn)
    //       {
    //         assetsAudioPlayer.play();
    //       }
    //       else
    //       {
    //         assetsAudioPlayer.pause();
    //       }
    // } catch (e) {
    //   print(e);
    // }

  }

  playSound(bool isSkip) async {
    // bool b = await PrefData().getIsSoundOn();
    // print("playsound===true---$b");
    //
    // if (b) {
    //   await audioCache.play(
    //   );
    // }
  }

  void playSoundTicks(String val) {
    _speak(val);
    playTickSound();
  }

  playTickSound() async {
    // bool b = await PrefData().getIsSoundOn();
    // print("playsound123===true---$b");
    //
    // if (b) {
    //   await audioCache.play(
    //     'td_tick.mp3',
    //   );
    // }
  }

  getMutes() async {
    isTtsOn = await PrefData().getIsMute();
    isSoundOn = await PrefData().getIsSoundOn();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("getstate1==$state");

    if (state == AppLifecycleState.paused) {
      // pauseSkip();
      // try {
      //   if(assetsAudioPlayer!=null)
      //   {
      //     assetsAudioPlayer.pause();
      //   }
      // } catch (e) {
      //   print(e);
      // }
    } else if (state == AppLifecycleState.resumed) {
      getMutesNoRefresh();
      // if (!isSkipDialogOpen) {
      //   resumeSkip();
      // }
    }
  }

  playBgSound(String isSkip) async {
    bool b = await PrefData().getIsSoundOn();
    print("playsound===true---$b");
    // if (b) {
    // try {
    //   if (assetsAudioPlayer != null &&
    //       assetsAudioPlayer.isPlaying.value) {
    //     assetsAudioPlayer.stop();
    //   }
    // } catch (e) {
    //   print(e);
    // }
    // assetsAudioPlayer = AssetsAudioPlayer.withId("1");
    // assetsAudioPlayer.open(Audio("assets/" + isSkip),
    //     autoStart: b, loopMode: LoopMode.single,playInBackground: PlayInBackground.disabledPause,audioFocusStrategy: AssetsAudioPlayer.defaultFocusStrategy);
  }


  @override
  void initState() {
    // initTts();
    WidgetsBinding.instance!.addObserver(this);

    startTime = Constants.addDateFormat.format(new DateTime.now());
    getMutes();
    // Timer _timer = null;

    // Timer.periodic(Duration(microseconds: 1000), (_) {
    // Timer.periodic(Duration(milliseconds: 1000), (_) {
    //   totalDuration++;
    //   // Runs after every 1000ms
    // });
    flutterTts = FlutterTts();
    iosTTs();
    // AudioPlayer.logEnabled = true;
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
      audioCacheBG.fixedPlayer?.notificationService.startHeadlessService();
      // audioPlayer.startHeadlessService();
    }
    // _dataHelper.getWorkoutLevelById(widget._modelExerciseList[0].id).then((value) {
    //   if (value != null) {
    //     _modelWorkoutList = value;
    //   }
    // });
    _calcTotal();
    super.initState();
    int posw2 = 0;
    periodicAlDuration12 = Timer.periodic(Duration(seconds: 1), (timer) {
      posw2++;
      totalDuration++;
      // setState(() {
      print("sectimes==$posw2==$totalDuration");
      // });
    });
  }

  iosTTs() async {
    /* for ios only */
    await flutterTts!.awaitSpeakCompletion(true);
    await flutterTts!.setSharedInstance(true);
    await flutterTts!.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
  }

  // Future initTTS() async{
  //   await flutterTts.awaitSpeakCompletion(true);
  //   await flutterTts.setSharedInstance(true);
  //   // await flutterTts.setSilence(2);
  //
  // }

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) =>
  //         // print("timertick==${timer.tick}")
  //         setState(
  //       () {
  //         // currentTime = timer.tick.toString();
  //         if (totalTimerTime < 1) {
  //           timer.cancel();
  //         } else {
  //           totalTimerTime = totalTimerTime - 1;
  //         }
  //         currentTime = totalTimerTime.toString();
  //       },
  //     ),
  //   );
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  Future<void> share() async {
    Share.share(S.of(context).app_name, subject: S.of(context).app_name);
  }

  //
  //
  Future _speak(String txt) async {
    isTtsOn = await PrefData().getIsMute();

    // prevSpeak=txt;
    // print("ttssteps===$ttsState");
    // // if (ttsState == TtsState.playing) {
    // //   _stop();
    // // }
    if (isTtsOn) {
      if (prevSpeak != txt) {
        prevSpeak = txt;
        await flutterTts!.speak(txt);
      }
    }
    // if (result == 1) {
    //   // setState(() {
    //   ttsState = TtsState.playing;
    //   // }
    // }
    //       // ttsState = TtsState.playing
    //       // );
  }

  // Future _speak(String _newVoiceText) async {
  //   print("completeres--sgdrl$ttsState");
  //   try {
  //     _voiceController.stop();
  //     _voiceController.init().then((_) {
  //           _voiceController.speak(
  //               "testing audio output", VoiceControllerOptions(delay: 0));
  //         });
  //   } catch (e) {
  //     print(e);
  //   }

  //
  // if (_newVoiceText != null) {
  //   if (_newVoiceText.isNotEmpty) {
  //     dynamic result = await flutterTts.speak(_newVoiceText);
  //     print("completeres--$result");
  //
  //     if (result == 1) setState(() => ttsState = TtsState.playing);
  //   }
  // }
  // }

  // Future _stop() async {
  // dynamic result = await flutterTts.stop();
  // if (result == 1) setState(() => ttsState = TtsState.stopped);
  // }

  // Future _stop() async {
  //   var result = await flutterTts.stop();
  //   if (result == 1)
  //     setState(() {
  //       // ttsState = TtsState.stopped
  //     });
  // }

  //
  //
  // Future _stop() async{
  //   var result = await flutterTts.stop();
  //   if (result == 1) setState(() =>
  //   {
  //
  //   }
  //     // ttsState = TtsState.stopped
  //   );
  // }
  String prevSpeak = "";
  AudioCache audioCacheBG = AudioCache();
  AudioPlayer? player;


  void setReady() {
    isReady = true;
    setState(() {});
  }

  int readyDuration = 10;



  getDetailWidget()
  {

    ModelExerciseDetail _modelExerciseDetail = DataFile.getExerciseDetailList()[0];




          if (isSkip) {



            _speak("Take a rest");
            playBgSound("audio3.mp3");


            return WidgetSkipData(
                _modelExerciseDetail,
                widget._modelExerciseList[pos],
                setAfterSkip,
                pos,
                widget._modelExerciseList.length,
                playSoundTicks);
          } else {
            if(!isReady)
            {
              _speak("Ready to go start with ${_modelExerciseDetail.name}");
              playBgSound("audio1.mp3");


            }
            else
            {
              _speak(_modelExerciseDetail.name!);
              playBgSound("audio2.mp3");

            }

            return WidgetDetailData(
                widget._modelExerciseList[pos],
                _modelExerciseDetail,
                setDataByPos,
                setPrevDataByPos,
                true,
                isReady,
                readyDuration,
                setReady,
                getMutesNoRefresh,playSoundTicks);

            // return WidgetDetailData(
            //     widget._modelExerciseList[pos],
            //     _modelExerciseDetail,
            //     setDataByPos,
            //     setPrevDataByPos,
            //     true,
            //     getMutesNoRefresh);
          }

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // if (pos < widget._modelExerciseList.length) {
    //   _dataHelper.addHistoryData(
    //       widget., start_time, total_duration, kcal, date)
    // }
    print("mainrefresh==t=rue${widget._modelExerciseList.length}");
    return WillPopScope(
      child: Scaffold(
          body: SafeArea(
        child: (pos < widget._modelExerciseList.length)
            // body: (!isSkip)
            ? getDetailWidget()
            : Container(
          height: double.infinity,
          width: double.infinity,
          color: bgDarkWhite,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    share();
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical! * 30,
                child: Lottie.asset(
                    Constants.assetsImagePath + "trophy.json",
                    width: double.infinity,
                    height: double.infinity,
                    reverse: false,
                    fit: BoxFit.contain,
                    repeat: false),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 10,
              ),
              getMediumBoldItalicText(
                  widget._modelDummySend.title!, Colors.black),
              SizedBox(
                height: 7,
              ),
              SvgPicture.asset(
                Constants.assetsImagePath + "completed_banner.svg",
                height: SizeConfig.safeBlockHorizontal! *  25,
                width: SizeConfig.safeBlockHorizontal! *  50,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 7,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.safeBlockHorizontal! *  10,
                    right: SizeConfig.safeBlockHorizontal! *  10,
                    bottom: 10),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal! *  5,
                  right: SizeConfig.safeBlockHorizontal! *  5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          getMediumBoldTextWithMaxLine(
                              widget._modelExerciseList.length
                                  .toString(),
                              Colors.black,
                              1),
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: getMediumTextWithWeight(
                                S.of(context).exercises,
                                Colors.grey,
                                1,
                                FontWeight.w600),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          getMediumBoldTextWithMaxLine(
                            // Constants.calFormatter.format((widget
                            //         ._modelExerciseList.length *
                            //     Constants.calDefaultCalculation)),
                              Constants.calFormatter.format(
                                  totalDuration *
                                      Constants
                                          .calDefaultCalculation),
                              Colors.black,
                              1),
                          // getCal.toString(), Colors.black, 1),
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: getMediumTextWithWeight(
                                S.of(context).kcal,
                                Colors.grey,
                                1,
                                FontWeight.w600),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          getMediumBoldTextWithMaxLine(
                            // getTime.toString(),
                              Constants.getTimeFromSec(totalDuration),
                              Colors.black,
                              1),
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: getMediumTextWithWeight(
                                S.of(context).duration,
                                Colors.grey,
                                1,
                                FontWeight.w600),
                          )
                        ],
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Container(
                        margin: EdgeInsets.all(7),
                        width: SizeConfig.safeBlockHorizontal! *  50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                onPrimary: blueButton,

                                // color: blueButton,
                                padding: EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.all(
                            //         Radius.circular(25.0))),
                            onPressed: () {
                              //
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  new HomeWidget(2),
                                ),
                              );
                            },
                            child: Padding(
                                padding:
                                EdgeInsets.fromLTRB(0, 4, 0, 4),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                          10, 4, 4, 4),
                                      child:
                                      getSmallBoldTextWithMaxLine(
                                          "Continue",
                                          Colors.white,
                                          1),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          4, 0, 10, 0),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                )))),
                  ),
                ),
                flex: 1,
              )
            ],
          ),
          // color: Colors.red,
        ),
      )

          //   Container(
          //   height: double.infinity,
          //   width: double.infinity,
          //   color: bgDarkWhite,
          //   child: Column(
          //     children: [
          //       // Align(
          //       //   alignment: Alignment.topRight,
          //       //   child: IconButton(
          //       //     icon: Icon(Icons.videocam),
          //       //     color: Colors.black,
          //       //     onPressed: () {},
          //       //   ),
          //       // ),
          //       // Align(
          //       //   alignment: Alignment.topRight,
          //       //   child: IconButton(
          //       //     icon: Icon(Icons.volume_up_rounded),
          //       //     color: Colors.black,
          //       //     onPressed: () {},
          //       //   ),
          //       // ),
          //       // Align(
          //       //   alignment: Alignment.topRight,
          //       //   child: IconButton(
          //       //     icon: Icon(Icons.info),
          //       //     color: Colors.black,
          //       //     onPressed: () {},
          //       //   ),
          //       // ),
          //       Align(
          //         alignment: Alignment.topRight,
          //         child: Column(
          //           children: [
          //             IconButton(
          //               icon: Icon(Icons.videocam),
          //               color: Colors.black,
          //               onPressed: () {},
          //             ),
          //             IconButton(
          //               icon: Icon(Icons.volume_up_rounded),
          //               color: Colors.black,
          //               onPressed: () {},
          //             ),
          //             IconButton(
          //               icon: Icon(Icons.info),
          //               color: Colors.black,
          //               onPressed: () {},
          //             ),
          //           ],
          //         ),
          //       ),
          //       Expanded(
          //         flex: 1,
          //         child: Image.asset(
          //           "${Constants.ASSETS_GIF_PATH}${widget._modelExerciseDetail
          //               .image}",
          //           fit: BoxFit.contain,
          //           height: double.infinity,
          //           width: double.infinity,
          //         ),
          //       ),
          //       SizedBox(height: 5,),
          //       getMediumNormalTextWithMaxLine(
          //           widget._modelExerciseDetail.name, Colors.black87, 1),
          //       Padding(
          //         padding: EdgeInsets.all(7),
          //         child: getLargeBoldTextWithMaxLine("10", Colors.black87, 1),
          //       ),
          //       Row(
          //         children: [
          //           // InkWell(
          //           //   splashColor: Colors.red, // inkwell color
          //           //   child: SizedBox(
          //           //       width: 56, height: 56, child: Icon(Icons.menu)),
          //           //   onTap: () {},
          //           // ),
          //           MaterialButton(
          //             onPressed: () {},
          //             color: Colors.grey,
          //             textColor: Colors.white,
          //             child: Icon(
          //               Icons.arrow_back_rounded,
          //               size: 24,
          //             ),
          //             padding: EdgeInsets.all(12),
          //             shape: CircleBorder(),
          //           ),
          //           Expanded(
          //             flex: 1,
          //             child: MaterialButton(
          //               onPressed: () {},
          //               color: Colors.blue,
          //               textColor: Colors.white,
          //               child: Icon(
          //                 Icons.pause,
          //                 size: 30,
          //               ),
          //               padding: EdgeInsets.all(18),
          //               shape: CircleBorder(),
          //             ),
          //           ),
          //           MaterialButton(
          //             onPressed: () {},
          //             color: Colors.black54,
          //             textColor: Colors.white,
          //             child: Icon(
          //               Icons.arrow_forward_rounded,
          //               size: 24,
          //             ),
          //             padding: EdgeInsets.all(12),
          //             shape: CircleBorder(),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         height: 10,
          //       )
          //
          //       // Row(
          //       //   children: [
          //       //     ClipOval(
          //       //       child: Material(
          //       //         color: Colors.blue, // button color
          //       //         child: InkWell(
          //       //           splashColor: Colors.red, // inkwell color
          //       //           child: SizedBox(
          //       //               width: 56, height: 56, child: Icon(Icons.menu)),
          //       //           onTap: () {},
          //       //         ),
          //       //       ),
          //       //     ),
          //       //     Expanded(
          //       //       flex: 1,
          //       //     ),
          //       //     ClipOval(
          //       //       child: Material(
          //       //         color: Colors.blue, // button color
          //       //         child: InkWell(
          //       //           splashColor: Colors.red, // inkwell color
          //       //           child: SizedBox(
          //       //               width: 56, height: 56, child: Icon(Icons.menu)),
          //       //           onTap: () {},
          //       //         ),
          //       //       ),
          //       //     )
          //       //   ],
          //       // )
          //
          //       // Container(
          //       //   width: double.infinity,
          //       //   height: SizeConfig.blockSizeVertical * 35,
          //       //   child: Column(
          //       //     crossAxisAlignment: CrossAxisAlignment.center,
          //       //     mainAxisSize: MainAxisSize.max,
          //       //     mainAxisAlignment: MainAxisAlignment.end,
          //       //     children: [
          //       //       getMediumNormalTextWithMaxLine(
          //       //           widget._modelExerciseDetail.name, Colors.black87, 1),
          //       //       Padding(
          //       //         padding: EdgeInsets.all(7),
          //       //         child:
          //       //             getLargeBoldTextWithMaxLine("1", Colors.black87, 1),
          //       //       ),
          //       //       Row(
          //       //         mainAxisSize: MainAxisSize.min,
          //       //         children: [
          //       //           ClipOval(
          //       //             child: Material(
          //       //               color: Colors.blue, // button color
          //       //               child: InkWell(
          //       //                 splashColor: Colors.red, // inkwell color
          //       //                 child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu)),
          //       //                 onTap: () {},
          //       //               ),
          //       //             ),
          //       //           ),
          //       //           Expanded(flex: 1,),
          //       //           ClipOval(
          //       //             child: Material(
          //       //               color: Colors.blue, // button color
          //       //               child: InkWell(
          //       //                 splashColor: Colors.red, // inkwell color
          //       //                 child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu)),
          //       //                 onTap: () {},
          //       //               ),
          //       //             ),
          //       //           )
          //       //         ],
          //       //       )
          //       //       // Expanded(
          //       //       //   child:
          //       //       // Container(
          //       //       //   width: double.infinity,
          //       //       //   height: double.infinity,
          //       //       // ),
          //       //       // flex: 1,
          //       //       // )
          //       //     ],
          //       //   ),
          //       // )
          //     ],
          //   ),
          //   // child: Stack(
          //   //   children: [
          //   //     Column(
          //   //       children: [
          //   //         Align(
          //   //           alignment: Alignment.topRight,
          //   //           child: IconButton(
          //   //             icon: Icon(Icons.videocam),
          //   //             color: Colors.black,
          //   //             onPressed: () {},
          //   //           ),
          //   //         ),
          //   //         // SizedBox(
          //   //         //   height: 7,
          //   //         // ),
          //   //         Align(
          //   //           alignment: Alignment.topRight,
          //   //           child: IconButton(
          //   //             icon: Icon(Icons.volume_up_rounded),
          //   //             color: Colors.black,
          //   //             onPressed: () {},
          //   //           ),
          //   //         ),
          //   //         // SizedBox(
          //   //         //   height: 7,
          //   //         // ),
          //   //         Align(
          //   //           alignment: Alignment.topRight,
          //   //           child: IconButton(
          //   //             icon: Icon(Icons.info),
          //   //             color: Colors.black,
          //   //             onPressed: () {},
          //   //           ),
          //   //         ),
          //   //         Expanded(
          //   //           flex: 1,
          //   //           child: Image.asset(
          //   //             "${Constants.ASSETS_GIF_PATH}${widget._modelExerciseDetail.image}",
          //   //             fit: BoxFit.contain,
          //   //             height: double.infinity,
          //   //             width: double.infinity,
          //   //           ),
          //   //         ),
          //   //         Expanded(
          //   //           flex: 1,
          //   //
          //   //         )
          //   //       ],
          //   //     )
          //   //   ],
          //   // ),
          // ),
          ),
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contexts) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text('Exit'),
                content: Text('Do you really want to quite?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(contexts).pop();
                      Navigator.of(context).pop();
                    },
                    child:
                        getSmallNormalText("YES", Colors.red, TextAlign.start),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(contexts).pop();
                    },
                    child:
                        getSmallNormalText("N0", Colors.red, TextAlign.start),
                  )
                ],
              ),
            );
          },
        );

        // Navigator.of(context).pop();
        return false;
      },
    );
  }

// setTimerDatas() {
//   setState(() {
//     currentTime = timer.tick.toString();
//   });
// }
}
