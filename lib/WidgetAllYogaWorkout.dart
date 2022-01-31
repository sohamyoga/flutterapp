import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ConstantWidget.dart';
import 'Constants.dart';
import 'DataFile.dart';
import 'SizeConfig.dart';
import 'WidgetWorkoutExerciseList.dart';
import 'Widgets.dart';
import 'generated/l10n.dart';
import 'models/ModelDummySend.dart';
import 'models/ModelWorkoutList.dart';

// ignore: must_be_immutable
class WidgetAllYogaWorkout extends StatefulWidget {

  WidgetAllYogaWorkout();

  @override
  _WidgetAllYogaWorkout createState() =>
      _WidgetAllYogaWorkout();
}

class _WidgetAllYogaWorkout
    extends State<WidgetAllYogaWorkout> {





  // AdmobInterstitial? interstitialAd;
  // AdsFile? adsFile;

  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }



  List<ModelWorkoutList> workoutList = DataFile.getWorkoutList();


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;

    int _crossAxisCount = 2;
    // double screenWidth=SizeConfig.safeBlockHorizontal*100;
    double _crossAxisSpacing = 10.0;
    // double widthItem = (screenWidth-(_crossAxisSpacing*_crossAxisCount))/_crossAxisCount;
    var widthItem =
        (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
            _crossAxisCount;
    double heightItem = Constants.getScreenPercentSize(context, 33);
    double imgHeight = Constants.getPercentSize(heightItem, 70);
    double titleHeight = Constants.getPercentSize(imgHeight, 20);
    double remainHeight = heightItem - imgHeight;
    double _aspectRatio = widthItem / heightItem;

    double height = SizeConfig.safeBlockVertical! * 25;
    double width = SizeConfig.safeBlockHorizontal! * 65;

    double sWidth = width / 2;
    double iconSize = ConstantWidget.getPercentSize(remainHeight, 18);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: getCustomText(S.of(context).yoga,Colors.black,1,TextAlign.start,FontWeight.w600,ConstantWidget.getScreenPercentSize(context, 2.5)),
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                onBackClicked();
              }),

        ),
        body: SafeArea(
            child: Container(
          height: double.infinity,
          width: double.infinity,
          child: GridView.count(
            // mainAxisSpacing: _crossAxisSpacing,
            crossAxisCount: _crossAxisCount,
            childAspectRatio: _aspectRatio,
            // crossAxisSpacing: _crossAxisSpacing,
            // mainAxisSpacing: _crossAxisSpacing,
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: _crossAxisSpacing,
                right: _crossAxisSpacing,
                bottom: _crossAxisSpacing),
            primary: false,
            children: List.generate(workoutList.length, (index) {
              ModelWorkoutList _workoutList = workoutList[index];
              return InkWell(
                child: Container(
                  height: double.infinity,
                  // padding: EdgeInsets.all(7),
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Container(

                          padding: EdgeInsets.only(
                              bottom:
                              Constants.getPercentSize(widthItem, 5)),
                          height: imgHeight,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.5), //(x,y)
                                blurRadius: 2.5,
                              ),
                            ],
                            image: DecorationImage(
                                image: AssetImage(
                                  Constants.assetsImagePath +
                                      _workoutList.image!,
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  Constants.getPercentSize(imgHeight, 8)),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: titleHeight,

                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                  Constants.getPercentSize(widthItem, 5)),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  Constants.getPercentSize(widthItem, 5)),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      Constants.getPercentSize(widthItem, 3)),
                                ),
                              ),

                              child: Center(
                                child:
                                ConstantWidget.getTextWidgetWithFontWithMaxLine1(
                                    _workoutList.name!
                                        .toUpperCase(),
                                    Colors.black87,
                                    TextAlign
                                        .center,
                                    FontWeight
                                        .bold,
                                    ConstantWidget.getPercentSize(
                                        titleHeight,
                                        38),
                                    Constants.boldFontsFamily),
                              ),
                            ),
                          )),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: Constants.getPercentSize(
                                height, 2),
                            horizontal: Constants.getPercentSize(
                                height, 2.8)),

                        child: Column(

                          children: [
                            SizedBox(height: Constants.getPercentSize(remainHeight, 4),),

                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Constants.assetsImagePath + "dumbbell.png",
                                  height: iconSize,
                                  width: iconSize,
                                  color: Colors.black,
                                ),
                                SizedBox(width: ConstantWidget.getPercentSize(sWidth, 5)),
                                ConstantWidget.getTextWidget("Beginner", Colors.black,
                                    TextAlign.start, FontWeight.w600, ConstantWidget.getPercentSize(remainHeight, 15)),
                              ],
                            ),

                            SizedBox(height: Constants.getPercentSize(remainHeight, 6),),


                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  Constants.assetsImagePath + "calendar.png",
                                  height: iconSize,
                                  width: iconSize,
                                  color: Colors.black,
                                ),
                                SizedBox(width: Constants.getPercentSize(sWidth, 5)),
                                ConstantWidget.getTextWidget("4 Week", Colors.black,
                                    TextAlign.start, FontWeight.w600, ConstantWidget.getPercentSize(remainHeight, 15)),
                              ],
                            ),





                          ],
                          // mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  sendToWorkoutList(context, _workoutList, Constants.workoutId);
                },
              );
            }),
          ),
        )),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );

  }


  void sendToWorkoutList(
      BuildContext context, ModelWorkoutList modelWorkoutList, int id) {
    ModelDummySend dummySend = new ModelDummySend(
        modelWorkoutList.id!,
        modelWorkoutList.name!,
        Constants.getTableNames(id),
        modelWorkoutList.image!);
    // dummySend.tableName = Constants.getTableNames(id);
    // dummySend.id = modelWorkoutList.id;
    // dummySend.name = modelWorkoutList.name;

    print("sendtidetail==$dummySend");
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return WidgetWorkoutExerciseList(dummySend);
      },
    ));
  }


  void onBackClicked() {
    Navigator.of(context).pop();
  }
}
