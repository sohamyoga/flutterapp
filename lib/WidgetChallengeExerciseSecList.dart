import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:workout/DataFile.dart';
import 'package:workout/WidgetChallengeWorkout.dart';
import 'package:workout/customWidget/DotsIndicator.dart';
import 'package:workout/models/ModelChallengeExerciseList.dart';
import 'package:workout/models/ModelChallengesMainCat.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'generated/l10n.dart';
import 'models/ModelExerciseDetail.dart';

// ignore: must_be_immutable
class WidgetChallengeExerciseSecList extends StatefulWidget {
  // ModelWorkoutList _modelWorkoutList_modelWorkoutList;
  ModelChallengesMainCat _modelWorkoutList;
  int day, week;

  WidgetChallengeExerciseSecList(this._modelWorkoutList, this.day, this.week);

  @override
  _WidgetChallengeExerciseSecList createState() =>
      _WidgetChallengeExerciseSecList();
}

class _WidgetChallengeExerciseSecList
    extends State<WidgetChallengeExerciseSecList> {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;
  List<ModelChallengeExerciseList> _list = DataFile.getExerciseList();
  //
  List<ModelExerciseDetail> _exerciseDetailList = DataFile.getExerciseDetailList();

  List? priceList;
  // AdsFile? adsFile;

  void getallData() {
    print("getsize01=--${_list.length}--${_exerciseDetailList.length}");
    // _dataHelper
    //     .getChallengeExerciseList(
    //     widget._modelWorkoutList.id!, widget.week, widget.day)
    //     .then((value) {
    //   _list = value;
    //   print("getsize00=--${_list.length}--${_exerciseDetailList.length}");
    //
    //   _list.forEach((price) {
    //     // _listId.add(price.exercise_id);
    //     //   if (_exerciseDetailList.length == _list.length) {
    //     //     _dataHelper.getExerciseDetailByIdList(_listId).then((value1) {
    //     //       _exerciseDetailList=value1;
    //     //       print("getsize22=--${_list.length}--${_exerciseDetailList.length}");
    //     //     });
    //     //   }
    //
    //     _dataHelper.getExerciseDetailById(price.exercise_id!).then((value1) {
    //       _exerciseDetailList.add(value1);
    //       if (_exerciseDetailList.length == _list.length) {
    //         setState(() {
    //           getCal = Constants.calDefaultCalculation * getTime;
    //
    //           // setWidget();
    //         });
    //       }
    //       print("getsize22=--${_list.length}--${_exerciseDetailList.length}");
    //     });
    //     print("getsize11=--${_list.length}--${_exerciseDetailList.length}");
    //     getTime = getTime + int.parse(price.duration!);
    //   });
    // });

    setState(() {
      getTime = getTime + int.parse("10");
      getCal = Constants.calDefaultCalculation * 10;
    });


  }

  double getCal = 0;
  int getTime = 0;
  Widget? getListWidget;

  setWidget() {
    print("Getlist===${_exerciseDetailList.length}--${_list.length}");
    if (_list.length != 0 && _exerciseDetailList.length == _list.length) {
          getListWidget = Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)),
              color: Colors.white),
          child:
          ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(
                bottom: 25, top: 15),
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ModelChallengeExerciseList
              _modelExerciseList =
              _list[index];
              ModelExerciseDetail
              exerciseDetail =
              _exerciseDetailList[index];
              print(
                  "exerciseid==--${_modelExerciseList.exercise_id}");
              return InkWell(
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              7)),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 7,
                            top: 7,
                            bottom: 7,
                            right: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .black12),
                            borderRadius:
                            BorderRadius
                                .all(Radius
                                .circular(
                                12))),
                        child: Image.asset(
                          "${Constants.assetsGifPath}${exerciseDetail
                              .image}${Constants.assetsImageFormat}",
                          height: SizeConfig
                              .safeBlockHorizontal! *
                              20,
                          width: SizeConfig
                              .safeBlockHorizontal! *
                              20,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize:
                          MainAxisSize.max,
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
                                "${_modelExerciseList.duration} ${S
                                    .of(context)
                                    .seconds}",
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
                        padding:
                        EdgeInsets.all(7),
                        icon: Icon(
                          Icons
                              .more_vert_rounded,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  showBottomDialog(
                      exerciseDetail);
                },
              );
            },
          ));
    }
    else {
      getListWidget = Container(
          color: Colors.transparent,
          // width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 50,
          child: Center(child: CupertinoActivityIndicator()));
    }
  }

  @override
  void initState() {

    // Future.delayed(Duration(seconds: 1), () {
    //   adsFile = new AdsFile(context);
    //   adsFile!.createInterstitialAd();
    //
    // });


    // _calcTotal();
    // animationController = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    setWidget();
    getallData();

    // interstitialAd = AdmobInterstitial(
    //   adUnitId: AdsInfo.getInterstitialAdUnitId(),
    //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    //     if (event == AdmobAdEvent.closed) {
    //       interstitialAd!.load();
    //     }
    //     switch (event) {
    //       case AdmobAdEvent.closed:
    //         print("AD:inclosed");
    //         interstitialAd!.load();
    //         if (_list != null && _list.length > 0) {
    //           Navigator.of(context).push(MaterialPageRoute(
    //             builder: (context) {
    //               return WidgetChallengeWorkout(
    //                   _list, widget._modelWorkoutList);
    //             },
    //           ));
    //         }
    //         break;
    //       case AdmobAdEvent.rewarded:
    //         print("AD:inreward");
    //         // sendToWorkoutList(context);
    //
    //         break;
    //       case AdmobAdEvent.loaded:
    //         break;
    //       case AdmobAdEvent.failedToLoad:
    //         break;
    //       case AdmobAdEvent.clicked:
    //         break;
    //       case AdmobAdEvent.impression:
    //         break;
    //       case AdmobAdEvent.opened:
    //         break;
    //       case AdmobAdEvent.leftApplication:
    //         break;
    //       case AdmobAdEvent.completed:
    //         break;
    //       case AdmobAdEvent.started:
    //         break;
    //     }
    //     // handleEvent(event, args, 'Interstitial');
    //   },
    // );


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
  }

// void _calcTotal() async {
//   priceList = await _dataHelper.calculateTotalWorkout();
//   if (priceList != null && priceList.length > 0) {
//     getTotalWorkout = priceList.length;
//     priceList.forEach((price) {
//       getCal = getCal + price['kcal'];
//     });
//     print("getval=$getCal");
//     getTime = getTotalWorkout * 2;
//     setState(() {});
//   }
//   // var total = (await _dataHelper.calculateTotalWorkout())[0]['Total'];
//   // print("etcal=$total");
//   // setState(() {
//   //   getCal = total;
//   // });
// }

  @override
  void dispose() {
    // disposeBannerAd(adsFile);
    // disposeInterstitialAd(adsFile);
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    super.dispose();
  }

  Future<void> share() async {
    Share.share(S
        .of(context)
        .app_name, subject: S
        .of(context)
        .app_name);
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
    double screenHeight=SizeConfig.safeBlockVertical!*100;


    //
    // if (!_loadingAnchoredBanner) {
    //   _loadingAnchoredBanner = true;
    //   adsFile = new AdsFile(context);
    //   adsFile!.createAnchoredBanner(context, () {
    //     setState(() {});
    //   }, setState);
    // }


    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
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
                                    widget._modelWorkoutList.background!),
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

                            width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: Constants.getScreenPercentSize(context,1.5)),
                              margin: EdgeInsets.only(
                                  top: Constants.getPercentSize(
                                      screenHeight, 40),left: Constants.getWidthPercentSize(context,10),
                                  right: Constants.getWidthPercentSize(context, 10)),
                              // width: double.infinity,
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
                                                      return WidgetChallengeWorkout(
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

                          Container(

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
                                        widget._modelWorkoutList.title!,
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
                          ),

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
                                itemCount: _list.length,
                                padding:
                                EdgeInsets.only(bottom: 25, top: 15),
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  ModelChallengeExerciseList
                                  _modelExerciseList =
                                  _list[index];
                                  print(
                                      "exerciseid==--${_modelExerciseList.exercise_id}");


                                  ModelExerciseDetail
                                                                    exerciseDetail = _exerciseDetailList[index];

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


    //       Column(
    //         children: [
    //           Expanded(
    //             child: Container(
    //               width: double.infinity,
    //               height: double.infinity,
    //               color: greyWhite,
    //               child: Stack(
    //                 children: [
    //                   Column(
    //                     children: [
    //                       Container(
    //                         width:double.infinity ,
    //                         height: Constants.getPercentSize(screenHeight,50),
    //                         decoration: BoxDecoration(image: DecorationImage(image:
    //                         AssetImage(Constants.assetsImagePath+widget._modelWorkoutList.background!),fit: BoxFit.cover)),
    //                         child: Container(
    //                           width: double.infinity,
    //                           height: double.infinity,
    //                           color: Colors.black45,
    //                         ),
    //                       ),
    //                       // Image.asset(Constants.assetsImagePath+widget._modelWorkoutList.image,fit: BoxFit.cover,width: ,
    //                       // height:,
    //                       // ),
    //                       Expanded(child:Container(color: Colors.white,width: double.infinity,height: double.infinity,),flex: 1,)
    //                     ],
    //                   ),
    //               SafeArea(child: Column(
    //                 children: <Widget>[
    //                   AnimatedContainer(
    //                     height: _showAppbar ? 56.0 : 0.0,
    //                     duration: Duration(milliseconds: 200),
    //                     child: AppBar(
    //                       backgroundColor: Colors.transparent,
    //                       iconTheme: IconThemeData(color: Colors.white),
    //                       elevation: 0,
    //                       automaticallyImplyLeading: false,
    //                       leading: IconButton(
    //                           icon: Icon(
    //                             Icons.arrow_back_ios,
    //                             color: Colors.white,
    //                           ),
    //                           onPressed: () {
    //                             onBackClicked();
    //                           }),
    //                       actions: <Widget>[
    //                         PopupMenuButton<String>(
    //                           onSelected: handleClick,
    //                           itemBuilder: (BuildContext context) {
    //                             return {'Share'}.map((String choice) {
    //                               return PopupMenuItem<String>(
    //                                 value: choice,
    //                                 child: Text(choice),
    //                               );
    //                             }).toList();
    //                           },
    //                         )
    //                         //add buttons here
    //                       ],
    //                     ),
    //                   ),
    //                   Expanded(
    //                     child: SingleChildScrollView(
    //                       controller: _scrollViewController,
    //                       child: Column(
    //                         children: <Widget>[
    //                           Hero(
    //                               tag: widget._modelWorkoutList.id!,
    //                               child: Container(
    //                                 width: double.infinity,
    //                                 padding: EdgeInsets.all(10),
    //                                 height:
    //                                 SizeConfig.safeBlockVertical! * 22,
    //                                 color: Colors.transparent,
    //                                 // color: greyWhite,
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                   CrossAxisAlignment.start,
    //                                   children: [
    //                                     Expanded(
    //                                       child: Padding(
    //                                         padding: EdgeInsets.only(
    //                                           left: 7,
    //                                         ),
    //                                         child: Align(
    //                                             alignment:
    //                                             Alignment.centerLeft,
    //                                             child:
    //                                             getMediumBoldTextWithMaxLine(
    //                                               widget._modelWorkoutList
    //                                                   .title!,
    //                                               Colors.white,
    //                                               1,
    //                                             )),
    //                                       ),
    //                                       flex: 1,
    //                                     ),
    //                                     Card(
    //                                       color: darkGrey,
    //                                       shape: RoundedRectangleBorder(
    //                                           borderRadius:
    //                                           BorderRadius.circular(
    //                                               15)),
    //                                       child: Padding(
    //                                         padding: EdgeInsets.only(
    //                                             left: 10,
    //                                             right: 10,
    //                                             top: 3,
    //                                             bottom: 3),
    //                                         child: getCustomText(
    //                                             S
    //                                                 .of(context)
    //                                                 .transformation,
    //                                             Colors.black87,
    //                                             1,
    //                                             TextAlign.start,
    //                                             FontWeight.w600,
    //                                             15),
    //                                       ),
    //                                     ),
    //                                     SizedBox(
    //                                       height: 7,
    //                                     ),
    //                                     Row(
    //                                       children: [
    //                                         Expanded(
    //                                           child: RichText(
    //                                             textAlign: TextAlign.center,
    //                                             text: TextSpan(
    //                                               children: [
    //                                                 WidgetSpan(
    //                                                   child: Icon(
    //                                                       Icons.whatshot,
    //                                                       size: 20,color: Colors.white,),
    //                                                 ),
    //                                                 WidgetSpan(
    //                                                     child: SizedBox(
    //                                                       width: 10,
    //                                                     )),
    //                                                 TextSpan(
    //                                                     text:
    //                                                     "${Constants.calFormatter
    //                                                         .format(
    //                                                         getCal)} kcal",
    //                                                     style: TextStyle(
    //                                                         color: Colors
    //                                                             .white,
    //                                                         fontFamily:
    //                                                         Constants
    //                                                             .fontsFamily,
    //                                                         fontSize: 15,
    //                                                         fontWeight:
    //                                                         FontWeight
    //                                                             .w600)),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                           flex: 1,
    //                                         ),
    //                                         Expanded(
    //                                           child: RichText(
    //                                             textAlign: TextAlign.center,
    //                                             text: TextSpan(
    //                                               children: [
    //                                                 WidgetSpan(
    //                                                   child: Icon(
    //                                                       Icons.timer,
    //                                                       size: 20,color: Colors.white,),
    //                                                 ),
    //                                                 WidgetSpan(
    //                                                     child: SizedBox(
    //                                                       width: 10,
    //                                                     )),
    //                                                 TextSpan(
    //                                                     text:
    //                                                     "${Constants.getTimeFromSec(
    //                                                         getTime)}",
    //                                                     style: TextStyle(
    //                                                         color: Colors
    //                                                             .white,
    //                                                         fontFamily:
    //                                                         Constants
    //                                                             .fontsFamily,
    //                                                         fontSize: 15,
    //                                                         fontWeight:
    //                                                         FontWeight
    //                                                             .w600)),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                           flex: 1,
    //                                         )
    //                                       ],
    //                                     ),
    //                                     SizedBox(
    //                                       height: 7,
    //                                     )
    //                                   ],
    //                                 ),
    //                               )),
    //                           (_list.length != 0 && _exerciseDetailList.length == _list.length)?Container(
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.only(
    //                                       topLeft: Radius.circular(30),
    //                                       topRight: Radius.circular(30)),
    //                                   color: Colors.white),
    //                               child:
    //                               ListView.builder(
    //                                 itemCount: _list.length,
    //                                 padding: EdgeInsets.only(
    //                                     bottom: 25, top: 15),
    //                                 primary: false,
    //                                 shrinkWrap: true,
    //                                 itemBuilder: (context, index) {
    //                                   ModelChallengeExerciseList
    //                                   _modelExerciseList =
    //                                   _list[index];
    //                                   ModelExerciseDetail
    //                                   exerciseDetail =
    //                                   _exerciseDetailList[index];
    //                                   print(
    //                                       "exerciseid==--${_modelExerciseList.exercise_id}");
    //                                   return InkWell(
    //                                     child: Container(
    //                                       margin: EdgeInsets.all(5),
    //                                       padding: EdgeInsets.all(5),
    //                                       decoration: BoxDecoration(
    //                                           borderRadius:
    //                                           BorderRadius.all(
    //                                               Radius.circular(
    //                                                   7)),
    //                                           color: Colors.white),
    //                                       child: Row(
    //                                         mainAxisAlignment:
    //                                         MainAxisAlignment
    //                                             .center,
    //                                         crossAxisAlignment:
    //                                         CrossAxisAlignment
    //                                             .center,
    //                                         children: [
    //                                           Container(
    //                                             margin: EdgeInsets.only(
    //                                                 left: 7,
    //                                                 top: 7,
    //                                                 bottom: 7,
    //                                                 right: 15),
    //                                             decoration: BoxDecoration(
    //                                                 border: Border.all(
    //                                                     width: 1,
    //                                                     color: Colors
    //                                                         .black12),
    //                                                 borderRadius:
    //                                                 BorderRadius
    //                                                     .all(Radius
    //                                                     .circular(
    //                                                     12))),
    //                                             child: Image.asset(
    //                                               "${Constants.assetsGifPath}${exerciseDetail
    //                                                   .image}${Constants.assetsImageFormat}",
    //                                               height: SizeConfig
    //                                                   .safeBlockHorizontal! *
    //                                                   20,
    //                                               width: SizeConfig
    //                                                   .safeBlockHorizontal! *
    //                                                   20,
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                           Expanded(
    //                                             child: Column(
    //                                               mainAxisSize:
    //                                               MainAxisSize.max,
    //                                               mainAxisAlignment:
    //                                               MainAxisAlignment
    //                                                   .center,
    //                                               crossAxisAlignment:
    //                                               CrossAxisAlignment
    //                                                   .start,
    //                                               children: [
    //                                                 getCustomText(
    //                                                     exerciseDetail
    //                                                         .name!,
    //                                                     Colors.black87,
    //                                                     1,
    //                                                     TextAlign.start,
    //                                                     FontWeight.bold,
    //                                                     17),
    //                                                 getExtraSmallNormalTextWithMaxLine(
    //                                                     "${_modelExerciseList.duration} ${S
    //                                                         .of(context)
    //                                                         .seconds}",
    //                                                     Colors.grey,
    //                                                     1,
    //                                                     TextAlign.start)
    //                                               ],
    //                                             ),
    //                                             flex: 1,
    //                                           ),
    //                                           IconButton(
    //                                             onPressed: () {
    //                                               showBottomDialog(
    //                                                   exerciseDetail);
    //                                             },
    //                                             padding:
    //                                             EdgeInsets.all(7),
    //                                             icon: Icon(
    //                                               Icons
    //                                                   .more_vert_rounded,
    //                                               color: Colors.black,
    //                                             ),
    //                                           )
    //                                         ],
    //                                       ),
    //                                     ),
    //                                     onTap: () {
    //                                       showBottomDialog(
    //                                           exerciseDetail);
    //                                     },
    //                                   );
    //                                 },
    //                               )):Container(
    //                               color: Colors.transparent,
    //                               // width: double.infinity,
    //                               height: SizeConfig.safeBlockVertical! * 50,
    //                               child: Center(child: CupertinoActivityIndicator())),
    //                           // FutureBuilder<
    //                           //     List<ModelChallengeExerciseList>>(
    //                           //   future: _dataHelper
    //                           //       .getChallengeExerciseList(
    //                           //           widget._modelWorkoutList.id,
    //                           //           widget.week,
    //                           //           widget.day),
    //                           //   builder: (context, snapshot) {
    //                           //     print(
    //                           //         "datasize===${snapshot.hasData}---${widget._modelWorkoutList.id}");
    //                           //     if (snapshot.hasData) {
    //                           //       _list = snapshot.data;
    //                           //       List<ModelChallengeExerciseList>
    //                           //           _exerciseList = snapshot.data;
    //                           //       // print("workoutlistsize===${_exerciseList.length}");
    //                           //       return ListView.builder(
    //                           //         itemCount: _exerciseList.length,
    //                           //         padding: EdgeInsets.only(
    //                           //             bottom: 25, top: 15),
    //                           //         primary: false,
    //                           //         shrinkWrap: true,
    //                           //         itemBuilder: (context, index) {
    //                           //           ModelChallengeExerciseList
    //                           //               _modelExerciseList =
    //                           //               _exerciseList[index];
    //                           //           print(
    //                           //               "exerciseid==--${_modelExerciseList.exercise_id}");
    //                           //           return FutureBuilder<
    //                           //               ModelExerciseDetail>(
    //                           //             future: _dataHelper
    //                           //                 .getExerciseDetailById(
    //                           //                     _modelExerciseList
    //                           //                         .exercise_id),
    //                           //             builder:
    //                           //                 (context, snapshot) {
    //                           //               ModelExerciseDetail
    //                           //                   exerciseDetail =
    //                           //                   snapshot.data;
    //                           //               // print(
    //                           //               //     "getDatas==--${exerciseDetail.image}");
    //                           //               if (snapshot.hasData) {
    //                           //                 return InkWell(
    //                           //                   child: Container(
    //                           //                     margin:
    //                           //                         EdgeInsets.all(
    //                           //                             5),
    //                           //                     padding:
    //                           //                         EdgeInsets.all(
    //                           //                             5),
    //                           //                     decoration: BoxDecoration(
    //                           //                         borderRadius: BorderRadius
    //                           //                             .all(Radius
    //                           //                                 .circular(
    //                           //                                     7)),
    //                           //                         color: Colors
    //                           //                             .white),
    //                           //                     child: Row(
    //                           //                       mainAxisAlignment:
    //                           //                           MainAxisAlignment
    //                           //                               .start,
    //                           //                       children: [
    //                           //                         Container(
    //                           //                           margin: EdgeInsets
    //                           //                               .only(
    //                           //                                   left:
    //                           //                                       7,
    //                           //                                   top:
    //                           //                                       7,
    //                           //                                   bottom:
    //                           //                                       7,
    //                           //                                   right:
    //                           //                                       15),
    //                           //                           decoration: BoxDecoration(
    //                           //                               border: Border.all(
    //                           //                                   width:
    //                           //                                       1,
    //                           //                                   color: Colors
    //                           //                                       .black12),
    //                           //                               borderRadius:
    //                           //                                   BorderRadius.all(
    //                           //                                       Radius.circular(12))),
    //                           //                           child: Image
    //                           //                               .asset(
    //                           //                             "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
    //                           //                             height:
    //                           //                                 SizeConfig.safeBlockHorizontal! *
    //                           //                                     20,
    //                           //                             width: SizeConfig
    //                           //                                     .safeBlockHorizontal! *
    //                           //                                 20,
    //                           //                             fit: BoxFit
    //                           //                                 .contain,
    //                           //                           ),
    //                           //                         ),
    //                           //                         Expanded(
    //                           //                           child: Column(
    //                           //                             mainAxisAlignment:
    //                           //                                 MainAxisAlignment
    //                           //                                     .center,
    //                           //                             crossAxisAlignment:
    //                           //                                 CrossAxisAlignment
    //                           //                                     .start,
    //                           //                             children: [
    //                           //                               getSmallBoldTextWithMaxLine(
    //                           //                                   exerciseDetail
    //                           //                                       .name,
    //                           //                                   Colors
    //                           //                                       .black87,
    //                           //                                   1),
    //                           //                               getExtraSmallNormalTextWithMaxLine(
    //                           //                                   "${_modelExerciseList.duration} ${S.of(context).seconds}",
    //                           //                                   Colors
    //                           //                                       .grey,
    //                           //                                   1,
    //                           //                                   TextAlign
    //                           //                                       .start)
    //                           //                             ],
    //                           //                           ),
    //                           //                           flex: 1,
    //                           //                         ),
    //                           //                         IconButton(
    //                           //                           onPressed:
    //                           //                               () {
    //                           //                             showBottomDialog(
    //                           //                                 exerciseDetail);
    //                           //                           },
    //                           //                           padding:
    //                           //                               EdgeInsets
    //                           //                                   .all(
    //                           //                                       7),
    //                           //                           icon: Icon(
    //                           //                             Icons
    //                           //                                 .more_vert_rounded,
    //                           //                             color: Colors
    //                           //                                 .black,
    //                           //                           ),
    //                           //                         )
    //                           //                       ],
    //                           //                     ),
    //                           //                   ),
    //                           //                   onTap: () {
    //                           //                     showBottomDialog(
    //                           //                         exerciseDetail);
    //                           //                   },
    //                           //                 );
    //                           //               } else {
    //                           //                 return getProgressDialog();
    //                           //               }
    //                           //             },
    //                           //           );
    //                           //         },
    //                           //       );
    //                           //     } else {
    //                           //       return getProgressDialog();
    //                           //     }
    //                           //   },
    //                           // ),
    //                           // )
    //
    //                           //add your screen content here
    //                         ],
    //                       ),
    //                     ),
    //                     //     FutureBuilder<List<ModelChallengeExerciseList>>(
    //                     //   future: _dataHelper.getChallengeExerciseList(
    //                     //       widget._modelWorkoutList.id,
    //                     //       widget.week,
    //                     //       widget.day),
    //                     //   builder: (context, snapshot) {
    //                     //     List<ModelChallengeExerciseList> _exerciseList;
    //                     //     double getCal = 0;
    //                     //     int getTime = 0;
    //                     //     if (snapshot.hasData) {
    //                     //       _list = snapshot.data;
    //                     //       _exerciseList = snapshot.data;
    //                     //       _exerciseList.forEach((price) {
    //                     //         getTime =
    //                     //             getTime + int.parse(price.duration);
    //                     //       });
    //                     //       getCal = Constants.calDefaultCalculation * getTime;
    //                     //     }
    //                     //     return SingleChildScrollView(
    //                     //       controller: _scrollViewController,
    //                     //       child: Column(
    //                     //         children: <Widget>[
    //                     //           Hero(
    //                     //               tag: widget._modelWorkoutList.id,
    //                     //               child: Container(
    //                     //                 width: double.infinity,
    //                     //                 padding: EdgeInsets.all(10),
    //                     //                 height:
    //                     //                     SizeConfig.safeBlockVertical *
    //                     //                         22,
    //                     //                 color: greyWhite,
    //                     //                 // color: greyWhite,
    //                     //                 child: Column(
    //                     //                   crossAxisAlignment:
    //                     //                       CrossAxisAlignment.start,
    //                     //                   children: [
    //                     //                     Expanded(
    //                     //                       child: Padding(
    //                     //                         padding: EdgeInsets.only(
    //                     //                           left: 7,
    //                     //                         ),
    //                     //                         child: Align(
    //                     //                             alignment: Alignment
    //                     //                                 .centerLeft,
    //                     //                             child:
    //                     //                                 getMediumBoldTextWithMaxLine(
    //                     //                               widget
    //                     //                                   ._modelWorkoutList
    //                     //                                   .title,
    //                     //                               Colors.black,
    //                     //                               1,
    //                     //                             )),
    //                     //                       ),
    //                     //                       flex: 1,
    //                     //                     ),
    //                     //                     Card(
    //                     //                       color: darkGrey,
    //                     //                       shape: RoundedRectangleBorder(
    //                     //                           borderRadius:
    //                     //                               BorderRadius.circular(
    //                     //                                   15)),
    //                     //                       child: Padding(
    //                     //                         padding: EdgeInsets.only(
    //                     //                             left: 10,
    //                     //                             right: 10,
    //                     //                             top: 3,
    //                     //                             bottom: 3),
    //                     //                         child: getCustomText(
    //                     //                             S
    //                     //                                 .of(context)
    //                     //                                 .transformation,
    //                     //                             Colors.black87,
    //                     //                             1,
    //                     //                             TextAlign.start,
    //                     //                             FontWeight.w600,
    //                     //                             15),
    //                     //                       ),
    //                     //                     ),
    //                     //                     SizedBox(
    //                     //                       height: 7,
    //                     //                     ),
    //                     //                     Row(
    //                     //                       children: [
    //                     //                         Expanded(
    //                     //                           child: RichText(
    //                     //                             textAlign:
    //                     //                                 TextAlign.center,
    //                     //                             text: TextSpan(
    //                     //                               children: [
    //                     //                                 WidgetSpan(
    //                     //                                   child: Icon(
    //                     //                                       Icons
    //                     //                                           .whatshot,
    //                     //                                       size: 20),
    //                     //                                 ),
    //                     //                                 WidgetSpan(
    //                     //                                     child: SizedBox(
    //                     //                                   width: 10,
    //                     //                                 )),
    //                     //                                 TextSpan(
    //                     //                                     text:
    //                     //                                         "${Constants.calFormatter.format(getCal)} kcal",
    //                     //                                     style: TextStyle(
    //                     //                                         color: Colors
    //                     //                                             .black87,
    //                     //                                         fontFamily:
    //                     //                                             Constants
    //                     //                                                 .fontsFamily,
    //                     //                                         fontSize:
    //                     //                                             15,
    //                     //                                         fontWeight:
    //                     //                                             FontWeight
    //                     //                                                 .w600)),
    //                     //                               ],
    //                     //                             ),
    //                     //                           ),
    //                     //                           flex: 1,
    //                     //                         ),
    //                     //                         Expanded(
    //                     //                           child: RichText(
    //                     //                             textAlign:
    //                     //                                 TextAlign.center,
    //                     //                             text: TextSpan(
    //                     //                               children: [
    //                     //                                 WidgetSpan(
    //                     //                                   child: Icon(
    //                     //                                       Icons.timer,
    //                     //                                       size: 20),
    //                     //                                 ),
    //                     //                                 WidgetSpan(
    //                     //                                     child: SizedBox(
    //                     //                                   width: 10,
    //                     //                                 )),
    //                     //                                 TextSpan(
    //                     //                                     text:
    //                     //                                         "${Constants.getTimeFromSec(getTime)}",
    //                     //                                     style: TextStyle(
    //                     //                                         color: Colors
    //                     //                                             .black87,
    //                     //                                         fontFamily:
    //                     //                                             Constants
    //                     //                                                 .fontsFamily,
    //                     //                                         fontSize:
    //                     //                                             15,
    //                     //                                         fontWeight:
    //                     //                                             FontWeight
    //                     //                                                 .w600)),
    //                     //                               ],
    //                     //                             ),
    //                     //                           ),
    //                     //                           flex: 1,
    //                     //                         )
    //                     //                       ],
    //                     //                     ),
    //                     //                     SizedBox(
    //                     //                       height: 7,
    //                     //                     )
    //                     //                   ],
    //                     //                 ),
    //                     //               )),
    //                     //           Container(
    //                     //             decoration: BoxDecoration(
    //                     //                 borderRadius: BorderRadius.only(
    //                     //                     topLeft: Radius.circular(30),
    //                     //                     topRight: Radius.circular(30)),
    //                     //                 color: Colors.white),
    //                     //             child: (snapshot.hasData)
    //                     //                 ? ListView.builder(
    //                     //                     itemCount: _exerciseList.length,
    //                     //                     padding: EdgeInsets.only(
    //                     //                         bottom: 25, top: 15),
    //                     //                     primary: false,
    //                     //                     shrinkWrap: true,
    //                     //                     itemBuilder: (context, index) {
    //                     //                       ModelChallengeExerciseList
    //                     //                           _modelExerciseList =
    //                     //                           _exerciseList[index];
    //                     //                       print(
    //                     //                           "exerciseid==--${_modelExerciseList.exercise_id}");
    //                     //                       return FutureBuilder<
    //                     //                           ModelExerciseDetail>(
    //                     //                         future: _dataHelper
    //                     //                             .getExerciseDetailById(
    //                     //                                 _modelExerciseList
    //                     //                                     .exercise_id),
    //                     //                         builder:
    //                     //                             (context, snapshot) {
    //                     //                           ModelExerciseDetail
    //                     //                               exerciseDetail =
    //                     //                               snapshot.data;
    //                     //                           // print(
    //                     //                           //     "getDatas==--${exerciseDetail.image}");
    //                     //                           if (snapshot.hasData) {
    //                     //                             return InkWell(
    //                     //                               child: Container(
    //                     //                                 margin:
    //                     //                                     EdgeInsets.all(
    //                     //                                         5),
    //                     //                                 padding:
    //                     //                                     EdgeInsets.all(
    //                     //                                         5),
    //                     //                                 decoration: BoxDecoration(
    //                     //                                     borderRadius: BorderRadius
    //                     //                                         .all(Radius
    //                     //                                             .circular(
    //                     //                                                 7)),
    //                     //                                     color: Colors
    //                     //                                         .white),
    //                     //                                 child: Row(
    //                     //                                   mainAxisAlignment:
    //                     //                                       MainAxisAlignment
    //                     //                                           .center,
    //                     //                                   crossAxisAlignment:
    //                     //                                       CrossAxisAlignment
    //                     //                                           .center,
    //                     //                                   children: [
    //                     //                                     Container(
    //                     //                                       margin: EdgeInsets
    //                     //                                           .only(
    //                     //                                               left:
    //                     //                                                   7,
    //                     //                                               top:
    //                     //                                                   7,
    //                     //                                               bottom:
    //                     //                                                   7,
    //                     //                                               right:
    //                     //                                                   15),
    //                     //                                       decoration: BoxDecoration(
    //                     //                                           border: Border.all(
    //                     //                                               width:
    //                     //                                                   1,
    //                     //                                               color: Colors
    //                     //                                                   .black12),
    //                     //                                           borderRadius:
    //                     //                                               BorderRadius.all(
    //                     //                                                   Radius.circular(12))),
    //                     //                                       child: Image
    //                     //                                           .asset(
    //                     //                                         "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
    //                     //                                         height:
    //                     //                                             SizeConfig.safeBlockHorizontal! *
    //                     //                                                 20,
    //                     //                                         width: SizeConfig
    //                     //                                                 .safeBlockHorizontal! *
    //                     //                                             20,
    //                     //                                         fit: BoxFit
    //                     //                                             .contain,
    //                     //                                       ),
    //                     //                                     ),
    //                     //                                     Expanded(
    //                     //                                       child: Column(
    //                     //                                         mainAxisSize:
    //                     //                                             MainAxisSize
    //                     //                                                 .max,
    //                     //                                         mainAxisAlignment:
    //                     //                                             MainAxisAlignment
    //                     //                                                 .center,
    //                     //                                         crossAxisAlignment:
    //                     //                                             CrossAxisAlignment
    //                     //                                                 .start,
    //                     //                                         children: [
    //                     //                                           getCustomText(
    //                     //                                               exerciseDetail
    //                     //                                                   .name,
    //                     //                                               Colors
    //                     //                                                   .black87,
    //                     //                                               1,
    //                     //                                               TextAlign
    //                     //                                                   .start,
    //                     //                                               FontWeight
    //                     //                                                   .bold,
    //                     //                                               17),
    //                     //                                           getExtraSmallNormalTextWithMaxLine(
    //                     //                                               "${_modelExerciseList.duration} ${S.of(context).seconds}",
    //                     //                                               Colors
    //                     //                                                   .grey,
    //                     //                                               1,
    //                     //                                               TextAlign
    //                     //                                                   .start)
    //                     //                                         ],
    //                     //                                       ),
    //                     //                                       flex: 1,
    //                     //                                     ),
    //                     //                                     IconButton(
    //                     //                                       onPressed:
    //                     //                                           () {
    //                     //                                         showBottomDialog(
    //                     //                                             exerciseDetail);
    //                     //                                       },
    //                     //                                       padding:
    //                     //                                           EdgeInsets
    //                     //                                               .all(
    //                     //                                                   7),
    //                     //                                       icon: Icon(
    //                     //                                         Icons
    //                     //                                             .more_vert_rounded,
    //                     //                                         color: Colors
    //                     //                                             .black,
    //                     //                                       ),
    //                     //                                     )
    //                     //                                   ],
    //                     //                                 ),
    //                     //                               ),
    //                     //                               onTap: () {
    //                     //                                 showBottomDialog(
    //                     //                                     exerciseDetail);
    //                     //                               },
    //                     //                             );
    //                     //                           } else {
    //                     //                             return getProgressDialog();
    //                     //                           }
    //                     //                         },
    //                     //                       );
    //                     //                     },
    //                     //                   )
    //                     //                 : getProgressDialog(),
    //                     //             // FutureBuilder<
    //                     //             //     List<ModelChallengeExerciseList>>(
    //                     //             //   future: _dataHelper
    //                     //             //       .getChallengeExerciseList(
    //                     //             //           widget._modelWorkoutList.id,
    //                     //             //           widget.week,
    //                     //             //           widget.day),
    //                     //             //   builder: (context, snapshot) {
    //                     //             //     print(
    //                     //             //         "datasize===${snapshot.hasData}---${widget._modelWorkoutList.id}");
    //                     //             //     if (snapshot.hasData) {
    //                     //             //       _list = snapshot.data;
    //                     //             //       List<ModelChallengeExerciseList>
    //                     //             //           _exerciseList = snapshot.data;
    //                     //             //       // print("workoutlistsize===${_exerciseList.length}");
    //                     //             //       return ListView.builder(
    //                     //             //         itemCount: _exerciseList.length,
    //                     //             //         padding: EdgeInsets.only(
    //                     //             //             bottom: 25, top: 15),
    //                     //             //         primary: false,
    //                     //             //         shrinkWrap: true,
    //                     //             //         itemBuilder: (context, index) {
    //                     //             //           ModelChallengeExerciseList
    //                     //             //               _modelExerciseList =
    //                     //             //               _exerciseList[index];
    //                     //             //           print(
    //                     //             //               "exerciseid==--${_modelExerciseList.exercise_id}");
    //                     //             //           return FutureBuilder<
    //                     //             //               ModelExerciseDetail>(
    //                     //             //             future: _dataHelper
    //                     //             //                 .getExerciseDetailById(
    //                     //             //                     _modelExerciseList
    //                     //             //                         .exercise_id),
    //                     //             //             builder:
    //                     //             //                 (context, snapshot) {
    //                     //             //               ModelExerciseDetail
    //                     //             //                   exerciseDetail =
    //                     //             //                   snapshot.data;
    //                     //             //               // print(
    //                     //             //               //     "getDatas==--${exerciseDetail.image}");
    //                     //             //               if (snapshot.hasData) {
    //                     //             //                 return InkWell(
    //                     //             //                   child: Container(
    //                     //             //                     margin:
    //                     //             //                         EdgeInsets.all(
    //                     //             //                             5),
    //                     //             //                     padding:
    //                     //             //                         EdgeInsets.all(
    //                     //             //                             5),
    //                     //             //                     decoration: BoxDecoration(
    //                     //             //                         borderRadius: BorderRadius
    //                     //             //                             .all(Radius
    //                     //             //                                 .circular(
    //                     //             //                                     7)),
    //                     //             //                         color: Colors
    //                     //             //                             .white),
    //                     //             //                     child: Row(
    //                     //             //                       mainAxisAlignment:
    //                     //             //                           MainAxisAlignment
    //                     //             //                               .start,
    //                     //             //                       children: [
    //                     //             //                         Container(
    //                     //             //                           margin: EdgeInsets
    //                     //             //                               .only(
    //                     //             //                                   left:
    //                     //             //                                       7,
    //                     //             //                                   top:
    //                     //             //                                       7,
    //                     //             //                                   bottom:
    //                     //             //                                       7,
    //                     //             //                                   right:
    //                     //             //                                       15),
    //                     //             //                           decoration: BoxDecoration(
    //                     //             //                               border: Border.all(
    //                     //             //                                   width:
    //                     //             //                                       1,
    //                     //             //                                   color: Colors
    //                     //             //                                       .black12),
    //                     //             //                               borderRadius:
    //                     //             //                                   BorderRadius.all(
    //                     //             //                                       Radius.circular(12))),
    //                     //             //                           child: Image
    //                     //             //                               .asset(
    //                     //             //                             "${Constants.assetsGifPath}${exerciseDetail.image}${Constants.assetsImageFormat}",
    //                     //             //                             height:
    //                     //             //                                 SizeConfig.safeBlockHorizontal! *
    //                     //             //                                     20,
    //                     //             //                             width: SizeConfig
    //                     //             //                                     .safeBlockHorizontal! *
    //                     //             //                                 20,
    //                     //             //                             fit: BoxFit
    //                     //             //                                 .contain,
    //                     //             //                           ),
    //                     //             //                         ),
    //                     //             //                         Expanded(
    //                     //             //                           child: Column(
    //                     //             //                             mainAxisAlignment:
    //                     //             //                                 MainAxisAlignment
    //                     //             //                                     .center,
    //                     //             //                             crossAxisAlignment:
    //                     //             //                                 CrossAxisAlignment
    //                     //             //                                     .start,
    //                     //             //                             children: [
    //                     //             //                               getSmallBoldTextWithMaxLine(
    //                     //             //                                   exerciseDetail
    //                     //             //                                       .name,
    //                     //             //                                   Colors
    //                     //             //                                       .black87,
    //                     //             //                                   1),
    //                     //             //                               getExtraSmallNormalTextWithMaxLine(
    //                     //             //                                   "${_modelExerciseList.duration} ${S.of(context).seconds}",
    //                     //             //                                   Colors
    //                     //             //                                       .grey,
    //                     //             //                                   1,
    //                     //             //                                   TextAlign
    //                     //             //                                       .start)
    //                     //             //                             ],
    //                     //             //                           ),
    //                     //             //                           flex: 1,
    //                     //             //                         ),
    //                     //             //                         IconButton(
    //                     //             //                           onPressed:
    //                     //             //                               () {
    //                     //             //                             showBottomDialog(
    //                     //             //                                 exerciseDetail);
    //                     //             //                           },
    //                     //             //                           padding:
    //                     //             //                               EdgeInsets
    //                     //             //                                   .all(
    //                     //             //                                       7),
    //                     //             //                           icon: Icon(
    //                     //             //                             Icons
    //                     //             //                                 .more_vert_rounded,
    //                     //             //                             color: Colors
    //                     //             //                                 .black,
    //                     //             //                           ),
    //                     //             //                         )
    //                     //             //                       ],
    //                     //             //                     ),
    //                     //             //                   ),
    //                     //             //                   onTap: () {
    //                     //             //                     showBottomDialog(
    //                     //             //                         exerciseDetail);
    //                     //             //                   },
    //                     //             //                 );
    //                     //             //               } else {
    //                     //             //                 return getProgressDialog();
    //                     //             //               }
    //                     //             //             },
    //                     //             //           );
    //                     //             //         },
    //                     //             //       );
    //                     //             //     } else {
    //                     //             //       return getProgressDialog();
    //                     //             //     }
    //                     //             //   },
    //                     //             // ),
    //                     //           )
    //                     //
    //                     //           //add your screen content here
    //                     //         ],
    //                     //       ),
    //                     //     );
    //                     //   },
    //                     // ),
    //                   ),
    //                 ],
    //               ))
    //               ,
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Container(
    //           margin: EdgeInsets.all(7),
    //           width: SizeConfig.safeBlockHorizontal! *  55,
    //           child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               onPrimary: greenButton,
    //               textStyle: TextStyle(
    //                 color: Colors.white,
    //               ),
    //               padding: EdgeInsets.only(top: 12, bottom: 12),
    //               shape: RoundedRectangleBorder(
    //                   borderRadius:
    //                   BorderRadius.all(Radius.circular(7.0))
    //             ),),
    //
    //             // shape: RoundedRectangleBorder(
    //             //     borderRadius:
    //             //     BorderRadius.all(Radius.circular(7.0))),
    //             // shape: RoundedRectangleBorder(
    //             //     borderRadius:
    //             //         BorderRadius.all(Radius.circular(20.0))),
    //             onPressed: () async {
    //
    //
    //               // showInterstitialAd(adsFile, () {
    //               //     if (_list != null && _list.length > 0) {
    //               //       Navigator.of(context).push(MaterialPageRoute(
    //               //         builder: (context) {
    //               //           return WidgetChallengeWorkout(
    //               //               _list, widget._modelWorkoutList);
    //               //         },
    //               //       ));
    //               //     }
    //               // });
    //
    //
    //               if (_list != null && _list.length > 0) {
    //                 Navigator.of(context).push(MaterialPageRoute(
    //                   builder: (context) {
    //                     return WidgetChallengeWorkout(
    //                         _list, widget._modelWorkoutList);
    //                   },
    //                 ));
    //               }
    //
    //               // if (await interstitialAd!.isLoaded) {
    //               //   await Admob.requestTrackingAuthorization();
    //               //   interstitialAd!.show();
    //               // } else {
    //               //   if (_list != null && _list.length > 0) {
    //               //     Navigator.of(context).push(MaterialPageRoute(
    //               //       builder: (context) {
    //               //         return WidgetChallengeWorkout(
    //               //             _list, widget._modelWorkoutList);
    //               //       },
    //               //     ));
    //               //   }
    //               // }
    //             },
    //
    //
    //             // padding: EdgeInsets.all(5),
    //
    //             child: getCustomText("START WORKOUT", Colors.white,
    //                 1, TextAlign.center, FontWeight.w600, 17),
    //
    //             // child: Padding(
    //             //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //             // child: Row(
    //             //   mainAxisAlignment: MainAxisAlignment.center,
    //             //   crossAxisAlignment: CrossAxisAlignment.center,
    //             //   children: <Widget>[
    //             //     Container(
    //             //       color: greenButton,
    //             //       padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
    //             //       child: getSmallBoldTextWithMaxLine(
    //             //           "START", Colors.black, 1),
    //             //     ),
    //             //     Padding(
    //             //       padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
    //             //       child: Icon(
    //             //         Icons.chevron_right,
    //             //         color: Colors.black,
    //             //         size: 30,
    //             //       ),
    //             //     ),
    //             //   ],
    //             // )
    //             // )
    //           ),
    //         ),
    //       )
    //       ],
    //     ),
    //   ),
    //   flex: 1,
    // ),
    //
    // // showBanner(adsFile!)
    // // AdmobBanner(
    // // adUnitId: AdsInfo.getBannerAdUnitId(),
    // // adSize: AdmobBannerSize.BANNER,
    // // // name: 'LARGE_BANNER'),
    // // // adSize: AdmobBannerSize(width: 300, height: 250),
    // // listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
    // // onBannerCreated: (AdmobBannerController controller) {
    // // // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
    // // // Normally you don't need to worry about disposing this yourself, it's handled.
    // // // If you need direct access to dispose, this is your guy!
    // // // controller.dispose();
    // // },
    // // ),
    // ],
    // ),
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
    YoutubePlayerController _controller = YoutubePlayerController(
      // initialVideoId:
      // YoutubePlayer.convertUrlToId(exerciseDetail.video!)!,
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
                          "${Constants.assetsGifPath}${exerciseDetail
                              .image}${Constants.assetsImageFormat}",
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
                    )

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
}
