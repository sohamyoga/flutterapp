import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout/ColorCategory.dart';
import 'package:workout/Constants.dart';
import 'package:workout/Widgets.dart';
import 'package:workout/main.dart';


import 'ConstantWidget.dart';
import 'DataFile.dart';
import 'HomeWidget.dart';
import 'IntroModel.dart';
import 'PrefData.dart';
import 'SizeConfig.dart';

class IntroPage extends StatefulWidget {
  // final ValueChanged<bool> onChanged;

  // IntroPage(this.onChanged);

  @override
  _IntroPage createState() {
    return _IntroPage();
    // return _IntroPage(this.onChanged);
  }
}

class _IntroPage extends State<IntroPage> {
  int _position = 0;

  // final ValueChanged<bool> onChanged;

  // _IntroPage(this.onChanged);

  Future<bool> _requestPop() {


    if(Platform.isIOS){
      exit(0);
    }else{
      SystemNavigator.pop();
    }
    return new Future.value(false);
  }

  final controller = PageController();

  List<IntroModel> introModelList = [];


  void skip(){
    PrefData.setIsIntro(false);
    Navigator.of(context).pop(true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeWidget(0)));
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    introModelList = DataFile.getIntroModel(context);

    double firstSize = ConstantWidget.getScreenPercentSize(context, 55);
    double secondSize = ConstantWidget.getScreenPercentSize(context,45);
    double remainSize =
        ConstantWidget.getScreenPercentSize(context, 100) - firstSize;
    double defMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double nextHeight = Constants.getScreenPercentSize(context, 7.5);
    setState(() {});

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [

                Expanded(
                  child: Container(
                    child: PageView.builder(
                      controller: controller,
                      itemBuilder: (context, position) {
                        return Container(
                          child: Stack(
                            children: [
                              Container(
                                height: firstSize,
                                child: Image.asset(Constants.assetsImagePath+
                                    introModelList[position].image!,fit: BoxFit.scaleDown,),
                              ),



                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: secondSize),
                                padding: EdgeInsets.symmetric(vertical:
                                    ConstantWidget.getScreenPercentSize(context, 2),horizontal: (defMargin)),
                                // decoration: BoxDecoration(
                                //     color: accentColor,
                                //     // color: Colors.white,
                                //     borderRadius: BorderRadius.only(
                                //         topRight: Radius.circular(
                                //             ConstantWidget.getPercentSize(
                                //                 secondSize, 17)))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: (defMargin ),
                                          bottom: defMargin ),
                                      child:
                                          ConstantWidget.getCustomTextFont(
                                              introModelList[position]
                                                  .name!,
                                              Colors.black,
                                              // Colors.black87,
                                              2,
                                              TextAlign.center,
                                              FontWeight.bold,
                                              ConstantWidget.getPercentSize(
                                                  remainSize, 7),
                                              meriendaOneFont),
                                    ),
                                    ConstantWidget.getCustomTextFont(
                                        // "introModelList[position].desc!",
                                        introModelList[position].desc!,
                                        Colors.black87,
                                        // Colors.black45,
                                        5,
                                        TextAlign.center,
                                        FontWeight.w500,
                                        ConstantWidget.getScreenPercentSize(context,2),
                                        Constants.fontsFamily),


                                    // Expanded(
                                    //   child: Align(
                                    //     alignment: Alignment.bottomCenter,
                                    //     child: Container(
                                    //       width:Constants.getWidthPercentSize(context, 40),
                                    //       height:nextHeight,
                                    //       margin: EdgeInsets.only(bottom: defMargin*2),
                                    //       padding: EdgeInsets.symmetric(horizontal:(defMargin/1.3)),
                                    //       decoration: BoxDecoration(
                                    //           boxShadow: [
                                    //                                 BoxShadow(
                                    //                                   color: Colors.grey.shade300,
                                    //                                   offset: Offset(0.0, 2), //(x,y)
                                    //                                   blurRadius: 5,
                                    //                                 ),
                                    //                               ],
                                    //         color: Colors.white,
                                    //         borderRadius: BorderRadius.all(Radius.circular(Constants.getWidthPercentSize(context, 40)))
                                    //       ),
                                    //
                                    //       child: Row(
                                    //         children: [
                                    //           SizedBox(width:Constants.getWidthPercentSize(context, 3) ,),
                                    //           Expanded(child: getCustomText("Next",
                                    //               Colors.black87, 1, TextAlign.start, FontWeight.bold, Constants.getPercentSize(nextHeight,
                                    //                   30))),
                                    //
                                    //
                                    //           Container(
                                    //             height: Constants.getPercentSize(nextHeight, 75),
                                    //             width: Constants.getPercentSize(nextHeight, 75),
                                    //             decoration: BoxDecoration(
                                    //               color: accentColor.withOpacity(0.2),
                                    //               shape: BoxShape.circle
                                    //             ),
                                    //             child: Center(
                                    //               child: Icon(Icons.navigate_next,color: accentColor,size: Constants.getPercentSize(nextHeight, 50),),
                                    //             ),
                                    //           )
                                    //
                                    //
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: introModelList.length,
                      onPageChanged: _onPageViewChange,
                    ),
                  ),
                ),

                InkWell(
                  onTap: (){
                    onNext();
                  },
                  child: Container(
                    width:Constants.getWidthPercentSize(context, 40),
                    height:nextHeight,
                    margin: EdgeInsets.only(bottom: defMargin*2),
                    padding: EdgeInsets.symmetric(horizontal:(defMargin/1.3)),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(0.0, 2), //(x,y)
                            blurRadius: 5,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(Constants.getWidthPercentSize(context, 40)))
                    ),

                    child: Row(
                      children: [
                        SizedBox(width:Constants.getWidthPercentSize(context, 3) ,),
                        Expanded(child: getCustomText("Next",
                            Colors.black87, 1, TextAlign.start, FontWeight.bold, Constants.getPercentSize(nextHeight,
                                30))),


                        Container(
                          height: Constants.getPercentSize(nextHeight, 75),
                          width: Constants.getPercentSize(nextHeight, 75),
                          decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.2),
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Icon(Icons.navigate_next,color: accentColor,size: Constants.getPercentSize(nextHeight, 50),),
                          ),
                        )


                      ],
                    ),
                  ),
                ),
                Container(height: 0.3,margin: EdgeInsets.only(bottom: defMargin),color: Colors.grey.shade300,),
                Row(
                  children: [


                    InkWell(
                      onTap: () {

                        skip();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(defMargin),
                        child: ConstantWidget.getCustomText(
                            "Skip",
                            Colors.black54,

                            1,
                            TextAlign.start,
                            FontWeight.w600,
                            15),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: defMargin),
                          height: ConstantWidget.getScreenPercentSize(context, 5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: introModelList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              double size =
                              ConstantWidget.getPercentSize(
                                  ConstantWidget
                                      .getScreenPercentSize(
                                      context, 5),
                                  25);
                              return Container(
                                height: size,
                                width: size,
                                margin: EdgeInsets.only(
                                    right: (size / 1.2)),
                                decoration: BoxDecoration(
                                  color: (index == _position)
                                      ? accentColor
                                      : accentColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )

                    // InkWell(
                    //   child: Container(
                    //       height: circleSize,
                    //
                    //       width: circleSize,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //           color: Colors.white,
                    //           // color: accentColor,
                    //           ),
                    //       child:
                    //          Center(
                    //            child: Image.asset(Constants.assetsImagePath+"right-arrow.png",
                    //              color: accentColor,
                    //              // color: Colors.white,
                    //              height: ConstantWidget.getPercentSize(circleSize,55),
                    //            width: ConstantWidget.getPercentSize(circleSize,55),),
                    //          ),),
                    //   onTap: () {
                    //     onNext();
                    //   },
                    // )
                  ],
                )

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //         margin: EdgeInsets.symmetric(horizontal: defMargin),
                //         child: Align(
                //           alignment: Alignment.bottomCenter,
                //           child: Visibility(
                //             visible: true,
                //             // visible: (_position == 2),
                //             child: InkWell(
                //               child: Container(
                //                   height: ConstantWidget.getScreenPercentSize(
                //                       context, 5.5),
                //                   margin:
                //                       EdgeInsets.only(bottom: (defMargin * 7)),
                //                   width: ConstantWidget.getWidthPercentSize(
                //                       context, 22),
                //                   decoration: BoxDecoration(
                //                       color: primaryColor,
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular((defMargin / 2)))),
                //                   child: InkWell(
                //                     child: Center(
                //                       child: ConstantWidget
                //                           .getCustomTextWithoutAlign(
                //                               S.of(context).next,
                //                               Colors.white,
                //                               FontWeight.w900,
                //                               ConstantData.font18Px),
                //                     ),
                //                   )),
                //               onTap: () {
                //                 if (_position < (introModelList.length - 1)) {
                //                   _position++;
                //                   controller.jumpToPage(_position);
                //                   setState(() {});
                //                 } else {
                //                   PrefData.setIsIntro(false);
                //                   Navigator.of(context).pop(true);
                //                   Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => SignUpPage()));
                //                 }
                //               },
                //             ),
                //           ),
                //         ))
                //   ],
                // ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
  onNext(){
    if (_position <
        (introModelList.length - 1)) {
      _position++;
      controller.jumpToPage(_position);
      setState(() {});
    } else {
      skip();
    }
  }

  _onPageViewChange(int page) {
    _position = page;
    setState(() {});
  }
}
