import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:share/share.dart';
import 'package:workout/ConstantWidget.dart';
import 'package:workout/customWidget/DotsIndicator.dart';
import 'package:workout/models/ModelDummySend.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'DataFile.dart';
import 'SizeConfig.dart';
import 'WidgetWorkout.dart';
import 'Widgets.dart';
import 'generated/l10n.dart';
import 'models/ModelExerciseDetail.dart';
import 'models/ModelWorkoutExerciseList.dart';

// ignore: must_be_immutable
class WidgetWorkoutExerciseList extends StatefulWidget {
  // ModelWorkoutList _modelWorkoutList_modelWorkoutList;
  ModelDummySend _modelWorkoutList;

  WidgetWorkoutExerciseList(this._modelWorkoutList);

  @override
  _WidgetWorkoutExerciseList createState() => _WidgetWorkoutExerciseList();
}

class _WidgetWorkoutExerciseList extends State<WidgetWorkoutExerciseList> {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  // List<ModelWorkoutExerciseList> _list = [];

  List<ModelWorkoutExerciseList> _list = DataFile.getWorkoutExerciseList();

  // int getCal = 0;
  // int getTime = 0;
  // int getTotalWorkout = 0;
  List? priceList;

  // AdsFile? adsFile;
  // AnimationController animationController;

  List<ModelWorkoutExerciseList> _exerciseList =
      DataFile.getWorkoutExerciseList();

  @override
  void initState() {
    // _calcTotal();
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    // Future.delayed(Duration(seconds: 1), () {
    //   adsFile = new AdsFile(context);
    //   adsFile!.createInterstitialAd();
    //
    // });

    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });

    getallData();
  }

  @override
  void dispose() {
    // disposeBannerAd(adsFile);
// disposeInterstitialAd(adsFile);
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    super.dispose();
  }

  Future<void> share() async {
    Share.share(S.of(context).app_name, subject: S.of(context).app_name);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Share':
        share();
        break;
      // case 'Settings':
      //   break;
    }
  }


  PageController controller = PageController();

  // InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // if (!_loadingAnchoredBanner) {
    //   _loadingAnchoredBanner = true;
    //   adsFile = new AdsFile(context);
    //   adsFile!.createAnchoredBanner(context, () {
    //     setState(() {});
    //   }, setState);
    // }

    double screenHeight = SizeConfig.safeBlockVertical! * 100;

    double getCal = 0;
    int getTime = 0;

    getTime = getTime + 10;

    getCal = Constants.calDefaultCalculation * getTime;

    ModelExerciseDetail exerciseDetail = DataFile.getExerciseDetailList()[0];

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:

        SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: ListView(
                primary: true,
                children: <Widget>[



                  Stack(
                    children: [

                      Container(
                        width: double.infinity,
                        height: Constants.getScreenPercentSize(context, 45),

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Constants.assetsImagePath +
                                    widget._modelWorkoutList.image),
                                fit: BoxFit.fitHeight)),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                        ),
                      ),






                      Stack(
                        children: [

                          Container(
                              height: Constants.getScreenPercentSize(context, 100),
                              margin: EdgeInsets.only(
                                  top: Constants.getScreenPercentSize(
                                      context, 25)),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0),
                                    ],
                                  )

                              )
                          ),


                          Container(
                              height: Constants.getScreenPercentSize(context, 100),
                              margin: EdgeInsets.only(
                                  top: Constants.getScreenPercentSize(
                                      context, 25)),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0),
                                    ],
                                  )

                              )
                          ),

                          Container(

                              height: Constants.getScreenPercentSize(context, 100)-Constants.getPercentSize(
                                  screenHeight, 43),

                              margin: EdgeInsets.only(
                                  top: Constants.getPercentSize(
                                      screenHeight, 43)),

                              decoration: BoxDecoration(


                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0.0, 1.5), //(x,y)
                                      blurRadius: Constants.getScreenPercentSize(context, 2),
                                    ),
                                  ],


                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0),
                                    ],
                                  )

                              )
                          ),
                          Container(

                              height: Constants.getScreenPercentSize(context, 100)-Constants.getPercentSize(
                                  screenHeight, 43),

                              margin: EdgeInsets.only(
                                  top: Constants.getPercentSize(
                                      screenHeight, 43)),

                              decoration: BoxDecoration(


                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0.0, 1.5), //(x,y)
                                      blurRadius: Constants.getScreenPercentSize(context, 2),
                                    ),
                                  ],


                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0),
                                    ],
                                  )

                              )
                          ),


                        ],
                      ),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        // backgroundColor: greyWhite,
                        iconTheme: IconThemeData(color: Colors.white),
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              onBackClicked();
                            }),
                        actions: <Widget>[
                          PopupMenuButton<String>(
                            onSelected: handleClick,
                            itemBuilder: (BuildContext context) {
                              return {'Share'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          )
                          //add buttons here
                        ],
                      ),

                      Column(
                        children: [
                          Container(

                              padding: EdgeInsets.symmetric(vertical: Constants.getScreenPercentSize(context,1.5)),
                              margin: EdgeInsets.only(
                                  top: Constants.getPercentSize(
                                      screenHeight, 40),left: Constants.getWidthPercentSize(context,10),
                                  right: Constants.getWidthPercentSize(context, 10)),
                              width: double.infinity,
                              decoration:BoxDecoration (
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(Constants.getScreenPercentSize(context,4))),
                                  color: accentColor
                              ),
                              // margin: EdgeInsets.all(7),
                              // width: SizeConfig.safeBlockHorizontal! * 55,
                              child: InkWell(
                                onTap:(){

                                  if (_list.length > 0) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) {
                                        return WidgetWorkout(
                                            _list, widget._modelWorkoutList);
                                      },
                                    ));
                                  }
                                },
                                child: Container(



                                  child: getCustomText("Start Workout", Colors.white, 1,
                                      TextAlign.center, FontWeight.w600, Constants.getScreenPercentSize(context,2.5)),

                                ),
                              )),

                          Hero(
                              tag: widget._modelWorkoutList.id,
                              child: Container(
                                width: double.infinity,

                                padding: EdgeInsets.symmetric(horizontal: Constants.getScreenPercentSize(context, 2)),
                                // height:
                                //     SizeConfig.safeBlockVertical! * 22,

                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Constants.getScreenPercentSize(context, 2)
                                      ),
                                      child: Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child:
                                          getMediumBoldTextWithMaxLine(
                                            widget
                                                ._modelWorkoutList.name,
                                            Colors.black,
                                            1,
                                          )),
                                    ),


                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: Constants.getScreenPercentSize(context, 2),top:5
                                      ),
                                      child: Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child:
                                          getSmallNormalText(
                                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                            Colors.black,
                                            TextAlign.start,
                                          )),
                                    ),



                                    // SizedBox(height:  Constants.getScreenPercentSize(context, 2,)),


                                    // Card(
                                    //   color: darkGrey,
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(15)),
                                    //   child: Padding(
                                    //     padding: EdgeInsets.only(
                                    //         left: 10,
                                    //         right: 10,
                                    //         top: 3,
                                    //         bottom: 3),
                                    //     child: getCustomText(
                                    //         S.of(context).transformation,
                                    //         Colors.black87,
                                    //         1,
                                    //         TextAlign.start,
                                    //         FontWeight.w600,
                                    //         15),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 7,
                                    // ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              children: [

                                                WidgetSpan(
                                                  alignment : PlaceholderAlignment.middle,

                                                  child: Image.asset(
                                                    Constants.assetsImagePath+"flame.png",
                                                    height: ConstantWidget.getScreenPercentSize(context, 3.5),
                                                  ),
                                                ),

                                                // WidgetSpan(
                                                //   child: Icon(
                                                //     Icons.whatshot,
                                                //     size: 20,
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                WidgetSpan(
                                                    child: SizedBox(
                                                      width: 10,
                                                    )),
                                                TextSpan(
                                                    text:
                                                    "${Constants.calFormatter.format(getCal)} ${S.of(context).calories}",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.black,
                                                        fontFamily: Constants
                                                            .fontsFamily,
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600)),
                                              ],
                                            ),
                                          ),


                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: RichText(
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                   alignment : PlaceholderAlignment.middle,

                                                  child: Image.asset(
                                                    Constants.assetsImagePath+"stopwatch.png",
                                                    height: ConstantWidget.getScreenPercentSize(context, 4),
                                                  ),
                                                ),
                                                WidgetSpan(
                                                    child: SizedBox(
                                                      width: 10,
                                                    )),



                                                TextSpan(


                                                    text: Constants
                                                        .getTimeFromSec(
                                                        getTime),
                                                    // "$getTime ${S.of(context).minutes}",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.black,

                                                        fontFamily: Constants
                                                            .fontsFamily,
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600)),
                                              ],
                                            ),
                                          ),


                                          flex: 1,
                                        )

                                        ,



                                      ],
                                    ),
                                    SizedBox(
                                      height: 7,
                                    )
                                  ],
                                ),
                              )),

                          Padding(
                            padding: EdgeInsets.all(
                                Constants.getScreenPercentSize(context, 2)
                            ),
                            child: Align(
                                alignment:
                                Alignment.centerLeft,
                                child:
                                getMediumBoldTextWithMaxLine(
                                  "Exercises",
                                  Colors.black,
                                  1,
                                )),
                          ),



                          Container(


                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _exerciseList.length,
                                padding:
                                EdgeInsets.only(bottom: 25, top: 15),
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  ModelWorkoutExerciseList
                                  _modelExerciseList =
                                  _exerciseList[index];
                                  print(
                                      "exerciseid==--${exerciseDetail.image}");

                                  double radius =
                                  Constants.getScreenPercentSize(
                                      context, 2);
                                  return InkWell(
                                    child: Card(
                                      color: greyWhite.withOpacity(0.2),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(radius))),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius
                                        //         .all(Radius
                                        //         .circular(
                                        //         7)),
                                        //     color: Colors
                                        //         .white),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 7,
                                                  top: 7,
                                                  bottom: 7,
                                                  right: 15),
                                              decoration: BoxDecoration(
                                                  color:
                                                  accentColor.withOpacity(0.1),
                                                  // "#99d8ef".toColor(),
                                                  // color: "#81c1fe".toColor(),
                                                  // color: Colors.grey.shade100,

                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          radius))
                                                // border: Border.all(
                                                //     width:
                                                //     1,
                                                //     color: Colors
                                                //         .black12),
                                                // borderRadius:
                                                // BorderRadius.all(
                                                //     Radius.circular(12))
                                              ),
                                              child: Image.asset(
                                                "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
                                                height: SizeConfig
                                                    .safeBlockHorizontal! *
                                                    20,
                                                width: SizeConfig
                                                    .safeBlockHorizontal! *
                                                    20,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            // Image.asset(
                                            //   "${Constants.ASSETS_GIF_PATH}${exerciseDetail.image}",
                                            //   height: SizeConfig
                                            //           .safeBlockHorizontal! *
                                            //       30,
                                            //   width: SizeConfig
                                            //           .safeBlockHorizontal! *
                                            //       30,
                                            //   fit: BoxFit.fill,
                                            // ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  getCustomText(
                                                      exerciseDetail
                                                          .name!,
                                                      Colors.black87,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.bold,
                                                      17),
                                                  getExtraSmallNormalTextWithMaxLine(
                                                      "${_modelExerciseList.duration} ${S.of(context).seconds}",
                                                      Colors.grey,
                                                      1,
                                                      TextAlign.start)
                                                ],
                                              ),
                                              flex: 1,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showBottomDialog(
                                                    exerciseDetail);
                                              },
                                              padding: EdgeInsets.all(7),
                                              icon: Icon(
                                                Icons.more_vert_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showBottomDialog(exerciseDetail);
                                    },
                                  );
                                },
                              )),
                        ],
                      )
                    ],
                  ),





                ],
              ),
            )),
        // ),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }

  void showBottomDialog(ModelExerciseDetail exerciseDetail) {
    PageController controller = PageController(keepPage: true);

    YoutubePlayerController _controller = YoutubePlayerController(
      // initialVideoId:
      // YoutubePlayer.convertUrlToId(exerciseDetail.video!)!,
      // initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=ml6cT4AZdqI"),
      initialVideoId: 'ml6cT4AZdqI',
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
      backgroundColor: bgDarkWhite,
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
              //   width: double
              //       .infinity,
              //   height:
              //   SizeConfig.safeBlockVertical *
              //       40,
              //   child:
              //   Stack(
              //     children: [
              //       Image
              //           .asset(
              //         "${Constants.ASSETS_GIF_PATH}${exerciseDetail.image}",
              //         height:
              //         double.infinity,
              //         width:
              //         double.infinity,
              //         fit: BoxFit
              //             .contain,
              //       ),
              //       Align(
              //         alignment:
              //         Alignment.topRight,
              //         child:
              //         IconButton(
              //           onPressed:
              //               () {},
              //           padding:
              //           EdgeInsets.all(7),
              //           icon:
              //           Icon(
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
                    // KeepAlivePage(child:
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(children: [
                        Image.asset(
                          "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.contain,
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
                    //             initialOptions: InAppWebViewGroupOptions(
                    //                 crossPlatform: InAppWebViewOptions(
                    //               debuggingEnabled: true,
                    //             )),
                    //             onWebViewCreated:
                    //                 (InAppWebViewController controller) {
                    //               webView = controller;
                    //             },
                    //             onLoadStart: (InAppWebViewController controller,
                    //                 String url) {},
                    //             onLoadStop: (InAppWebViewController controller,
                    //                 String url) {},
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
              //     exerciseDetail
              //         .detail,
              //     textAlign:
              //     TextAlign
              //         .start,
              //     style:
              // TextStyle(
              //   fontSize:
              //   15,
              //   fontFamily:
              //   Constants
              //       .fontsFamily,
              //   fontWeight:
              //   FontWeight
              //       .normal,
              //   color: Colors
              //       .black,
              // ),
              // ),
              HtmlWidget(
                exerciseDetail.detail!,
                textStyle: TextStyle(
                    wordSpacing: 2,
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        );
      },
    );
  }

  void getallData() {
    // _dataHelper
    //     .getWorkoutExerciseListByTableAndId(
    //         widget._modelWorkoutList.id, widget._modelWorkoutList.tableName)
    //     .then((value) {
    //   _exerciseList = value;
    //   _exerciseList.forEach((price) {
    //     _dataHelper.getExerciseDetailById(price.exerciseId!).then((value1) {
    //       _exerciseDetailList.add(value1);
    //     });
    //     print("getsize==--${_exerciseList.length}");
    //     // getTime = getTime + int.parse(price.duration);
    //   });
    // });
  }
}
