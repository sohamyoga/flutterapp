import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import 'package:workout/WidgetChallengeExerciseSecList.dart';
import 'package:workout/models/ModelHistory.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'generated/l10n.dart';
import 'models/ModelChallengesMainCat.dart';

// ignore: must_be_immutable
class WidgetChallengesExerciseList extends StatefulWidget {
  ModelChallengesMainCat _modelWorkoutList;

  WidgetChallengesExerciseList(this._modelWorkoutList);

  @override
  _WidgetChallengesExerciseList createState() =>
      _WidgetChallengesExerciseList();
}

class _WidgetChallengesExerciseList
    extends State<WidgetChallengesExerciseList> {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;
  double getCal = 0;
  int getTime = 0;
  int getTotalWorkout = 0;
  List<ModelHistory> priceList = [];
  int lastWeek = 1, lastDay = 1;

  // AnimationController animationController;
  void sendToWorkoutList(BuildContext context, int day, int week) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return WidgetChallengeExerciseSecList(
            widget._modelWorkoutList, day, week);
      },
    ));
  }

  void _calcTotal() async {
    // priceList = await _dataHelper.calculateTotalWorkout();
    // if (priceList.length > 0) {
    //   getTotalWorkout = priceList.length;
    //   priceList.forEach((price) {
    //     getCal = getCal + double.parse(price.kCal!);
    //   });
    //   print("getval=$getCal");
    //   getTime = getTotalWorkout * 2;
    //   setState(() {});
    // }
    // var total = (await _dataHelper.calculateTotalWorkout())[0]['Total'];
    // print("etcal=$total");
    // setState(() {
    //   getCal = total;
    // });

    setState(() {
      getTotalWorkout = 5;
      getCal = 15 + getCal;
      getTime = 10 + getTime;
    });
  }

  // AdmobInterstitial? interstitialAd;
  // AdsFile? adsFile;

  @override
  void initState() {
    _calcTotal();


    super.initState();




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

  @override
  void dispose() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double screenHeight = SizeConfig.safeBlockVertical! * 100;

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

                  AppBar(
                    backgroundColor: Colors.transparent,

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

                  Container(

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(Constants.getScreenPercentSize(context, 4)),
                        topLeft: Radius.circular(Constants.getScreenPercentSize(context, 4)),

                      )
                    ),
                    margin: EdgeInsets.only(
                        top: Constants.getPercentSize(screenHeight, 44)),
                    child: Column(
                      children: [

                        SizedBox(height: Constants.getScreenPercentSize(context, 3),),
                        Hero(
                            tag: widget._modelWorkoutList.id!,
                            child: Container(
                              width: double.infinity,

                              padding: EdgeInsets.symmetric(
                                  horizontal: Constants.getScreenPercentSize(
                                      context, 2)),
                              // height:
                              //     SizeConfig.safeBlockVertical! * 2,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Constants.getScreenPercentSize(
                                            context, 2)),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: getMediumBoldTextWithMaxLine(
                                          widget._modelWorkoutList.title!,
                                          Colors.black,
                                          1,
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

                                  SizedBox(
                                    height: 7,
                                  )
                                ],
                              ),
                            )),
                        Container(
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(30),
                          //         topRight: Radius.circular(30)),
                          //     color: Colors.white),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                top: 10, left: 7, right: 7, bottom: 40),
                            itemCount: widget._modelWorkoutList.weeks,
                            itemBuilder: (context, weekPosition) {
                              var _crossAxisSpacing = 3.0;
                              var _screenWidth =
                                  SizeConfig.safeBlockHorizontal! * 65;
                              // var _screenWidth = MediaQuery.of(context).size.width;
                              var _crossAxisCount = 3;
                              var _width = (_screenWidth -
                                      ((_crossAxisCount - 1) *
                                          _crossAxisSpacing)) /
                                  _crossAxisCount;
                              var cellHeight = 45.0;
                              // var cellHeight = 200/3;
                              var _aspectRatio = _width / cellHeight;

                              return Container(
                                margin: EdgeInsets.all(7),
                                padding: EdgeInsets.only(
                                    left: 7, right: 7, top: 13, bottom: 7),
                                // width: double.infinity,
                                // height: 220,
                                // height: SizeConfig.safeBlockVertical*25,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),

                                  color: greyWhite.withOpacity(0.4),

                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey,
                                  //     offset: Offset(0.0, 1), //(x,y)
                                  //     blurRadius: 2.5,
                                  //   )
                                  // ],
                                  // color: Colors.white
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getSmallNormalText(
                                        "${S.of(context).week}-${weekPosition + 1}",
                                        Colors.grey,
                                        TextAlign.start),


                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: SizedBox(),
                                          flex: 1,
                                        ),
                                        Container(
                                          width:
                                              SizeConfig.safeBlockHorizontal! * 65,
                                          // height: totalGridHeight,
                                          color: Colors.transparent,
                                          child: GridView.count(
                                            crossAxisCount: _crossAxisCount,
                                            shrinkWrap: true,
                                            primary: false,

                                            physics:
                                                new NeverScrollableScrollPhysics(),
                                            mainAxisSpacing: _crossAxisSpacing,
                                            // crossAxisSpacing: _crossAxisSpacing,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            childAspectRatio: _aspectRatio,
                                            // childAspectRatio:
                                            //     (((SizeConfig.safeBlockHorizontal! *
                                            //                 65) /
                                            //             3.3) /
                                            //         (200 / 3.7)),

                                            children: List.generate(8, (index) {
                                              Color setColor = Colors.black38;

                                              if (index == 0 && weekPosition == 0) {
                                                setColor = Colors.green;
                                              }
                                              return (index == 7)
                                                  ? Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Container(
                                                        margin: EdgeInsets.only(left: 5),
                                                        child: Image.asset(
                                                          Constants.assetsImagePath +
                                                              "trophy_cup.png",
                                                          height: cellHeight,
                                                          width: cellHeight,
                                                          color: (index == 0)
                                                              ? Colors.orange
                                                              : Colors.black26,
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: setColor,
                                                                  shape: BoxShape.circle),
                                                              height: cellHeight,
                                                              width: cellHeight,
                                                              child: Center(
                                                                child: Text(
                                                                  "${index + 1}",
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontFamily: Constants.fontsFamily,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 20),
                                                                ),
                                                              ),
                                                            ),

                                                          ),
                                                          Expanded(
                                                            // child: getCustomText("------",
                                                            //     Colors.black38, 1,TextAlign.start, FontWeight.w600,
                                                            //     Constants.getScreenPercentSize(context,2)),
                                                            child: Icon(
                                                              Icons.chevron_right,
                                                              color: Colors.black38,
                                                            ),
                                                            flex: 1,
                                                          )

                                                        ],
                                                      ),
                                                      onTap: () {
                                                        if (index == 0) {
                                                          sendToWorkoutList(context, 1, 1);
                                                        } else {
                                                          showCustomToast("Please complete previous day first", context);
                                                        }
                                                      },
                                                    );
                                            }),
                                          ),
                                        ),
                                        // flex: 1,
                                        // )

                                        // ,
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(),
                                        )
                                      ],
                                    ),
                                    //   flex: 1,
                                    // )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),


                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical:
                          Constants.getScreenPercentSize(context, 1.5)),
                      margin: EdgeInsets.only(
                          top: Constants.getPercentSize(screenHeight, 40),
                          left: Constants.getWidthPercentSize(context, 10),
                          right: Constants.getWidthPercentSize(context, 10)),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                              Constants.getScreenPercentSize(context, 4))),
                          color: accentColor),
                      // margin: EdgeInsets.all(7),
                      // width: SizeConfig.safeBlockHorizontal! * 55,
                      child: InkWell(
                        onTap: () {
                          sendToWorkoutList(context, lastDay, lastWeek);
                        },
                        child: Container(
                          child: getCustomText(
                              "Go",
                              Colors.white,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              Constants.getScreenPercentSize(context, 2.5)),
                        ),
                      )),
                ],
              ),
            ],
          ),
        )),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );

    //
    // return
    //
    //
    //     WillPopScope(
    //   child: Scaffold(
    //     resizeToAvoidBottomInset: true,
    //
    //
    //     body: Padding(
    //       padding: EdgeInsets.all(0),
    //
    //       child: Stack(
    //         children: [
    //           Container(
    //             height: double.infinity,
    //             width: double.infinity,
    //             // decoration: BoxDecoration(
    //             //   image: DecorationImage(
    //             //     image: AssetImage(Constants.assetsImagePath +
    //             //         widget._modelWorkoutList.background!),
    //             //     fit: BoxFit.cover,
    //             //   ),
    //             //   // borderRadius: BorderRadius.all(
    //             //   //     Radius.circular(10)
    //             //   // ),
    //             //   // color: Colors.green,
    //             // ),
    //             // child: Image.asset(
    //             //   Constants.assetsImagePath + widget._modelWorkoutList.image,
    //             //   fit: BoxFit.scaleDown,
    //             // ),
    //           ),
    //           Container(
    //             height: SizeConfig.safeBlockVertical! * 35,
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               image: DecorationImage(
    //                 image: AssetImage(Constants.assetsImagePath +
    //                     widget._modelWorkoutList.background!),
    //                 fit: BoxFit.fitHeight,
    //               ),
    //               // borderRadius: BorderRadius.all(
    //               //     Radius.circular(10)
    //               // ),
    //               // color: Colors.green,
    //             ),
    //             // child: Image.asset(
    //             //   Constants.assetsImagePath + widget._modelWorkoutList.image,
    //             //   fit: BoxFit.scaleDown,
    //             // ),
    //           ),
    //           Column(
    //             children: <Widget>[
    //               AnimatedContainer(
    //                 height: _showAppbar ? 56.0 : 0.0,
    //                 duration: Duration(milliseconds: 200),
    //                 child: AppBar(
    //                   backgroundColor: Colors.transparent,
    //                   elevation: 0,
    //                   automaticallyImplyLeading: false,
    //                   iconTheme: IconThemeData(color: Colors.white),
    //                   actionsIconTheme: IconThemeData(color: Colors.white),
    //                   actions: <Widget>[
    //                     PopupMenuButton<String>(
    //                       onSelected: handleClick,
    //                       itemBuilder: (BuildContext context) {
    //                         return {'Share'}.map((String choice) {
    //                           return PopupMenuItem<String>(
    //                             value: choice,
    //                             child: Text(choice),
    //                           );
    //                         }).toList();
    //                       },
    //                     )
    //                     //add buttons here
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 child: SingleChildScrollView(
    //                   controller: _scrollViewController,
    //                   child: Column(
    //                     children: <Widget>[
    //                       Hero(
    //                           tag: widget._modelWorkoutList.title!,
    //                           child: Container(
    //                             width: double.infinity,
    //                             padding: EdgeInsets.all(10),
    //                             height: SizeConfig.safeBlockVertical! * 25,
    //                             color: Colors.transparent,
    //                             // color: greyWhite,
    //                             child: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Expanded(
    //                                   child: Padding(
    //                                     padding: EdgeInsets.only(
    //                                       left: 7,
    //                                     ),
    //                                     child: Align(
    //                                         alignment: Alignment.centerLeft,
    //                                         child: getMediumBoldTextWithMaxLine(
    //                                           widget._modelWorkoutList.title!,
    //                                           Colors.white,
    //                                           1,
    //                                         )),
    //                                   ),
    //                                   flex: 1,
    //                                 ),
    //                                 Card(
    //                                   color: darkGrey,
    //                                   shape: RoundedRectangleBorder(
    //                                       borderRadius:
    //                                           BorderRadius.circular(15)),
    //                                   child: Padding(
    //                                     padding: EdgeInsets.only(
    //                                         left: 10,
    //                                         right: 10,
    //                                         top: 3,
    //                                         bottom: 3),
    //                                     child: getCustomText(
    //                                         S.of(context).transformation,
    //                                         Colors.black87,
    //                                         1,
    //                                         TextAlign.start,
    //                                         FontWeight.w600,
    //                                         15),
    //                                   ),
    //                                 ),
    //                                 SizedBox(
    //                                   height: 7,
    //                                 ),
    //                                 // Row(
    //                                 //   children: [
    //                                 //     Expanded(
    //                                 //       child: RichText(
    //                                 //         maxLines: 1,
    //                                 //         textAlign: TextAlign.center,
    //                                 //         text: TextSpan(
    //                                 //           children: [
    //                                 //             WidgetSpan(
    //                                 //               child: Icon(
    //                                 //                   Icons.chevron_right,
    //                                 //                   size: 20),
    //                                 //             ),
    //                                 //             WidgetSpan(
    //                                 //                 child: SizedBox(
    //                                 //               width: 10,
    //                                 //             )),
    //                                 //             TextSpan(
    //                                 //                 text:
    //                                 //                     S.of(context).beginner,
    //                                 //                 style: TextStyle(
    //                                 //                     color: Colors.black87,
    //                                 //                     fontFamily: Constants
    //                                 //                         .fontsFamily,
    //                                 //                     fontSize: 15,
    //                                 //                     fontWeight:
    //                                 //                         FontWeight.w600)),
    //                                 //           ],
    //                                 //         ),
    //                                 //       ),
    //                                 //       flex: 1,
    //                                 //     ),
    //                                 //     Expanded(
    //                                 //       child: RichText(
    //                                 //         maxLines: 1,
    //                                 //         textAlign: TextAlign.center,
    //                                 //         text: TextSpan(
    //                                 //           children: [
    //                                 //             WidgetSpan(
    //                                 //               child: Icon(Icons.whatshot,
    //                                 //                   size: 20),
    //                                 //             ),
    //                                 //             WidgetSpan(
    //                                 //                 child: SizedBox(
    //                                 //               width: 10,
    //                                 //             )),
    //                                 //             TextSpan(
    //                                 //                 text:
    //                                 //                     "$getCal ${S.of(context).calories}",
    //                                 //                 style: TextStyle(
    //                                 //                     color: Colors.black87,
    //                                 //                     fontFamily: Constants
    //                                 //                         .fontsFamily,
    //                                 //                     fontSize: 15,
    //                                 //                     fontWeight:
    //                                 //                         FontWeight.w600)),
    //                                 //           ],
    //                                 //         ),
    //                                 //       ),
    //                                 //       flex: 1,
    //                                 //     ),
    //                                 //     Expanded(
    //                                 //       child: RichText(
    //                                 //         maxLines: 1,
    //                                 //         textAlign: TextAlign.center,
    //                                 //         text: TextSpan(
    //                                 //           children: [
    //                                 //             WidgetSpan(
    //                                 //               child: Icon(Icons.timer,
    //                                 //                   size: 20),
    //                                 //             ),
    //                                 //             WidgetSpan(
    //                                 //                 child: SizedBox(
    //                                 //               width: 10,
    //                                 //             )),
    //                                 //             TextSpan(
    //                                 //                 text:
    //                                 //                     "$getTime ${S.of(context).minutes}",
    //                                 //                 style: TextStyle(
    //                                 //                     color: Colors.black87,
    //                                 //                     fontFamily: Constants
    //                                 //                         .fontsFamily,
    //                                 //                     fontSize: 15,
    //                                 //                     fontWeight:
    //                                 //                         FontWeight.w600)),
    //                                 //           ],
    //                                 //         ),
    //                                 //       ),
    //                                 //       flex: 1,
    //                                 //     )
    //                                 //   ],
    //                                 // ),
    //                                 // SizedBox(
    //                                 //   height: 7,
    //                                 // )
    //                               ],
    //                             ),
    //                           )),
    //                       Container(
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.only(
    //                                 topLeft: Radius.circular(30),
    //                                 topRight: Radius.circular(30)),
    //                             color: Colors.white),
    //                         child: ListView.builder(
    //                           primary: false,
    //                           shrinkWrap: true,
    //                           scrollDirection: Axis.vertical,
    //                           padding: EdgeInsets.only(
    //                               top: 15, left: 7, right: 7, bottom: 40),
    //                           itemCount: widget._modelWorkoutList.weeks,
    //                           itemBuilder: (context, index) {
    //                             int week = index;
    //                             var _crossAxisSpacing = 3.0;
    //                             var _screenWidth =
    //                                 SizeConfig.safeBlockHorizontal! * 65;
    //                             // var _screenWidth = MediaQuery.of(context).size.width;
    //                             var _crossAxisCount = 3;
    //                             var _width = (_screenWidth -
    //                                     ((_crossAxisCount - 1) *
    //                                         _crossAxisSpacing)) /
    //                                 _crossAxisCount;
    //                             var cellHeight = 45.0;
    //                             // var cellHeight = 200/3;
    //                             var _aspectRatio = _width / cellHeight;
    //
    //                             return Container(
    //                               margin: EdgeInsets.all(7),
    //                               padding: EdgeInsets.only(
    //                                   left: 7, right: 7, top: 13, bottom: 7),
    //                               // width: double.infinity,
    //                               // height: 220,
    //                               // height: SizeConfig.safeBlockVertical*25,
    //                               decoration: BoxDecoration(
    //                                   borderRadius:
    //                                       BorderRadius.all(Radius.circular(10)),
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                       color: Colors.grey,
    //                                       offset: Offset(0.0, 1), //(x,y)
    //                                       blurRadius: 2.5,
    //                                     )
    //                                   ],
    //                                   color: Colors.white),
    //                               child: Column(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 // mainAxisSize: MainAxisSize.max,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   getSmallNormalText(
    //                                       "${S.of(context).week}-${index + 1}",
    //                                       Colors.grey,
    //                                       TextAlign.start),
    //                                   // Expanded(
    //                                   //   child:
    //                                   Row(
    //                                     mainAxisSize: MainAxisSize.max,
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.center,
    //                                     children: [
    //                                       Expanded(
    //                                         child: SizedBox(),
    //                                         flex: 1,
    //                                       ),
    //                                       Container(
    //                                         width: SizeConfig
    //                                                 .safeBlockHorizontal! *
    //                                             65,
    //                                         // height: totalGridHeight,
    //                                         color: Colors.white,
    //                                         child: GridView.count(
    //                                           crossAxisCount: _crossAxisCount,
    //                                           shrinkWrap: true,
    //                                           primary: false,
    //
    //                                           physics:
    //                                               new NeverScrollableScrollPhysics(),
    //                                           mainAxisSpacing:
    //                                               _crossAxisSpacing,
    //                                           // crossAxisSpacing: _crossAxisSpacing,
    //                                           padding: EdgeInsets.symmetric(
    //                                               vertical: 10),
    //                                           childAspectRatio: _aspectRatio,
    //                                           // childAspectRatio:
    //                                           //     (((SizeConfig.safeBlockHorizontal! *
    //                                           //                 65) /
    //                                           //             3.3) /
    //                                           //         (200 / 3.7)),
    //
    //                                           children:
    //                                               List.generate(8, (index) {
    //                                             Color setColor = Colors.black38;
    //
    //                                             if (index == 0) {
    //                                               setColor = Colors.green;
    //                                             }
    //                                             return (index == 7)
    //                                                 ? Align(
    //                                                     alignment: Alignment
    //                                                         .centerLeft,
    //                                                     child: Container(
    //                                                       margin:
    //                                                           EdgeInsets.only(
    //                                                               left: 5),
    //                                                       child: Image.asset(
    //                                                         Constants
    //                                                                 .assetsImagePath +
    //                                                             "trophy_cup.png",
    //                                                         height: cellHeight,
    //                                                         width: cellHeight,
    //                                                         color: (index == 0)
    //                                                             ? Colors.orange
    //                                                             : Colors
    //                                                                 .black26,
    //                                                       ),
    //                                                     ),
    //                                                   )
    //                                                 : InkWell(
    //                                                     child: Row(
    //                                                       children: [
    //                                                         Container(
    //                                                           // child:
    //                                                           //     ClipOval(
    //                                                           child: Container(
    //                                                             decoration: BoxDecoration(
    //                                                                 color:
    //                                                                     setColor,
    //                                                                 shape: BoxShape
    //                                                                     .circle),
    //                                                             height:
    //                                                                 cellHeight,
    //                                                             width:
    //                                                                 cellHeight,
    //                                                             child: Center(
    //                                                               child: Text(
    //                                                                 "${index + 1}",
    //                                                                 style: TextStyle(
    //                                                                     color: Colors
    //                                                                         .white,
    //                                                                     fontFamily:
    //                                                                         Constants
    //                                                                             .fontsFamily,
    //                                                                     fontWeight:
    //                                                                         FontWeight
    //                                                                             .bold,
    //                                                                     fontSize:
    //                                                                         20),
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                           // )
    //                                                           // ;
    //                                                           //   },
    //                                                           // ),
    //                                                         ),
    //                                                         Expanded(
    //                                                           child: Icon(
    //                                                             Icons
    //                                                                 .chevron_right,
    //                                                             color: Colors
    //                                                                 .black38,
    //                                                           ),
    //                                                           flex: 1,
    //                                                         )
    //
    //                                                         // Expanded(
    //                                                         //   flex: 1,
    //                                                         //   child: SizedBox(),
    //                                                         // ),
    //                                                       ],
    //                                                     ),
    //                                                     onTap: () {
    //                                                       if (index == 0) {
    //                                                         sendToWorkoutList(
    //                                                             context, 1, 1);
    //                                                       } else {
    //                                                         showCustomToast(
    //                                                             "Please complete previous day first",
    //                                                             context);
    //                                                       }
    //                                                     },
    //                                                   );
    //                                             // return FutureBuilder<
    //                                             //     ModelLastCompleteData>(
    //                                             //   future: _dataHelper
    //                                             //       .getLastCompleteChallengeData(
    //                                             //           widget
    //                                             //               ._modelWorkoutList),
    //                                             //   builder: (context, snapshot) {
    //                                             //     if (snapshot.hasData) {
    //                                             //       Color setColor =
    //                                             //           Colors.black38;
    //                                             //       ModelLastCompleteData
    //                                             //           _lastCompleteData =
    //                                             //           snapshot.data!;
    //                                             //       // if((week == 0 && index == 0)|| (snapshot.hasData && snapshot.data))
    //                                             //       int setWeek = week + 1;
    //                                             //       int setDay = index + 1;
    //                                             //       lastWeek =
    //                                             //           _lastCompleteData
    //                                             //               .lastWeek;
    //                                             //       lastDay =
    //                                             //           _lastCompleteData
    //                                             //               .lastDay;
    //                                             //       if (setWeek <
    //                                             //               _lastCompleteData
    //                                             //                   .lastWeek ||
    //                                             //           (setWeek ==
    //                                             //                   _lastCompleteData
    //                                             //                       .lastWeek &&
    //                                             //               setDay <=
    //                                             //                   _lastCompleteData
    //                                             //                       .lastDay)) {
    //                                             //         // lastWeek=setWeek;
    //                                             //         // lastDay=setDay;
    //                                             //         setColor = Colors.green;
    //                                             //       }
    //                                             //       // double cellSize=cellHeight/4;
    //                                             //       return (index == 7)
    //                                             //           ? Align(
    //                                             //               alignment: Alignment
    //                                             //                   .centerLeft,
    //                                             //               child: Container(
    //                                             //                 margin: EdgeInsets
    //                                             //                     .only(
    //                                             //                         left:
    //                                             //                             5),
    //                                             //                 child:
    //                                             //                     Image.asset(
    //                                             //                   Constants
    //                                             //                           .assetsImagePath +
    //                                             //                       "trophy_cup.png",
    //                                             //                   height:
    //                                             //                       cellHeight,
    //                                             //                   width:
    //                                             //                       cellHeight,
    //                                             //                   color: (setWeek <
    //                                             //                               _lastCompleteData
    //                                             //                                   .lastWeek ||
    //                                             //                           (setWeek == _lastCompleteData.lastWeek &&
    //                                             //                               _lastCompleteData.lastDay ==
    //                                             //                                   7))
    //                                             //                       ? Colors
    //                                             //                           .orange
    //                                             //                       : Colors
    //                                             //                           .black26,
    //                                             //                 ),
    //                                             //               ),
    //                                             //             )
    //                                             //           : InkWell(
    //                                             //               child: Row(
    //                                             //                 children: [
    //                                             //                   Container(
    //                                             //                     // child:
    //                                             //                     //     ClipOval(
    //                                             //                     child:
    //                                             //                         Container(
    //                                             //                       decoration: BoxDecoration(
    //                                             //                           color:
    //                                             //                               setColor,
    //                                             //                           shape:
    //                                             //                               BoxShape.circle),
    //                                             //                       height:
    //                                             //                           cellHeight,
    //                                             //                       width:
    //                                             //                           cellHeight,
    //                                             //
    //                                             //
    //                                             //                       child:
    //                                             //                           Center(
    //                                             //                         child:
    //                                             //                             Text(
    //                                             //                           "${index + 1}",
    //                                             //                           style: TextStyle(
    //                                             //                               color: Colors.white,
    //                                             //                               fontFamily: Constants.fontsFamily,
    //                                             //                               fontWeight: FontWeight.bold,
    //                                             //                               fontSize: 20),
    //                                             //                         ),
    //                                             //                       ),
    //                                             //                     ),
    //                                             //                     // )
    //                                             //                     // ;
    //                                             //                     //   },
    //                                             //                     // ),
    //                                             //                   ),
    //                                             //                   Expanded(
    //                                             //                     child: Icon(
    //                                             //                       Icons
    //                                             //                           .chevron_right,
    //                                             //                       color: Colors
    //                                             //                           .black38,
    //                                             //                     ),
    //                                             //                     flex: 1,
    //                                             //                   )
    //                                             //
    //                                             //                   // Expanded(
    //                                             //                   //   flex: 1,
    //                                             //                   //   child: SizedBox(),
    //                                             //                   // ),
    //                                             //                 ],
    //                                             //               ),
    //                                             //               onTap: () {
    //                                             //                 if (setWeek <
    //                                             //                         _lastCompleteData
    //                                             //                             .lastWeek ||
    //                                             //                     (setWeek ==
    //                                             //                             _lastCompleteData
    //                                             //                                 .lastWeek &&
    //                                             //                         setDay <=
    //                                             //                             _lastCompleteData.lastDay)) {
    //                                             //                   // setColor = Colors.green;
    //                                             //                   sendToWorkoutList(
    //                                             //                       context,
    //                                             //                       setDay,
    //                                             //                       setWeek);
    //                                             //                 } else {
    //                                             //                   showCustomToast(
    //                                             //                       "Please complete previous day first",
    //                                             //                       context);
    //                                             //                 }
    //                                             //
    //                                             //
    //                                             //
    //                                             //               },
    //                                             //             );
    //                                             //     } else {
    //                                             //       return getProgressDialog();
    //                                             //     }
    //                                             //   },
    //                                             // );
    //
    //                                             //robohash.org api provide you different images for any number you are giving
    //                                           }),
    //                                         ),
    //                                         // child: GridView.count(
    //                                         //   crossAxisCount: 3,
    //                                         //   shrinkWrap: true,
    //                                         //   primary: false,
    //                                         //   physics:
    //                                         //       new NeverScrollableScrollPhysics(),
    //                                         //   childAspectRatio:
    //                                         //       (((SizeConfig.safeBlockHorizontal! *
    //                                         //                   65) /
    //                                         //               3.3) /
    //                                         //           (200 / 3.7)),
    //                                         //   // childAspectRatio: (3 / 1.8),
    //                                         //   children: List.generate(8,
    //                                         //       (index) {
    //                                         //     return FutureBuilder<
    //                                         //         ModelLastCompleteData>(
    //                                         //       future: _dataHelper
    //                                         //           .getLastCompleteChallengeData(
    //                                         //               widget
    //                                         //                   ._modelWorkoutList),
    //                                         //       builder: (context,
    //                                         //           snapshot) {
    //                                         //         if (snapshot
    //                                         //             .hasData) {
    //                                         //           Color setColor =
    //                                         //               Colors.black38;
    //                                         //           ModelLastCompleteData
    //                                         //               _lastCompleteData =
    //                                         //               snapshot.data;
    //                                         //           // if((week == 0 && index == 0)|| (snapshot.hasData && snapshot.data))
    //                                         //           int setWeek =
    //                                         //               week + 1;
    //                                         //           int setDay =
    //                                         //               index + 1;
    //                                         //           lastWeek =
    //                                         //               _lastCompleteData
    //                                         //                   .lastWeek;
    //                                         //           lastDay =
    //                                         //               _lastCompleteData
    //                                         //                   .lastDay;
    //                                         //           if (setWeek <
    //                                         //                   _lastCompleteData
    //                                         //                       .lastWeek ||
    //                                         //               (setWeek ==
    //                                         //                       _lastCompleteData
    //                                         //                           .lastWeek &&
    //                                         //                   setDay <=
    //                                         //                       _lastCompleteData
    //                                         //                           .lastDay)) {
    //                                         //             // lastWeek=setWeek;
    //                                         //             // lastDay=setDay;
    //                                         //             setColor =
    //                                         //                 Colors.green;
    //                                         //           }
    //                                         //           return (index == 7)
    //                                         //               ? Align(
    //                                         //                   alignment:
    //                                         //                       Alignment
    //                                         //                           .centerLeft,
    //                                         //                   child:
    //                                         //                       Container(
    //                                         //                     margin: EdgeInsets.only(
    //                                         //                         left:
    //                                         //                             5),
    //                                         //                     child: Image
    //                                         //                         .asset(
    //                                         //                       Constants.assetsImagePath +
    //                                         //                           "trophy_cup.png",
    //                                         //                       height:
    //                                         //                           42,
    //                                         //                       width:
    //                                         //                           42,
    //                                         //                       color: (setWeek < _lastCompleteData.lastWeek ||
    //                                         //                               (setWeek == _lastCompleteData.lastWeek && _lastCompleteData.lastDay == 7))
    //                                         //                           ? Colors.orange
    //                                         //                           : Colors.black26,
    //                                         //                     ),
    //                                         //                   ),
    //                                         //                 )
    //                                         //               : InkWell(
    //                                         //                   child: Row(
    //                                         //                     children: [
    //                                         //                       Container(
    //                                         //                           child:
    //                                         //                               // FutureBuilder<ModelLastCompleteData>(
    //                                         //                               //   future: _dataHelper.getLastCompleteChallengeData(widget._modelWorkoutList),
    //                                         //                               //   builder: (context, snapshot) {
    //                                         //                               //     Color setColor=Colors.black38;
    //                                         //                               //     ModelLastCompleteData _lastCompleteData=snapshot.data;
    //                                         //                               //     // if((week == 0 && index == 0)|| (snapshot.hasData && snapshot.data))
    //                                         //                               //     int setWeek=week+1;
    //                                         //                               //     int setDay=index+1;
    //                                         //                               //     if(setWeek<_lastCompleteData.lastWeek || (setWeek==_lastCompleteData.lastWeek && setDay<=_lastCompleteData.lastDay))
    //                                         //                               //     {
    //                                         //                               //       lastWeek=week+1;
    //                                         //                               //       lastDay=(index+1);
    //                                         //                               //       setColor=Colors.green;
    //                                         //                               //     }
    //                                         //                               //     return
    //                                         //                               ClipOval(
    //                                         //                         child:
    //                                         //                             Container(
    //                                         //                           height:
    //                                         //                               45,
    //                                         //                           width:
    //                                         //                               45,
    //                                         //                           color:
    //                                         //                               setColor,
    //                                         //                           // color: (week == 0 && index == 0)
    //                                         //                           //     ? Colors
    //                                         //                           //     .green
    //                                         //                           //     : Colors
    //                                         //                           //     .black38,
    //                                         //                           child:
    //                                         //                               Center(
    //                                         //                             child: Text(
    //                                         //                               "${index + 1}",
    //                                         //                               style: TextStyle(color: Colors.white, fontFamily: Constants.fontsFamily, fontWeight: FontWeight.bold, fontSize: 20),
    //                                         //                             ),
    //                                         //                           ),
    //                                         //                         ),
    //                                         //                       )
    //                                         //                           // ;
    //                                         //                           //   },
    //                                         //                           // ),
    //                                         //                           ),
    //                                         //                       Expanded(
    //                                         //                         child:
    //                                         //                             Icon(
    //                                         //                           Icons.chevron_right,
    //                                         //                           color:
    //                                         //                               Colors.black38,
    //                                         //                         ),
    //                                         //                         flex:
    //                                         //                             1,
    //                                         //                       )
    //                                         //
    //                                         //                       // Expanded(
    //                                         //                       //   flex: 1,
    //                                         //                       //   child: SizedBox(),
    //                                         //                       // ),
    //                                         //                     ],
    //                                         //                   ),
    //                                         //                   onTap: () {
    //                                         //                     if (setWeek <
    //                                         //                             _lastCompleteData
    //                                         //                                 .lastWeek ||
    //                                         //                         (setWeek == _lastCompleteData.lastWeek &&
    //                                         //                             setDay <= _lastCompleteData.lastDay)) {
    //                                         //                       // setColor = Colors.green;
    //                                         //                       sendToWorkoutList(
    //                                         //                           context,
    //                                         //                           setDay,
    //                                         //                           setWeek);
    //                                         //                     } else {
    //                                         //                       showCustomToast(
    //                                         //                           "Please complete previous day first",
    //                                         //                           context);
    //                                         //                     }
    //                                         //
    //                                         //                     // sendToWorkoutList(
    //                                         //                     //     context,
    //                                         //                     //     (index +
    //                                         //                     //         1),
    //                                         //                     //     (week +
    //                                         //                     //         1));
    //                                         //                   },
    //                                         //                 );
    //                                         //         } else {
    //                                         //           return getProgressDialog();
    //                                         //         }
    //                                         //       },
    //                                         //     );
    //                                         //
    //                                         //     //robohash.org api provide you different images for any number you are giving
    //                                         //   }),
    //                                         // ),
    //                                       ),
    //                                       // flex: 1,
    //                                       // )
    //
    //                                       // ,
    //                                       Expanded(
    //                                         flex: 1,
    //                                         child: SizedBox(),
    //                                       )
    //                                     ],
    //                                   ),
    //                                   //   flex: 1,
    //                                   // )
    //                                 ],
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Container(
    //                 margin: EdgeInsets.all(7),
    //                 width: SizeConfig.safeBlockHorizontal! * 55,
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                       onPrimary: greenButton,
    //                       textStyle: TextStyle(
    //                         color: Colors.white,
    //                       ),
    //                       padding: EdgeInsets.only(top: 12, bottom: 12),
    //                       shape: RoundedRectangleBorder(
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(7.0)))),
    //                   // shape: RoundedRectangleBorder(
    //                   //     borderRadius: BorderRadius.all(Radius.circular(7.0))),
    //                   onPressed: () async {
    //
    //                       sendToWorkoutList(context, lastDay, lastWeek);
    //
    //
    //
    //                   },
    //
    //                   child: getCustomText(S.of(context).go, Colors.white, 1,
    //                       TextAlign.center, FontWeight.w600, 17),
    //                 )),
    //           ),
    //           Align(
    //             alignment: Alignment.topLeft,
    //             child: Padding(
    //               child: IconButton(
    //                   icon: Icon(
    //                     Icons.arrow_back_ios,
    //                     color: Colors.white,
    //                   ),
    //                   onPressed: () {
    //                     onBackClicked();
    //                   }),
    //               padding: EdgeInsets.symmetric(vertical: 28, horizontal: 12),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   onWillPop: () async {
    //     onBackClicked();
    //     return false;
    //   },
    // );
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }
}
