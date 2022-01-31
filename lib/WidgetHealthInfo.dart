import 'package:flutter/material.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'Widgets.dart';
import 'PrefData.dart';

class HealthInfo extends StatefulWidget {
  @override
  _HealthInfo createState() => _HealthInfo();
}

class _HealthInfo extends State<HealthInfo> {
  String selectedGender = "Female";
  double weight = 50;
  double height = 100;
  var myController = TextEditingController();
  var myControllerIn = TextEditingController();

  var selectedDate = Constants.addDateFormat
      .format(DateTime.now().subtract(Duration(days: 5)));

  void onBackClicked() {
    Navigator.of(context).pop();
  }

  bool isKg = true;

  @override
  void initState() {
    getGender();
    myController.text = weight.toString();
    // getIsKg();
    super.initState();
  }

  // void getIsKg()async {
  //   isKg=await PrefData().getIsKgUnit();
  //   setState(() {
  //
  //   });
  // }

  Future<void> getGender() async {
    double getWeight = await PrefData().getWeight();
    double getHeight = await PrefData().getHeight();
    isKg = await PrefData().getIsKgUnit();

    weight = (isKg) ? getWeight : (Constants.kgToPound(getWeight));

    height = getHeight;
    bool male = await PrefData().getIsMale();
    if (male) {
      selectedGender = "Male";
    } else {
      selectedGender = "Female";
    }
    setState(() {});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.chevron_left),
                onPressed: () {
                  onBackClicked();
                }),
            title: getCustomText(
                "Your Health Information",
                accentColor,
                1,
                TextAlign.start,
                FontWeight.w500,
                20),
          ),
          body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  getMultiLineText("Gender", selectedGender, () {
                    showGenderSelectionDialog(context);
                  }),
                  getMultiLineText("Date of Birth", selectedDate, () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Refer step 1
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    // if (picked != null && picked != selectedDate)
                    if (picked != null &&
                        Constants.addDateFormat.format(picked) != selectedDate)
                      setState(() {
                        selectedDate = Constants.addDateFormat.format(picked);
                      });
                  }),
                  getMultiLineText("Weight", Constants.formatter.format(weight),
                      () {
                    // myController.text = weight.toString();
                    myController.text = Constants.formatter.format(weight);
                    showWeightKGDialog(true, context);
                  }),
                  getMultiLineText(
                      "Height",
                      (isKg)
                          ? Constants.formatter.format(height)
                          : Constants.meterToInchAndFeetText(height), () {
                    if (isKg) {
                      myController.text = Constants.formatter.format(height);
                    } else {
                      Constants.meterToInchAndFeet(
                          height, myController, myControllerIn);
                      // myController.text = height.toString();
                    }
                    showWeightKGDialog(false, context);
                  }),
                ],
              )),
        ),
        onWillPop: () async {
          onBackClicked();
          return false;
        });
  }

  void showGenderSelectionDialog(BuildContext contexts) async {
    List<String> ringTone = ['Female', 'Male'];
    int _currentIndex = ringTone.indexOf(selectedGender);

    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Select Gender", Colors.black87, 1),
              content: Container(
                width: 300,
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ringTone.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      groupValue: _currentIndex,
                      title: getSmallNormalTextWithMaxLine(
                          ringTone[index], Colors.black87, 1),
                      onChanged: (value) {
                        setState(() {
                          _currentIndex = value as int;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    selectedGender = ringTone[_currentIndex];
                    if (selectedGender == "Male") {
                      PrefData().setIsMale(true);
                    } else {
                      PrefData().setIsMale(false);
                    }
                    Navigator.pop(context, ringTone[_currentIndex]);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) => {
          setState(() {
            // selectedGender=value;
          })
        });
  }

  void showWeightKGDialog(bool isWeight, BuildContext contexts) async {
    // if (isWeight) {
    //   PrefData().getHeight();
    // } else {}
    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  isWeight ? "Select weight" : "Select Height",
                  Colors.black87,
                  1),
              content: Container(
                width: 300.0,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCustomText(
                        isWeight ? "Enter Weight" : "Enter Height",
                        Colors.black87,
                        1,
                        TextAlign.start,
                        FontWeight.w600,
                        20),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            // cursorRadius: Radius.circular(16.0),
                            // cursorHeight: ,
                            // cursorWidth: 16.0,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myController,
                          ),
                          flex: 1,
                        ),
                        Visibility(
                          child: Text(
                            " , ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                          ),
                          visible: (!isKg && !isWeight) ? true : false,
                        ),
                        Visibility(
                          visible: (!isKg && !isWeight) ? true : false,
                          child: Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  )),
                              // cursorRadius: Radius.circular(16.0),
                              // cursorHeight: ,
                              // cursorWidth: 16.0,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: accentColor,
                                  fontFamily: Constants.fontsFamily),
                              controller: myControllerIn,
                            ),
                            flex: 1,
                          ),
                        ),
                        getMediumNormalTextWithMaxLine(
                            isWeight
                                ? (isKg)
                                    ? "KG"
                                    : "LBS"
                                : (isKg)
                                    ? "CM"
                                    : "FT/In",
                            Colors.grey,
                            1,
                            TextAlign.start)
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
              ),
              actions: [
                new TextButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          color: accentColor,

                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: lightPink
                  ),
                    // color: lightPink,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                          color: accentColor,

                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        if (isWeight) {
                          weight = double.parse(myController.text);
                          if (isKg) {
                            PrefData().addWeight(weight);
                          } else {
                            PrefData().addWeight(Constants.poundToKg(weight));
                          }
                          Navigator.pop(context, weight);
                        } else {
                          if (isKg) {
                            height = double.parse(myController.text);
                            PrefData().addHeight(height);
                          } else {
                            double feet = double.parse(myController.text);
                            double inch = double.parse(myControllerIn.text);

                            double cm = Constants.feetAndInchToCm(feet, inch);
                            height = cm;

                            PrefData().addHeight(cm);
                          }

                          Navigator.pop(context, height);
                        }
                      } else {
                        print("getWeight===$weight");
                        Navigator.pop(context, "");
                      }
                    }),
              ],
            );
          },
        );
      },
    ).then((value) => {
          setState(() {
            // selectedGender=value;
          })
        });
  }
}
