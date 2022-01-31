import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout/DataFile.dart';
import 'package:workout/models/ModelDummySend.dart';
import 'package:workout/models/ModelWorkoutExerciseList.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'MyAssetsBar.dart';
import 'PrefData.dart';
import 'SizeConfig.dart';
import 'WidgetAllYogaWorkout.dart';
import 'WidgetChallengesExerciseList.dart';
import 'WidgetHealthInfo.dart';
import 'WidgetWorkoutExerciseList.dart';
import 'Widgets.dart';
import 'generated/l10n.dart';
import 'models/ModelChallengesMainCat.dart';
import 'models/ModelDiscover.dart';
import 'models/ModelHistory.dart';
import 'models/ModelPopularWorkout.dart';
import 'models/ModelQuickWorkout.dart';
import 'models/ModelWorkoutList.dart';

// ignore: must_be_immutable
const MethodChannel platform =
// MethodChannel('dexterx.dev/flutter_local_notifications_example');
    MethodChannel('dexterx.dev/workout');

class HomeWidget extends StatefulWidget {
  final int indexSend ;

  HomeWidget(this.indexSend);

  @override
  State<StatefulWidget> createState() => _HomeWidget(this.indexSend);
}

class Destination {
  final String title;
  final String toolbarTitle;
  final IconData icon;
  final MaterialColor color;

  const Destination(this.title, this.toolbarTitle, this.icon, this.color);
}

class TabSettings extends StatefulWidget {
  @override
  _TabSettings createState() => _TabSettings();
}

class _TabSettings extends State<TabSettings> {
  int getRestTime = 0;
  String dropdownValue = '10';
  final myController = TextEditingController();
  String remindTime = "5:30";
  int orgRemindHour = 5;
  int orgRemindMinute = 30;
  int orgRemindSec = 0;
  String remindAmPm = "AM";
  String remindDays = "";
  bool isScreenOn = false;
  bool isSwitchOn = false;

  // List<dynamic> spinnerItems1 = [
  //  10,
  //   20,30,40,50
  // ];
  // List<String> spinnerItems=[];
  List<String> spinnerItems = ['10', '20', '30', '40', '50'];

  Future<dynamic> showUnitDialog(BuildContext contexts) async {
    bool isKg = await PrefData().getIsKgUnit();

    int _currentIndex = (isKg) ? 0 : 1;

    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Change Unit System", Colors.black87, 1),
              content: Container(
                width: 400,
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
                    PrefData().setIsKgUnit((_currentIndex == 0) ? true : false);
                    // Navigator.pop(context);
                    Navigator.pop(context, ringTone[_currentIndex]);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      getIsKg();
      setState(() {});
    });
  }

  Future<void> _isScreenOn() async {
    isScreenOn = await Wakelock.enabled;
    remindTime = await PrefData().getRemindTime();
    remindAmPm = await PrefData().getRemindAmPm();
    isSwitchOn = await PrefData().getIsReminderOn();
    remindDays = await PrefData().getRemindDays();

    print(
        "setreminderget===$isSwitchOn--$remindTime--$remindAmPm--$remindDays");
    setState(() {});
  }

  Future<void> _getDailyCal() async {
    int cal = await PrefData().getDailyCalGoal();
    setState(() {
      myController.text = "$cal";
      // myController.text = "200";
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    // var locations = tz.timeZoneDatabase.locations;

    // tz.initializeTimeZones();
    final String? timeZoneName =
        await platform.invokeMethod<String>('getTimeZoneName');
    // final timeZone = TimeZone();
    // String timeZoneName = await timeZone.getTimeZoneName();
    try {
      Location getlocal =
          tz.getLocation(timeZoneName!.replaceAll("Calcutta", "Kolkata"));
      tz.setLocalLocation(getlocal);
    } catch (e) {
      print(e);
      Location getlocal = tz.getLocation(Constants.defTimeZoneName);
      tz.setLocalLocation(getlocal);
    }
    // tz.setLocalLocation(TimeZone.getDefault().id);
  }

  bool isKg = true;

  // Future<String> getTimeZoneName() async => FlutterNativeTimezone.getLocalTimezone();

  @override
  void initState() {
    _configureLocalTimeZone();
    _getDailyCal();
    _getRestTimes();
    _isScreenOn();
    getIsKg();

    // spinnerItems = json[spinnerItems1.toString()].map((el) => el.toString()).toList()
    // spinnerItems =spinnerItems1.cast<String>();

    super.initState();
  }

  void getIsKg() async {
    isKg = await PrefData().getIsKgUnit();
    setState(() {});
  }

  _getRestTimes() async {
    getRestTime = await PrefData().getRestTime();
    dropdownValue = "$getRestTime";
    print("fontsizes==$_getRestTimes");
  }

  openReminderDialog() async {
    double dialogWidth = 300;
    // var dialogWidth=MediaQuery.of(context).size.width-50;
    var checkDialogWidth = dialogWidth - 30;
    List<String> selectedList = [];
    List<String> selectedOrgDayList = [];
    remindDays = await PrefData().getRemindDays();
    if (remindDays.isNotEmpty) {
      var getData = jsonDecode(remindDays);
      selectedList = new List<String>.from(getData);
      // List<String> jsonDecodeTags = new List<String>.from(getData);
    }
    List<String> daysDateTimeList = [
      DateTime.sunday.toString(),
      DateTime.monday.toString(),
      DateTime.tuesday.toString(),
      DateTime.wednesday.toString(),
      DateTime.thursday.toString(),
      DateTime.friday.toString(),
      DateTime.saturday.toString()
    ];

    List<String> daysList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    if (selectedList.length > 0) {
      selectedOrgDayList = [];
      selectedList.forEach((element) {
        int i = daysList.indexOf(element);
        selectedOrgDayList.add(daysDateTimeList[i]);
      });
    }

    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                content: Container(
                  width: dialogWidth,
                  // width: 350.0,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Set Workout Reminder", Colors.black, 1,
                          TextAlign.start, FontWeight.normal, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: () {
                              // Future<TimeOfDay> selectedTime =
                              showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                orgRemindHour = value!.hour;
                                orgRemindMinute = value.minute;
                                print(
                                    "setreminder==${value.hour}--${value.hourOfPeriod}");
                                String ampm = "PM";
                                if (value.period == DayPeriod.am) {
                                  ampm = "AM";
                                }
                                String time =
                                    (value.hourOfPeriod < 10 ? "0" : "") +
                                        value.hourOfPeriod.toString() +
                                        ":" +
                                        (value.minute < 10 ? "0" : "") +
                                        value.minute.toString();
                                // String s = jsonEncode(values);
                                // print(
                                //     "gteval===--$time==$s--${value.hourOfPeriod}");
                                // _dataHelper.addReminderData(time, s, "1");
                                // checkReminderData();
                                setState(() {});
                                remindTime = time;
                                remindAmPm = ampm;
                                return value;
                              });
                            },
                            child: getLargeBoldTextWithMaxLine(
                                remindTime, Colors.black87, 1),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: getSmallNormalText(
                                remindAmPm, Colors.black87, TextAlign.start),
                            flex: 1,
                          ),
                          Switch(
                            value: isSwitchOn,
                            onChanged: (value) {
                              setState(() {
                                isSwitchOn = value;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: double.infinity,
                        height: (checkDialogWidth / 7),
                        // height: (300 / 7.8) + 20,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String getName = daysList[index];
                            bool isSelected = selectedList.contains(getName);
                            return InkWell(
                              onTap: () {
                                if (isSwitchOn) {
                                  setState(() {
                                    if (selectedList.contains(getName)) {
                                      selectedList.remove(getName);
                                      selectedOrgDayList.remove(
                                          daysDateTimeList[index].toString());
                                    } else {
                                      selectedList.add(getName);
                                      selectedOrgDayList.add(
                                          daysDateTimeList[index].toString());
                                    }
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(1),
                                width: (checkDialogWidth / 7) - 2,
                                // width: 300 / 7.8,
                                height: (checkDialogWidth / 7) - 2,
                                // height: 300 / 7.8,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? accentColor
                                        : Colors.black12,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: getExtraSmallNormalTextWithMaxLine(
                                      "${getName[0]}",
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      1,
                                      TextAlign.center),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  new TextButton(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                      style: TextButton.styleFrom(backgroundColor: lightPink),
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        if (selectedList.length > 0) {
                          String s = jsonEncode(selectedList);
                          PrefData().addReminderDays(s);
                        }
                        PrefData().setIsReminderOn(isSwitchOn);
                        print(
                            "setreminder===$isSwitchOn--$remindTime--$remindAmPm");
                        PrefData().addReminderTime(remindTime);
                        PrefData().addReminderAmPm(remindAmPm);
                        // checkReminderData();
                        _cancelAllNotifications();
                        if (selectedOrgDayList.length > 0) {
                          selectedOrgDayList.forEach((element) {
                            _scheduleWeeklyMondayTenAMNotification(
                                int.parse(element));
                          });
                        }
                        // _scheduleDailyTenAMNotification();
                        Navigator.pop(context);
                      })
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  TZDateTime _nextInstanceOfMondayTenAM(int day) {
    TZDateTime scheduledDate = _nextInstanceOfTenAM();
    print("schedule===${scheduledDate.weekday}--${DateTime.monday}");
    // while (scheduledDate.weekday != DateTime.monday || scheduledDate.weekday!=DateTime.tuesday) {
    // int i = 1;
    // while (i == 0) {
    //   print("schedule123===${scheduledDate.weekday}--${DateTime.monday}--$i");
    //   if (scheduledDate.weekday != DateTime.tuesday ||
    //       scheduledDate.weekday != DateTime.monday) {
    //     i++;
    //     scheduledDate = scheduledDate.add(const Duration(days: 1));
    //   }
    //   else {
    //     i = 0;
    //   }
    // }
    // while (scheduledDate.weekday != DateTime.monday) {
    while (scheduledDate.weekday != day) {
      print("schedule123===${scheduledDate.weekday}--${DateTime.monday}");
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> _scheduleDailyTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'daily scheduled notification title',
  //       'daily scheduled notification body',
  //       _nextInstanceOfTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //             'daily notification channel id',
  //             'daily notification channel name',
  //             'daily notification description'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }
  //
  // Future<void> _repeatNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails('repeating channel id',
  //           'repeating channel name', 'repeating description');
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
  //       'repeating body', RepeatInterval.weekly, platformChannelSpecifics,
  //       androidAllowWhileIdle: true);
  // }

  Future<void> _scheduleWeeklyMondayTenAMNotification(int day) async {
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     day,
    //     'workout reminder',
    //     'Your are one step away to connect with GeeksforGeeks',
    //     // _nextInstanceOfTenAM(),
    //     _nextInstanceOfMondayTenAM(day),
    //     const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //           'sohamyoga.home.ui1', 'sohamyoga.home.ui channel',
    //           channelDescription: 'Workout Reminder'),
    //     ),
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //
    //     // matchDateTimeComponents: DateTimeComponents.time);
    //     matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> _cancelAllNotifications() async {
    // await flutterLocalNotificationsPlugin.cancelAll();
  }

  TZDateTime _nextInstanceOfTenAM() {
    final TZDateTime now = tz.TZDateTime.now(tz.local);
    TZDateTime scheduledDate = TZDateTime(
        tz.local, now.year, now.month, now.day, orgRemindHour, orgRemindMinute);
    print("schedule===$scheduledDate--$now--${scheduledDate.isBefore(now)}");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Future<void> checkReminderData() async {
  //   DateTime currentTime = DateTime.now();
  //   DateFormat formatter = DateFormat('hh:mm a', "en");
  //   DateFormat formatterDays = DateFormat('EEE', "en");
  //   // DateFormat formatter = DateFormat('yyyy-MM-dd');
  //   final String formatted = formatter.format(currentTime);
  //   final String formattedDay = formatterDays.format(currentTime);
  //   // final DateTime now = DateTime.now();
  //   // final int isolateId = Isolate.current.hashCode;
  //   print("Hello, world");
  //   FlutterLocalNotificationsPlugin flip =
  //       new FlutterLocalNotificationsPlugin();
  //
  //   // app_icon needs to be a added as a drawable
  //   // resource to the Android head project.
  //   var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var ios = new IOSInitializationSettings();
  //   print("insidereminder===True");
  //
  //   // initialise settings for both Android and iOS device.
  //   var settings = new InitializationSettings(android: android, iOS: ios);
  //   flip.initialize(settings);
  //   bool isOn = await PrefData().getIsReminderOn();
  //   String time = await PrefData().getRemindTime();
  //   String remindAmPm = await PrefData().getRemindAmPm();
  //   String remindTime = time + " " + remindAmPm;
  //   if (isOn) {
  //     String daysSelected = await PrefData().getRemindDays();
  //     if (daysSelected.isNotEmpty) {
  //       var getData = jsonDecode(daysSelected);
  //       List<String> jsonDecodeTags = new List<String>.from(getData);
  //
  //       if (jsonDecodeTags.contains(formattedDay) && formatted == remindTime) {
  //         _showNotificationWithDefaultSound(flip, true);
  //       }
  //     }
  //   }
  //   // print("chkremind===--${jsonDecodeTags.toString()}==$formattedDay");
  //
  //   print("eminder_notify==true$formatted===$formattedDay==$remindTime");
  // }

  // Future _showNotificationWithDefaultSound(flip, bool val) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'channelWorkouts', 'Flutter Workouts',
  //       channelDescription: 'description',
  //       importance: Importance.max,
  //       priority: Priority.high);
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //
  //   // initialise channel platform for both Android and iOS device.
  //   var platformChannelSpecifics = new NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //
  //   if (val) {
  //     await flip.show(0, "Workout", 'Reminder', platformChannelSpecifics,
  //         payload: 'Default_Sound');
  //   } else {
  //     await flip.show(
  //         0,
  //         'GeeksforGeeks',
  //         'Your are one step away to connect with GeeksforGeeks',
  //         platformChannelSpecifics,
  //         payload: 'Default_Sound');
  //   }
  // }

  openAlertBox() {
    bool isValidate = true;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                content: Container(
                  width: 300.0,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Set Your Daily Goal", Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Expanded(
                          //   child: getCustomText(
                          //       "Set Your Daily Goal",
                          //       Colors.black,
                          //       1,
                          //       TextAlign.start,
                          //       FontWeight.w600,
                          //       20),
                          //   flex: 1,
                          // ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  errorText: !isValidate
                                      ? "kcal cannot be smaller than ${myController.text}?"
                                      : null,
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
                          getMediumNormalTextWithMaxLine(
                              "Kcal", Colors.grey, 1, TextAlign.start)
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
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                      // color: lightPink,
                      style: TextButton.styleFrom(backgroundColor: lightPink),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        if (myController.text.isNotEmpty) {
                          double val = double.parse(myController.text);
                          if (val > 5000) {
                            setState(() {
                              isValidate = false;
                            });
                            // return false;
                          } else {
                            isValidate = true;
                            PrefData().addDailyCalGoal(val.toInt());
                            _getDailyCal();
                          }
                          Navigator.pop(context);
                          // return true;
                        } else {
                          _getDailyCal();
                          // myController.text = "200";
                          Navigator.pop(context);
                        }
                      })
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  // openSoundOptionAlertBox() {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //           contentPadding: EdgeInsets.only(top: 10.0),
  //           content: Container(
  //             width: 300.0,
  //             padding:
  //             EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 getCustomText("Sound Options", Colors.black87, 1,
  //                     TextAlign.start, FontWeight.w600, 20),
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 Row(
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //                     Icon(
  //                       Icons.volume_up,
  //                       color: Colors.black54,
  //                     ),
  //                     Expanded(
  //                       child: getSmallNormalTextWithMaxLine(
  //                           "Mute", Colors.black, 1),
  //                       flex: 1,
  //                     ),
  //                     Switch(
  //                       value:isSwitched,
  //                       onChanged: (value) {
  //                         setState(() {
  //                           isSwitched=value;
  //                         });
  //                       },
  //                       activeTrackColor: Colors.grey,
  //                       activeColor: accentColor,
  //                     )
  //                     // TextFormField(
  //                     //   decoration: InputDecoration(
  //                     //       labelText: 'Enter your username'
  //                     //   ),
  //                     // )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 7,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             new FlatButton(
  //                 child: Text(
  //                   'SAVE',
  //                   style: TextStyle(
  //                       fontFamily: Constants.fontsFamily,
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.normal),
  //                 ),
  //                 textColor: accentColor,
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 }),
  //           ],
  //         );
  //       });
  // }

  Future<void> share() async {
    String share = "${S.of(context).app_name}\n${Constants.getAppLink()}";
    await Share.share(
      share,
    );

    // Share.share(S.of(context).app_name, subject: S.of(context).app_name);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double textMargin = SizeConfig.safeBlockHorizontal! * 2.5;
    // double textMargin = SizeConfig.safeBlockHorizontal! * 1.5;
    return Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(textMargin),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Padding(
            padding: EdgeInsets.all(textMargin),
            child: getSettingTabTitle(S.of(context).workout),
          ),
          Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.free_breakfast_outlined, "Training Rest"),
                    flex: 1,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black54,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: blueButton,
                        fontSize: 18,
                        fontFamily: Constants.fontsFamily),
                    underline: Container(
                      height: 2,
                      color: Colors.black12,
                    ),
                    onChanged: (value) {
                      setState(() {
                        // int i = spinnerItems.indexOf(value);
                        PrefData().addRestTime(int.parse(value!));
                        dropdownValue = value;
                      });
                    },
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value + " Sec"),
                      );
                    }).toList(),
                    // items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                    //   return DropdownMenuItem<String>(
                    //     value: value,
                    //     child: Text(value),
                    //   );
                    // }).toList(),
                  )
                ],
              )),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.adjust_outlined, "Daily Goal"),
                    flex: 1,
                  ),
                  getCustomText("${myController.text} kcal", blueButton, 1,
                      TextAlign.start, FontWeight.normal, 18)
                ],
              ),
            ),
            onTap: () {
              openAlertBox();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.volume_up_rounded, "Sound Options"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () async {
              bool isSwitched = await PrefData().getIsMute();
              bool isSwitchedSound = await PrefData().getIsSoundOn();

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      contentPadding: EdgeInsets.only(top: 10.0),
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: 300.0,
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15, left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                getCustomText("Sound Options", Colors.black87,
                                    1, TextAlign.start, FontWeight.w600, 20),
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
                                          S.of(context).ttsVoice,
                                          Colors.black,
                                          1),
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
                              'SAVE',
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  fontSize: 15,
                                  color: accentColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              PrefData().setIsMute(isSwitched);
                              PrefData().setIsSoundOn(isSwitchedSound);
                              Navigator.pop(context);
                            }),
                      ],
                    );
                  });
            },
          ),
          Padding(
            padding: EdgeInsets.all(textMargin),
            child: getSettingTabTitle("GENERAL"),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingMultiLineText(Icons.alarm,
                        "Set Workout Reminder", remindTime + " " + remindAmPm),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              openReminderDialog();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.add_box_outlined, "Health Info"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new HealthInfo(),
                ),
              );
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingMultiLineText(
                        Icons.ac_unit,
                        "Change Unit System",
                        (isKg) ? ringTone[0] : ringTone[1]),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              showUnitDialog(context);
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.mobile_screen_share_outlined, "Keep Screen On"),
                    flex: 1,
                  ),
                  Switch(
                    value: isScreenOn,
                    onChanged: (value) {
                      setState(() {
                        isScreenOn = value;
                        Wakelock.toggle(enable: isScreenOn);
                      });
                    },
                    activeTrackColor: accentColor,
                    activeColor: accentColor,
                  )
                ],
              ),
            ),
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.all(textMargin),
            child: getSettingTabTitle("SUPPORT US"),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.share, "Share With Friends"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              share();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(Icons.mail, "Feedback"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              print("feedbackclick");
              // BetterFeedback.of(context).show();
              BetterFeedback.of(context).show((p0) async {
                final screenshotFilePath =
                    await writeImageToStorage(p0.screenshot);
                final Email email = Email(
                  body: p0.text,
                  subject: "Feedback",
                  recipients: ['demo@gmail.com'],
                  // recipients: ['john.doe@flutter.dev'],
                  attachmentPaths: [screenshotFilePath],
                  isHTML: false,
                );
                await FlutterEmailSender.send(email);
              });
              // BetterFeedback.of(context)?.show(
              //   (
              //     String feedbackText,
              //     Uint8List feedbackScreenshot,
              //   ) async {
              //     // draft an email and send to developer
              //     final screenshotFilePath =
              //         await writeImageToStorage(feedbackScreenshot);
              //
              //     final Email email = Email(
              //       body: feedbackText,
              //       subject: "Feedback",
              //       recipients: ['demo@gmail.com'],
              //       // recipients: ['john.doe@flutter.dev'],
              //       attachmentPaths: [screenshotFilePath],
              //       isHTML: false,
              //     );
              //     await FlutterEmailSender.send(email);
              //   },
              // );
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(Icons.star_rate, "Rate Us"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              LaunchReview.launch();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.policy_rounded, "Privacy Policy"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              _launchURL();
            },
          ),
          // InkWell(
          //   child: Container(
          //     padding: EdgeInsets.all(textMargin),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: getSettingSingleLineText(Icons.info, "About"),
          //           flex: 1,
          //         ),
          //       ],
          //     ),
          //   ),
          //   onTap: () {},
          // )
        ]));
  }
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

_launchURL() async {
  await launch("https://google.com");

  // // const url = 'https://www.google.com';
  // const url = 'https://flutter.dev';
  //
  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   throw 'Could not launch $url';
  // }
}

List<String> ringTone = ['Meters and kilograms', 'Pounds,Feet and inches'];

class TabHome extends StatefulWidget {
  @override
  _TabHome createState() => _TabHome();
}

class _TabHome extends State<TabHome> with TickerProviderStateMixin {
  List<ModelChallengesMainCat> challengesList = DataFile.challengesMainCat();
  List<Widget> progressWidget = [];

  //
  AnimationController? animationController;
  double getCal = 0;
  int getTotalWorkout = 0;
  List<ModelHistory> priceList = [];
  int getTime = 0;
  double listLength = 1;

  // final AnimationController animationController;
  Animation<dynamic>? animation;

  void _calcTotal() async {
    // priceList = await _dataHelper.calculateTotalWorkout();
    // if (priceList != null && priceList.length > 0) {
    //   getTotalWorkout = priceList.length;
    //   priceList.forEach((price) {
    //     // getCal = (price['kcal']) + getCal;
    //     // getTime = (price['total_duration']) + getTime;
    //     getCal = double.parse(price.kCal!) + getCal;
    //     getTime = price.totalDuration! + getTime;
    //   });
    //   // getTime = getTotalWorkout * 2;
    //
    //   // print("getval=$getCal");
    //
    // }

    setState(() {
      getTotalWorkout = 5;
      getCal = 15 + getCal;
      getTime = 10 + getTime;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      animationController!.dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  List<ModelWorkoutList> workoutList = DataFile.getWorkoutList();

  @override
  void initState() {
    progressWidget.add(getProgressDialog());
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _calcTotal();
    // _dataHelper.getAllChallengesList().then((value) {
    //   challengesList = value;
    //   setState(() {});
    // });
    super.initState();
  }

  List<ModelWorkoutExerciseList> _exerciseList =
      DataFile.getWorkoutExerciseList();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sliderHeight = SizeConfig.safeBlockVertical! * 24;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double sliderRadius = Constants.getPercentSize(sliderHeight, 15);

    animationController!.forward();
    List<Widget>? imageSliders = challengesList
            .map((item) {
              Color color="#99d8ef".toColor();

              int position= item.id!-1;

              if(position % 4 == 0){
                color="#aeacf9".toColor();
              }else if(position % 4 == 1){
                color="#fda0dd".toColor();
              }else if(position % 4 == 2){
                color="#81c1fe".toColor();
              }

              return Container(
                child: Container(
                  margin: EdgeInsets.only(right:Constants.getWidthPercentSize(context, 5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(sliderRadius)),
                    color: color,
                  ),

                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          new WidgetChallengesExerciseList(item),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(sliderRadius)),
                      child: Stack(
                        children: <Widget>[



                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(Constants.assetsImagePath+item.icon!),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 3),
                                    child:
                                    ConstantWidget.getTextWidgetWithFont(
                                        item.title!.toUpperCase(),
                                        Colors.black87,
                                        TextAlign.start,
                                        FontWeight.w200,
                                        ConstantWidget.getPercentSize(
                                            sliderHeight, 12),
                                        Constants.boldFontsFamily),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: ConstantWidget
                                        .getTextWidgetWithFont(
                                        "${item.weeks} ${S.of(context).week}",
                                          Colors.black54,
                                        TextAlign.start,
                                        FontWeight.normal,
                                        Constants.getPercentSize(
                                            sliderHeight, 8),
                                        bebasneue),
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: Constants.getPercentSize(
                                            sliderHeight, 30),
                                        lineWidth: 5,
                                        progressColor: Colors.amber,
                                        backgroundColor: Colors.grey.shade300,
                                        center: ConstantWidget
                                            .getTextWidgetWithFont(
                                            "${10}%",
                                            Colors.white,
                                            TextAlign.start,
                                            FontWeight.w100,
                                            Constants.getPercentSize(sliderHeight, 8),
                                            bebasneue),

                                        // getCustomText(
                                        //     "${10}%",
                                        //     Colors
                                        //         .grey,
                                        //     1,
                                        //     TextAlign
                                        //         .start,
                                        //     FontWeight
                                        //         .normal,
                                        //     Constants.getPercentSize(Constants.getPercentSize(screenWidth, 10),
                                        //         30))
                                      ),



                                      // getCustomText(
                                      //     "${item.weeks} ${S.of(context).week}",
                                      //     Colors.white,
                                      //     1,
                                      //     TextAlign
                                      //         .center,
                                      //     FontWeight
                                      //         .normal,
                                      //     Constants
                                      //         .getPercentSize(
                                      //             screenWidth,
                                      //             3))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                ),
              );
    }).toList();

    double topMargin = SizeConfig.safeBlockHorizontal! * 3;
    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;

    int _crossAxisCount = 2;
    // double screenWidth=SizeConfig.safeBlockHorizontal*100;
    double _crossAxisSpacing = 10.0;
    // double widthItem = (screenWidth-(_crossAxisSpacing*_crossAxisCount))/_crossAxisCount;
    var widthItem =
        (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
            _crossAxisCount;
    double radius = Constants.getScreenPercentSize(context, 2);
    double heightItem = Constants.getScreenPercentSize(context, 33);
    double imgHeight = Constants.getPercentSize(heightItem, 70);
    double titleHeight = Constants.getPercentSize(imgHeight, 20);
    double remainHeight = heightItem - imgHeight;
    double _aspectRatio = widthItem / heightItem;

    int totalSec = 0;
    for (int i = 0; i < _exerciseList.length; i++) {
      totalSec = totalSec + int.parse(_exerciseList[i].duration!);
    }

    double height = SizeConfig.safeBlockVertical! * 25;
    double width = SizeConfig.safeBlockHorizontal! * 65;

    double sWidth = width / 2;
    double iconSize = ConstantWidget.getPercentSize(remainHeight, 18);

    return
        // (challengesList == null)

        Container(
      width: double.infinity,
      height: double.infinity,
      color: bgDarkWhite,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            margin: EdgeInsets.only(top: topMargin, bottom: topMargin),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //     color: Colors.black12),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.symmetric(vertical: 10),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(radius))
                    ),
                    child: Column(
                      children: [
                        ConstantWidget.getTextWidgetWithFont(
                            "1",
                            accentColor,
                            TextAlign.center,
                            FontWeight.bold,
                            Constants.getPercentSize(screenWidth, 6),
                            bebasneue),
                        // getCustomText(
                        //     "1",
                        //     primaryColor,
                        //     1,
                        //     TextAlign.center,
                        //     FontWeight.bold,
                        //     Constants.getPercentSize(screenWidth, 5)),

                        // ConstantWidget.getTextWidgetWithFont(S.of(context).workouts,
                        //     Colors.black87, TextAlign.center, FontWeight.w600, 12, bebasneue),

                        getCustomText(S.of(context).workouts, Colors.black87, 1,
                            TextAlign.center, FontWeight.w600, 12)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(radius))
                    ),
                    child: Column(
                      children: [
                        ConstantWidget.getTextWidgetWithFont(
                            "0.04",
                            accentColor,
                            TextAlign.center,
                            FontWeight.bold,
                            Constants.getPercentSize(screenWidth, 6),
                            bebasneue),

                        // getCustomText(
                        //     "0.04",
                        //     Colors.black87,
                        //     1,
                        //     TextAlign.center,
                        //     FontWeight.bold,
                        //     Constants.getPercentSize(screenWidth, 5)),
                        // getMediumBoldItalicText("$getCal", Colors.black87),
                        getCustomText(S.of(context).kcal, Colors.black87, 1,
                            TextAlign.center, FontWeight.w600, 12)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(radius))
                    ),
                    child: Column(
                      children: [
                        ConstantWidget.getTextWidgetWithFont(
                            "00:00:19",
                            accentColor,
                            TextAlign.center,
                            FontWeight.bold,
                            Constants.getPercentSize(screenWidth, 6),
                            bebasneue),
                        // getCustomText(
                        //     "00:00:19",
                        //     Colors.black87,
                        //     1,
                        //     TextAlign.center,
                        //     FontWeight.bold,
                        //     Constants.getPercentSize(screenWidth, 5)),
                        // getMediumBoldItalicText(Constants.getTimeFromSec(getTime), Colors.black87),
                        getCustomText("Duration", Colors.black87, 1,
                            TextAlign.center, FontWeight.w600, 12)

                        // ConstantWidget.getTextWidgetWithFont("Duration",
                        //     Colors.black87, TextAlign.center, FontWeight.bold, 12, bebasneue),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(textMargin),
              child: getTitleTexts(S.of(context).challenges)),
          CarouselSlider(
              items:  imageSliders ,
              options: CarouselOptions(
                  height: sliderHeight,
                  autoPlay: false,
                  pageSnapping: true,
                  viewportFraction: 0.9,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false)),

          Padding(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(child: getTitleTexts(S.of(context).yoga)),

                  InkWell(

                    onTap: (){
Navigator.push(context, MaterialPageRoute(builder: (context) => WidgetAllYogaWorkout(),));
                    },
                    child: getCustomText(
                    S.of(context).seeAll, accentColor, 1, TextAlign.center, FontWeight.bold, 15),
                  )
                ],
              )),
          // FutureBuilder<List<ModelWorkoutList>>(
          //   future: _dataHelper.getWorkoutList(),
          //   builder: (context, snapshot) {
          //     // print("getdata===${snapshot.data.length}");
          //     if (snapshot.hasData && snapshot.data != null) {
          //       List<ModelWorkoutList> workoutList = snapshot.data!;
          //       double imageSize = Constants.getPercentSize(heightItem, 75);
          //       double iconSize = Constants.getPercentSize(heightItem, 8);
          //       return GridView.count(
          //         // mainAxisSpacing: _crossAxisSpacing,
          //         crossAxisCount: _crossAxisCount,
          //         childAspectRatio: _aspectRatio,
          //         // crossAxisSpacing: _crossAxisSpacing,
          //         // mainAxisSpacing: _crossAxisSpacing,
          //         shrinkWrap: true,
          //         padding: EdgeInsets.only(
          //             left: _crossAxisSpacing,
          //             right: _crossAxisSpacing,
          //             bottom: _crossAxisSpacing),
          //         primary: false,
          //         children: List.generate(workoutList.length, (index) {
          //           ModelWorkoutList _workoutList = workoutList[index];
          //           return InkWell(
          //             child: Container(
          //
          //               height: double.infinity,
          //               // padding: EdgeInsets.all(7),
          //               margin: EdgeInsets.all(7),
          //               decoration: BoxDecoration(
          //
          //
          //                 borderRadius:
          //                 BorderRadius.all(Radius.circular(10)),
          //                 color: Colors.transparent,
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey,
          //                     offset: Offset(0.0, 1.5), //(x,y)
          //                     blurRadius: 2.5,
          //                   ),
          //                 ],
          //               ),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //
          //
          //                   Expanded(
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         image: DecorationImage(
          //                             image: AssetImage(
          //                               Constants.assetsImagePath +
          //                                   _workoutList.image!,),
          //                             fit: BoxFit.cover),
          //                         borderRadius: BorderRadius.only(
          //                             topLeft: Radius.circular(7),
          //                             topRight: Radius.circular(7)),
          //                       ),
          //                     ),
          //                     // child: SizedBox(),
          //                     flex: 1,
          //                   ),
          //                   Container(
          //                     width: double.infinity,
          //                     padding: EdgeInsets.symmetric(
          //                         vertical: Constants.getPercentSize(
          //                             height, 2),
          //                         horizontal: Constants.getPercentSize(
          //                             height, 2.8)),
          //                     decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.only(
          //                           bottomLeft: Radius.circular(7),
          //                           bottomRight: Radius.circular(7)),
          //                     ),
          //                     child: Column(
          //                       children: [
          //                         getCustomText(
          //                             _workoutList.name!,
          //                             Colors.black,
          //                             1,
          //                             TextAlign.start,
          //                             FontWeight.w600,
          //                             Constants.getPercentSize(
          //                                 height, 7)),
          //
          //                         SizedBox(height: 5,),
          //
          //
          //                         Row(
          //                           children: [
          //                             Row(
          //                               crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                               children: [
          //                                 Image.asset(
          //                                   Constants.assetsImagePath + "dumbbell.png",
          //                                   height: iconSize,
          //                                   width: iconSize,
          //                                   color: Colors.black,
          //                                 ),
          //                                 SizedBox(width: ConstantWidget.getPercentSize(sWidth, 5)),
          //                                 ConstantWidget.getTextWidget("Beginner", Colors.black,
          //                                     TextAlign.start, FontWeight.w400, ConstantWidget.getPercentSize(sWidth, 8)),
          //                               ],
          //                             ),
          //                             SizedBox(
          //                               width:
          //                               8,
          //                             ),
          //                             Row(
          //                               crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                               mainAxisAlignment:
          //                               MainAxisAlignment.start,
          //                               children: [
          //                                 Image.asset(
          //                                   Constants.assetsImagePath + "calendar.png",
          //                                   height: iconSize,
          //                                   width: iconSize,
          //                                   color: Colors.black,
          //                                 ),
          //                                 SizedBox(width: Constants.getPercentSize(sWidth, 5)),
          //                                 ConstantWidget.getTextWidget("4 Week", Colors.black,
          //                                     TextAlign.start, FontWeight.w200, ConstantWidget.getPercentSize(sWidth, 8)),
          //                               ],
          //                             ),
          //                           ],
          //                         )
          //
          //                         // FutureBuilder<
          //                         //     List<ModelWorkoutExerciseList>>(
          //                         //   future: _dataHelper
          //                         //       .getWorkoutExerciseListByTableAndId(
          //                         //       height.id!,
          //                         //       Constants.getTableNames(
          //                         //           Constants.quickWorkoutId)),
          //                         //   builder: (context, snapshot) {
          //                         //     String s = "";
          //                         //     if (snapshot.hasData) {
          //                         //       s = snapshot.data!.length
          //                         //           .toString() +
          //                         //           " Workouts";
          //                         //     }
          //                         //     return getCustomText(
          //                         //         s,
          //                         //         Colors.black,
          //                         //         1,
          //                         //         TextAlign.start,
          //                         //         FontWeight.w200,
          //                         //         Constants.getPercentSize(
          //                         //             height, 6.5));
          //                         //   },
          //                         // ),
          //                       ],
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             onTap: () {
          //
          //               sendToWorkoutList(
          //                   context, _workoutList, Constants.workoutId);
          //             },
          //           );
          //         }),
          //       );
          //       // return ListView.builder(
          //       //     itemCount: workoutList.length,
          //       //     primary: false,
          //       //     shrinkWrap: true,
          //       //     itemBuilder: (context, index) {
          //       //       final Animation<double> animation =
          //       //       Tween<double>(begin: 0.0, end: 1.0).animate(
          //       //         // Tween<double>(begin: 0.0, end: 1.0).animate(
          //       //         CurvedAnimation(
          //       //           parent: animationController,
          //       //           curve: Interval((1 / workoutList.length) * index,
          //       //               1.0,
          //       //               curve: Curves.fastOutSlowIn),
          //       //         ),
          //       //       );
          //       //       animationController.forward();
          //       //
          //       //       ModelWorkoutList _modelWorkoutList = workoutList[index];
          //       //       return AnimatedBuilder(
          //       //         animation: animationController,
          //       //         builder: (context, child) {
          //       //           return FadeTransition(
          //       //               opacity: animation,
          //       //               child: Transform(
          //       //                 transform: Matrix4.translationValues(
          //       //                     0.0, 50 * (1.0 - animation.value), 0.0),
          //       //                 child: InkWell(
          //       //                   child: Hero(
          //       //                       tag: _modelWorkoutList.id,
          //       //                       child: Container(
          //       //                         margin: EdgeInsets.only(
          //       //                             left: 18,
          //       //                             top: 12,
          //       //                             bottom: 12,
          //       //                             right: 12),
          //       //                         width: double.infinity,
          //       //                         height:
          //       //                         SizeConfig.safeBlockHorizontal! * 30,
          //       //                         child: Stack(
          //       //                           children: [
          //       //                             Padding(
          //       //                               padding: EdgeInsets.only(
          //       //                                   top: 10, bottom: 10),
          //       //                               child: Container(
          //       //                                 width: double.infinity,
          //       //                                 height: double.infinity,
          //       //                                 // color: Colors.white,
          //       //                                 decoration: BoxDecoration(
          //       //                                     borderRadius:
          //       //                                     BorderRadius.circular(
          //       //                                         12),
          //       //                                     boxShadow: [
          //       //                                       BoxShadow(
          //       //                                         color: Colors.grey,
          //       //                                         offset: Offset(
          //       //                                             0.0, 1.0), //(x,y)
          //       //                                         blurRadius: 1.0,
          //       //                                       ),
          //       //                                     ],
          //       //                                     color: Colors.white),
          //       //                                 child: Row(
          //       //                                   mainAxisSize:
          //       //                                   MainAxisSize.max,
          //       //                                   children: [
          //       //                                     ClipRRect(
          //       //                                       borderRadius:
          //       //                                       BorderRadius.only(
          //       //                                           topLeft: Radius
          //       //                                               .circular(12),
          //       //                                           bottomLeft: Radius
          //       //                                               .circular(
          //       //                                               12)),
          //       //                                       child: Image(
          //       //                                         image: AssetImage(
          //       //                                             "${Constants
          //       //                                                 .assetsImagePath}${_modelWorkoutList
          //       //                                                 .image}"),
          //       //                                         // width: 200,
          //       //                                         // height: 200,
          //       //                                         width: SizeConfig
          //       //                                             .safeBlockHorizontal! *
          //       //                                             38,
          //       //                                         height: double
          //       //                                             .infinity,
          //       //                                         fit: BoxFit.fill,
          //       //                                       ),
          //       //                                     ),
          //       //                                     Expanded(
          //       //                                       child: Container(
          //       //                                         width: double
          //       //                                             .infinity,
          //       //                                         height: double
          //       //                                             .infinity,
          //       //                                         margin: EdgeInsets
          //       //                                             .only(
          //       //                                             top: 10,
          //       //                                             bottom: 10),
          //       //                                         padding:
          //       //                                         EdgeInsets.only(
          //       //                                             left: 15,
          //       //                                             right: 15,
          //       //                                             top: 7,
          //       //                                             bottom: 7),
          //       //                                         child: Row(
          //       //                                           mainAxisAlignment:
          //       //                                           MainAxisAlignment
          //       //                                               .start,
          //       //                                           children: [
          //       //                                             Expanded(
          //       //                                               child: Column(
          //       //                                                 mainAxisAlignment:
          //       //                                                 MainAxisAlignment
          //       //                                                     .center,
          //       //                                                 crossAxisAlignment:
          //       //                                                 CrossAxisAlignment
          //       //                                                     .start,
          //       //                                                 children: [
          //       //                                                   getCustomText(
          //       //                                                       "${_modelWorkoutList
          //       //                                                           .name} ${S
          //       //                                                           .of(
          //       //                                                           context)
          //       //                                                           .workout_small}",
          //       //                                                       Colors
          //       //                                                           .black,
          //       //                                                       1,
          //       //                                                       TextAlign
          //       //                                                           .center,
          //       //                                                       FontWeight
          //       //                                                           .bold,
          //       //                                                       Constants
          //       //                                                           .getPercentSize(
          //       //                                                           SizeConfig
          //       //                                                               .safeBlockHorizontal! *
          //       //                                                               30,
          //       //                                                           16)),
          //       //                                                   getCustomText(
          //       //                                                       S
          //       //                                                           .of(
          //       //                                                           context)
          //       //                                                           .transformation,
          //       //                                                       Colors
          //       //                                                           .black87,
          //       //                                                       3,
          //       //                                                       TextAlign
          //       //                                                           .start,
          //       //                                                       FontWeight
          //       //                                                           .w300,
          //       //                                                       Constants
          //       //                                                           .getPercentSize(
          //       //                                                           SizeConfig
          //       //                                                               .safeBlockHorizontal! *
          //       //                                                               30,
          //       //                                                           12))
          //       //                                                 ],
          //       //                                               ),
          //       //                                               flex: 1,
          //       //                                             )
          //       //                                           ],
          //       //                                         ),
          //       //                                       ),
          //       //                                       flex: 1,
          //       //                                     )
          //       //                                   ],
          //       //                                 ),
          //       //                               ),
          //       //                             ),
          //       //
          //       //                             // Align(
          //       //                             //   alignment: Alignment.centerRight,
          //       //                             //   child: Image(
          //       //                             //     image: AssetImage(
          //       //                             //         "${Constants.ASSETS_IMAGE_PATH}${_modelWorkoutList.image}"),
          //       //                             //     // width: 200,
          //       //                             //     // height: 200,
          //       //                             //     width: SizeConfig
          //       //                             //             .safeBlockHorizontal! *
          //       //                             //         40,
          //       //                             //     height: SizeConfig
          //       //                             //             .safeBlockHorizontal! *
          //       //                             //         40,
          //       //                             //     fit: BoxFit.fill,
          //       //                             //   ),
          //       //                             // ),
          //       //                             // Container(
          //       //                             //   width: double.infinity,
          //       //                             //   height: double.infinity,
          //       //                             //   margin: EdgeInsets.only(
          //       //                             //       top: 10, bottom: 10),
          //       //                             //   padding: EdgeInsets.only(
          //       //                             //       left: 15,
          //       //                             //       right: 15,
          //       //                             //       top: 7,
          //       //                             //       bottom: 7),
          //       //                             //   child: Row(
          //       //                             //     mainAxisAlignment:
          //       //                             //         MainAxisAlignment.start,
          //       //                             //     children: [
          //       //                             //       Expanded(
          //       //                             //         child: Column(
          //       //                             //           mainAxisAlignment:
          //       //                             //               MainAxisAlignment
          //       //                             //                   .center,
          //       //                             //           crossAxisAlignment:
          //       //                             //               CrossAxisAlignment
          //       //                             //                   .start,
          //       //                             //           children: [
          //       //                             //             getMediumBoldTextWithMaxLine(
          //       //                             //                 _modelWorkoutList
          //       //                             //                     .name,
          //       //                             //                 Colors.black87,
          //       //                             //                 1),
          //       //                             //             getExtraSmallNormalTextWithMaxLine(
          //       //                             //                 S
          //       //                             //                     .of(context)
          //       //                             //                     .transformation,
          //       //                             //                 Colors.black87,
          //       //                             //                 3,
          //       //                             //                 TextAlign.start)
          //       //                             //           ],
          //       //                             //         ),
          //       //                             //         flex: 1,
          //       //                             //       )
          //       //                             //     ],
          //       //                             //   ),
          //       //                             // )
          //       //                           ],
          //       //                         ),
          //       //                       )),
          //       //                   // : getRightSide(exerciseDetail),
          //       //                   onTap: () {
          //       //                     print("sendtidetail1==true");
          //       //                     sendToWorkoutList(context,
          //       //                         _modelWorkoutList,
          //       //                         Constants.workoutId);
          //       //
          //       //                     // Navigator.of(context).push(MaterialPageRoute(
          //       //                     //   builder: (context) {
          //       //                     //     return WidgetWorkout(_exerciseList);
          //       //                     //   },
          //       //                     // ));
          //       //                   },
          //       //                 ),
          //       //               ));
          //       //         },
          //       //       );
          //       //     });
          //     } else {
          //       return getProgressDialog();
          //     }
          //   },
          // ),

          GridView.count(
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

                            // Row(
                            //   children: [
                            //
                            //     SizedBox(
                            //       width:
                            //       8,
                            //     ),
                            //     Row(
                            //       crossAxisAlignment:
                            //       CrossAxisAlignment.center,
                            //       mainAxisAlignment:
                            //       MainAxisAlignment.start,
                            //       children: [
                            //         Image.asset(
                            //           Constants.assetsImagePath + "calendar.png",
                            //           height: iconSize,
                            //           width: iconSize,
                            //           color: Colors.white,
                            //         ),
                            //         SizedBox(width: Constants.getPercentSize(sWidth, 5)),
                            //         ConstantWidget.getTextWidget("4 Week", Colors.white,
                            //             TextAlign.start, FontWeight.bold, ConstantWidget.getPercentSize(sWidth, 8)),
                            //       ],
                            //     ),
                            //   ],
                            // )



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
          )

          // GridView.count(
          //   // mainAxisSpacing: _crossAxisSpacing,
          //   crossAxisCount: _crossAxisCount,
          //   childAspectRatio: _aspectRatio,
          //   // crossAxisSpacing: _crossAxisSpacing,
          //   // mainAxisSpacing: _crossAxisSpacing,
          //   shrinkWrap: true,
          //   padding: EdgeInsets.only(
          //       left: _crossAxisSpacing,
          //       right: _crossAxisSpacing,
          //       bottom: _crossAxisSpacing),
          //   primary: false,
          //   children: List.generate(workoutList.length, (index) {
          //     ModelWorkoutList _workoutList = workoutList[index];
          //     return InkWell(
          //       child: Container(
          //
          //         height: double.infinity,
          //         // padding: EdgeInsets.all(7),
          //         margin: EdgeInsets.all(7),
          //         decoration: BoxDecoration(
          //
          //
          //           borderRadius:
          //           BorderRadius.all(Radius.circular(10)),
          //           color: Colors.transparent,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey,
          //               offset: Offset(0.0, 1.5), //(x,y)
          //               blurRadius: 2.5,
          //             ),
          //           ],
          //         ),
          //         child:
          //         Stack(
          //           // mainAxisAlignment: MainAxisAlignment.start,
          //           // crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //
          //
          //             Container(
          //               decoration: BoxDecoration(
          //                 image: DecorationImage(
          //                     image: AssetImage(
          //                       Constants.assetsImagePath +
          //                           _workoutList.image!,),
          //                     fit: BoxFit.cover),
          //                 borderRadius: BorderRadius.all(
          //                      Radius.circular(7),
          //                     ),
          //               ),
          //             ),
          //
          //             Container(
          //               height: double.infinity,
          //               width: double.infinity,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                       Radius.circular(7)),
          //                   gradient: LinearGradient(
          //                     colors: [
          //                       Colors.black54,
          //                       Colors.black87,
          //                     ],
          //                     begin: Alignment.topCenter,
          //                     end: Alignment.bottomCenter,
          //                   )),
          //             ),
          //
          //             Container(
          //               width: double.infinity,
          //               padding: EdgeInsets.symmetric(
          //                   vertical: Constants.getPercentSize(
          //                       height, 2),
          //                   horizontal: Constants.getPercentSize(
          //                       height, 2.8)),
          //               // decoration: BoxDecoration(
          //               //   color: Colors.white,
          //               //   borderRadius: BorderRadius.only(
          //               //       bottomLeft: Radius.circular(7),
          //               //       bottomRight: Radius.circular(7)),
          //               // ),
          //               child: Column(
          //
          //                 children: [
          //
          //                   ConstantWidget.getTextWidgetWithFont(
          //                   _workoutList.name!
          //                           .toUpperCase(),
          //                       Colors
          //                           .white,
          //                       TextAlign
          //                           .start,
          //                       FontWeight
          //                           .w600,
          //                       ConstantWidget.getPercentSize(
          //                           height,
          //                           6),
          //                       meriendaOneFont),
          //
          //
          //                   // getCustomText(
          //                   //     _workoutList.name!,
          //                   //     Colors.white,
          //                   //     1,
          //                   //     TextAlign.start,
          //                   //     FontWeight.w600,
          //                   //     Constants.getPercentSize(
          //                   //         height, 7)),
          //
          //                   SizedBox(height: 5,),
          //
          //
          //                   Row(
          //                     children: [
          //                       Row(
          //                         crossAxisAlignment:
          //                         CrossAxisAlignment.center,
          //                         children: [
          //                           Image.asset(
          //                             Constants.assetsImagePath + "dumbbell.png",
          //                             height: iconSize,
          //                             width: iconSize,
          //                             color: Colors.white,
          //                           ),
          //                           SizedBox(width: ConstantWidget.getPercentSize(sWidth, 5)),
          //                           ConstantWidget.getTextWidget("Beginner", Colors.white,
          //                               TextAlign.start, FontWeight.bold, ConstantWidget.getPercentSize(sWidth, 8)),
          //                         ],
          //                       ),
          //                       SizedBox(
          //                         width:
          //                         8,
          //                       ),
          //                       Row(
          //                         crossAxisAlignment:
          //                         CrossAxisAlignment.center,
          //                         mainAxisAlignment:
          //                         MainAxisAlignment.start,
          //                         children: [
          //                           Image.asset(
          //                             Constants.assetsImagePath + "calendar.png",
          //                             height: iconSize,
          //                             width: iconSize,
          //                             color: Colors.white,
          //                           ),
          //                           SizedBox(width: Constants.getPercentSize(sWidth, 5)),
          //                           ConstantWidget.getTextWidget("4 Week", Colors.white,
          //                               TextAlign.start, FontWeight.bold, ConstantWidget.getPercentSize(sWidth, 8)),
          //                         ],
          //                       ),
          //                     ],
          //                   )
          //
          //
          //
          //                 ],
          //                 mainAxisAlignment: MainAxisAlignment.end,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //       onTap: () {
          //
          //         sendToWorkoutList(
          //             context, _workoutList, Constants.workoutId);
          //       },
          //     );
          //   }),
          // )
        ],
      ),
    );
  }
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

class TabActivity extends StatefulWidget {
  @override
  _TabActivity createState() => _TabActivity();
}

class _TabActivity extends State<TabActivity> {
  // CalendarController _calendarController;
  DateTime selectedDateTime = DateTime.now();

  // String height = "0";
  // String weight = "0";
  int bmi = 0;

  double getTotalCal = 0;
  double getTodayTotalCal = 0;
  int getTodayTotalDuration = 0;
  int getTodayTotalWorkout = 0;
  double getCal = 0;
  int getTotalWorkout = 0;
  List<ModelHistory> priceList = [];

  int getTime = 0;

  //
  var myController = TextEditingController();
  var myControllerWeight = TextEditingController();
  var myControllerIn = TextEditingController();

  List<ModelHistory> modelHistory = [];

  void _calcTotalCal() async {
    // List<ModelHistory> getTodayList = await _dataHelper
    //     .getHistoryByDate(Constants.addDateFormat.format(selectedDateTime));
    //
    // priceList = await _dataHelper.calculateTotalWorkout();
    //
    // if (getTodayList.length > 0) {
    //   getTodayList.forEach((price) {
    //     // getTodayTotalCal = (price.kCal) + getTodayTotalCal;
    //     // getTodayTotalDuration = (price.totalDuration) + getTodayTotalDuration;
    //     getTodayTotalCal = (double.parse(price.kCal!)) + getTodayTotalCal;
    //     getTodayTotalDuration = ((price.totalDuration!) + getTodayTotalDuration);
    //
    //     // getCal = (getCal + (price['kcal']);
    //   });
    //   getTodayTotalWorkout = getTodayList.length;
    // }
    // if (priceList.length > 0) {
    //   // getTotalWorkout = priceList.length;
    //   priceList.forEach((price) {
    //     getTotalCal = double.parse(price.kCal!) + getTotalCal;
    //     // getCal = (getCal + (price['kcal']);
    //   });
    //
    //   setState(() {});
    // }
  }

  int prefCal = 0;
  double weight = 50;
  double height = 100;
  bool isKg = true;

  getHeights() async {
    double getWeight = await PrefData().getWeight();
    double getHeight = await PrefData().getHeight();
    isKg = await PrefData().getIsKgUnit();
    weight = getWeight;
    height = getHeight;
    getBmiVal();
  }

  @override
  void initState() {
    getPrefCalData();
    _calcTotalCal();
    super.initState();
    getHeights();
    // _calendarController = CalendarController();
  }

  Future<void> getPrefCalData() async {
    prefCal = await PrefData().getDailyCalGoal();

    setState(() {});
  }

  void showWeightHeightDialog(BuildContext contexts) async {
    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Enter Height and Weight", Colors.black87, 1),
              content: Container(
                width: 300.0,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCustomText("Height", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
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
                          visible: (!isKg) ? true : false,
                        ),
                        Visibility(
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
                          visible: (!isKg) ? true : false,
                        ),
                        getMediumNormalTextWithMaxLine((isKg) ? "CM" : "FT/In",
                            Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    getCustomText("Weight", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
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
                            controller: myControllerWeight,
                          ),
                          flex: 1,
                        ),
                        getMediumNormalTextWithMaxLine(
                            "KG", Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                new TextButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          color: accentColor,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new TextButton(
                    // color: lightPink,
                    style: TextButton.styleFrom(backgroundColor: lightPink),
                    child: Text(
                      'CHECK',
                      style: TextStyle(
                          color: accentColor,
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        if (isKg) {
                          height = double.parse(myController.text);

                          // height = myController.text;
                        } else {
                          double inch = 0;
                          if (myControllerIn.text.isNotEmpty) {
                            inch = double.parse(myControllerIn.text);
                          }
                          double feet = double.parse(myController.text);
                          double cm = Constants.feetAndInchToCm(feet, inch);
                          height = cm;
                        }
                        PrefData().addHeight(height);
                      }

                      if (myControllerWeight.text.isNotEmpty) {
                        // weight = myControllerWeight.text;
                        double weight1 = double.parse(myControllerWeight.text);
                        if (isKg) {
                          weight = weight1;
                          PrefData().addWeight(weight1);
                        } else {
                          weight = Constants.poundToKg(weight1);
                          PrefData().addWeight(weight);
                        }
                        // Navigator.pop(context, weight);
                      }

                      Navigator.pop(context, weight);

                      // else {
                      //   print("getWeight===$weight");
                      //   Navigator.pop(context, "");
                      // }
                    }),
              ],
            );
          },
        );
      },
    ).then((value) {
      // setState(() {
      getBmiVal();
      // selectedGender=value;
      // })
    });
  }

  @override
  void dispose() {
    // _calendarController.dispose();
    super.dispose();
  }

  void getBmiVal() {
    double weightKg = weight;
    double heightCm = height;

    double meterHeight = heightCm / 100;
    double bmiGet = weightKg / (meterHeight * meterHeight);
    print("getbmival---$bmiGet--$meterHeight--$weightKg");
    setState(() {
      // String s = "$bmiGet";
      bmi = bmiGet.toInt();
      // bmi = int.parse("$bmiGet");
    });
  }

  @override
  Widget build(BuildContext context) {
    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    SizeConfig().init(context);
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(textMargin),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              getSmallBoldText("Stats |", Colors.black),
              getSmallNormalText(" Today", Colors.black, TextAlign.start),
            ],
          ),
          new CircularPercentIndicator(
            radius: SizeConfig.safeBlockHorizontal! * 50,
            lineWidth: 13,
            percent: (((getTodayTotalCal * 100) / prefCal) > 1.0)
                ? 1.0
                : ((getTodayTotalCal * 100) / prefCal),
            // percent: (((getTotalCal * 100) / prefCal) > 1.0)
            //     ? 1.0
            //     : ((getTotalCal * 100) / prefCal),
            // percent: 0.5,
            center: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 40,
                ),
                Container(
                  width: SizeConfig.safeBlockHorizontal! * 38,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "${Constants.calFormatter.format(getTotalCal)}/$prefCal KCAL",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: Constants.fontsFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: greyWhite,
            progressColor: Colors.green,
          ),
          SizedBox(
            height: 5,
          ),
          getMediumBoldTextWithMaxLine("Daily Goal", Colors.black, 1),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 3, right: 4, top: 5, bottom: 5),
            color: Colors.black12,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCustomText(
                          "$getTodayTotalWorkout",
                          Colors.black,
                          1,
                          TextAlign.start,
                          FontWeight.bold,
                          Constants.getPercentSize(screenWidth, 5)),
                      SizedBox(
                        width: 2,
                      ),
                      getCustomText(
                          "Workouts",
                          Colors.black,
                          1,
                          TextAlign.start,
                          FontWeight.w500,
                          Constants.getPercentSize(screenWidth, 4)),
                      // getSmallNormalText(
                      //     "Workouts", Colors.black, TextAlign.start)
                    ],
                  ),
                ),
                getSmallBoldText(" | ", Colors.black),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // getMediumBoldTextWithMaxLine(
                      //     Constants.getTimeFromSec(getTodayTotalDuration),
                      //     Colors.black,
                      //     1),
                      getCustomText(
                          Constants.getTimeFromSec(getTodayTotalDuration),
                          Colors.black,
                          1,
                          TextAlign.start,
                          FontWeight.bold,
                          Constants.getPercentSize(screenWidth, 5)),
                      // getMediumBoldTextWithMaxLine("${new Duration(seconds: getTodayTotalDuration).inMinutes}", Colors.black, 1),
                      SizedBox(
                        width: 2,
                      ),
                      getCustomText(
                          S.of(context).minutes,
                          Colors.black,
                          1,
                          TextAlign.start,
                          FontWeight.w500,
                          Constants.getPercentSize(screenWidth, 4)),
                      // getSmallNormalText(
                      //     S.of(context).minutes, Colors.black, TextAlign.start)
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            width: double.infinity,
            height: SizeConfig.safeBlockVertical! * 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: bmiBgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Image.asset(
                        Constants.assetsImagePath + "path.png",
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            child: getMediumBoldTextWithMaxLine(
                                "BMI", Colors.white, 1),
                            padding: EdgeInsets.all(5),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: getCustomText("$bmi kg/m²", Colors.white, 1,
                                TextAlign.center, FontWeight.bold, 22),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                (bmi < 18)
                                    ? "Underweight"
                                    : (bmi < 25)
                                        ? "Normal Weight"
                                        : (bmi < 30)
                                            ? "Overweight"
                                            : "Obesity",
                                style: TextStyle(
                                    color: Constants.getColorFromHex("FBC02D"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              )
                              // , 1,
                              // TextAlign.center, , 22),
                              ),
                          Expanded(
                            child: Center(
                              child: Container(
                                // margin: EdgeInsets.all(7),
                                // child:      Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 0),
                                //   child: Gauge(
                                //     arrowHeight: 15.0,
                                //     arrowWidth: 15.0,
                                //     barHeight: 50,
                                //     bubbleFontSize: 0.0,
                                //     cellDataList: [
                                //       CellData(Color(0xFF000000), "0", rightGap: 0.0),
                                //       CellData(Color(0xFFB2D624), "1", rightGap: 0.0),
                                //       CellData(Color(0xFF6DAD2D), "2", rightGap: 0.0),
                                //       CellData(Color(0xFF26A53A), "3", rightGap: 0.0),
                                //       CellData(Color(0xFF1C7735), "4", rightGap: 0.0),
                                //       CellData(Color(0xFF0D4E02), "5", rightGap: 0.0),
                                //     ],
                                //     gaugeWidth: 400,
                                //     pointerFrameHeight: 20.0,
                                //     pointerFrameWidth: 20.0,
                                //     strokeColor: Colors.transparent,
                                //     strokeWidth: 5.0,
                                //   ),
                                // ),
                                child: MyAssetsBar(
                                  // width: 200,
                                  width: SizeConfig.safeBlockHorizontal! * 90,
                                  background:
                                      Constants.getColorFromHex("CFD8DC"),
                                  //height: 50,
                                  height: 5,
                                  radius: 5,
                                  pointer: bmi,
                                  //radius: 10,
                                  assetsLimit: 50,
                                  order: OrderType.None,
                                  // order: OrderType.Ascending,
                                  assets: [
                                    MyAsset(
                                        size: 15,
                                        color:
                                            Constants.getColorFromHex("D0E2E2"),
                                        title: "0"),
                                    MyAsset(
                                        size: 3,
                                        color:
                                            Constants.getColorFromHex("9ADF9C"),
                                        title: "16"),
                                    MyAsset(
                                        size: 7,
                                        color:
                                            Constants.getColorFromHex("1EDC3E"),
                                        title: "18"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                            Constants.getColorFromHex("DCE683"),
                                        title: "25"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                            Constants.getColorFromHex("FF9A00"),
                                        title: "30"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                            Constants.getColorFromHex("E26F76"),
                                        title: "35"),
                                    MyAsset(
                                        size: 10,
                                        color:
                                            Constants.getColorFromHex("EF3737"),
                                        title: "40"),
                                  ],
                                ),
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),


                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: bmiDarkBgColor,
                  ),
                  padding: EdgeInsets.all(7),
                  child: InkWell(
                    onTap: () {
                      if (isKg) {
                        myController.text = Constants.formatter.format(height);
                        myControllerWeight.text =
                            Constants.formatter.format(weight);
                      } else {
                        Constants.meterToInchAndFeet(
                            height, myController, myControllerIn);
                        myControllerWeight.text = Constants.formatter
                            .format(Constants.kgToPound(weight));
                      }
                      showWeightHeightDialog(context);
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: getMediumNormalTextWithMaxLine(
                              "Check Now", Colors.white, 1, TextAlign.center),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1), //(x,y)
                    blurRadius: 2)
              ],
              color: Colors.white,
            ),
            child: TableCalendar(
              firstDay: new DateTime(2018, 1, 13),
              lastDay: DateTime.now(),
              currentDay: DateTime.now(),
              focusedDay: DateTime.now(),
              // calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // selectedColor: (Colors.deepOrange[400]),
                // todayColor: Colors.deepOrange[200],
                // markersColor: Colors.brown[700],

                outsideDaysVisible: false,
                // weekdayStyle: TextStyle(
                //     color: Colors.black, fontFamily: Constants.fontsFamily),
              ),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: TextStyle()
                    .copyWith(color: Colors.transparent, fontSize: 0),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                selectedDateTime = selectedDay;
                print("getcheckedday==$selectedDay");
                setState(() {});
              },

              // (day, events, holidays) {
              // selectedDateTime = day;
              // print("getcheckedday==${day.day}-${day.month}-${day.year}");
              // setState(() {});
              // },
              // onVisibleDaysChanged: (first, last, format) {},
              // onCalendarCreated: (first, last, format) {},
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(7),
                  child: getCustomText("SUMMARY", Colors.black, 1,
                      TextAlign.start, FontWeight.bold, 18),
                ),
                Align(
                    alignment: Alignment.center,
                    child: getCustomText(
                        Constants.historyTitleDateFormat
                            .format(selectedDateTime),
                        Colors.black,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        15)),
                SizedBox(
                  height: 10,
                ),

                // FutureBuilder<List<ModelHistoryelHistory>>(
                //   future: _dataHelper.getHistoryByDate(
                //       Constants.addDateFormat.format(selectedDateTime)),
                //   builder: (context, snapshot) {
                //     List<ModelHistory> modelHistory=[];
                //     getTotalWorkout = 0;
                //     getCal = 0;
                //     getTime = 0;
                //     if (snapshot.hasData && snapshot.data != null) {
                //       modelHistory = snapshot.data!;
                //       getTotalWorkout = modelHistory.length;
                //       modelHistory.forEach((price) {
                //         getCal = double.parse(price.kCal!) + getCal;
                //         getTime = price.totalDuration! + getTime;
                //         // getCal = (getCal + (price['kcal']);
                //       });
                //       // getTime = getTotalWorkout * 2;
                //     }
                //     return Column(
                //       children: [
                //         Row(
                //           children: [
                //             getCustomText(
                //                 "$getTotalWorkout Workouts",
                //                 Colors.black,
                //                 1,
                //                 TextAlign.start,
                //                 FontWeight.w400,
                //                 15),
                //             Expanded(
                //               child: RichText(
                //                 textAlign: TextAlign.center,
                //                 text: TextSpan(
                //                   children: [
                //                     WidgetSpan(
                //                       child: Icon(Icons.timer,
                //                           color: Colors.blueAccent, size: 20),
                //                     ),
                //                     WidgetSpan(
                //                         child: SizedBox(
                //                       width: 10,
                //                     )),
                //                     TextSpan(
                //                         text: Constants.getTimeFromSec(getTime),
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontFamily: Constants.fontsFamily,
                //                             fontSize: 15,
                //                             fontWeight: FontWeight.w400)),
                //                   ],
                //                 ),
                //               ),
                //               flex: 1,
                //             ),
                //             Expanded(
                //               child: RichText(
                //                 textAlign: TextAlign.center,
                //                 text: TextSpan(
                //                   children: [
                //                     WidgetSpan(
                //                       child: Icon(
                //                           Icons.local_fire_department_outlined,
                //                           color: Colors.red,
                //                           size: 20),
                //                     ),
                //                     WidgetSpan(
                //                         child: SizedBox(
                //                       width: 10,
                //                     )),
                //                     TextSpan(
                //                         text:
                //                             "${Constants.calFormatter.format(getCal)} Kcal",
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontFamily: Constants.fontsFamily,
                //                             fontSize: 15,
                //                             fontWeight: FontWeight.w400)),
                //                   ],
                //                 ),
                //               ),
                //               flex: 1,
                //             )
                //           ],
                //         ),
                //         SizedBox(
                //           height: 10,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(
                //               left: SizeConfig.safeBlockHorizontal! * 4,
                //               right: SizeConfig.safeBlockHorizontal! * 4),
                //           child: Divider(
                //             height: 1,
                //             color: Colors.grey,
                //           ),
                //         ),
                //         SizedBox(
                //           height: 7,
                //         ),
                //         (1 > 0)
                //             ?
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    // ModelHistory _modelHistory =
                    //     modelHistory[index];
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          border: Border.all(color: Colors.grey, width: 0.5)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal! * 3,
                          ),
                          Image.asset(
                            Constants.assetsImagePath + "dumbbell.png",
                            width: SizeConfig.safeBlockHorizontal! * 12,
                            height: SizeConfig.safeBlockHorizontal! * 12,
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal! * 5,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getCustomText(
                                    "Workout",
                                    Colors.black87,
                                    1,
                                    TextAlign.start,
                                    FontWeight.bold,
                                    Constants.getPercentSize(
                                        SizeConfig.safeBlockHorizontal! * 80,
                                        5)),
                                SizedBox(
                                  height: 3,
                                ),
                                getCustomText(
                                    "02:30",
                                    Colors.grey,
                                    1,
                                    TextAlign.start,
                                    FontWeight.w200,
                                    Constants.getPercentSize(
                                        SizeConfig.safeBlockHorizontal! * 80,
                                        5)),
                                // getSmallNormalTextWithMaxLine(
                                //   _modelHistory.startTime,
                                //   Colors.grey,
                                //   1,
                                // ),
                                SizedBox(
                                  height: 3,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(Icons.timer,
                                              color: Colors.blueAccent,
                                              size: 15),
                                        ),
                                        WidgetSpan(
                                            child: SizedBox(
                                          width: 10,
                                        )),
                                        TextSpan(
                                            text: Constants.getTimeFromSec(2),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.fontsFamily,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400)),
                                        WidgetSpan(
                                            child: SizedBox(
                                          width: 10,
                                        )),
                                        WidgetSpan(
                                          child: Icon(
                                              Icons
                                                  .local_fire_department_outlined,
                                              color: Colors.redAccent,
                                              size: 15),
                                        ),
                                        WidgetSpan(
                                            child: SizedBox(
                                          width: 10,
                                        )),
                                        TextSpan(
                                            text:
                                                "${Constants.calFormatter.format(double.parse("0"))} Kcal",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.fontsFamily,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    );
                  },
                )
                // : Container(
                //     padding: EdgeInsets.all(10),
                //     child: Align(
                //       alignment: Alignment.center,
                //       child: getSmallNormalTextWithMaxLine(
                //           "No Summary", Colors.black, 1),
                //     ))
                //       ],
                //     );
                //
                //     // } else {
                //     //   return Container(
                //     //       padding: EdgeInsets.all(10),
                //     //       child: Align(
                //     //         alignment: Alignment.center,
                //     //         child: getSmallNormalTextWithMaxLine(
                //     //             "No Summary", Colors.black, 1),
                //     //       ));
                //     // }
                //   },
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabDiscover extends StatefulWidget {
  @override
  _TabDiscover createState() => _TabDiscover();
}

var cardAspectRatio = 16.0 / 20.0;
// var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

// ignore: must_be_immutable
class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  List<ModelDiscover> _discoverList;

  CardScrollWidget(this.currentPage, this._discoverList);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = [];

        for (var i = 0; i < 4; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          // var cardItem = Positioned(
          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            // left: 0,
            end: start,
            // textDirection:TextDirection.rtl,
            textDirection: Directionality.of(context),

            child:
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child:
                ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                // width: double.infinity,
                // height: double.infinity,
                decoration: BoxDecoration(
                    // image: DecorationImage(

                    // image: AssetImage(Constants.ASSETS_IMAGE_PATH +
                    //     _discoverList[i].background),
                    // fit: BoxFit.fill),
                    // color: Constants.getColorFromHex("077399"),
                    // color: Constants.getColorFromHex(_discoverList[i].background),
                    //   gradient: new LinearGradient(
                    //       colors: [
                    //         Constants.darken(Constants.getColorFromHex(
                    //             "5E01A7")),
                    //         Constants.brighten(Constants.getColorFromHex(
                    //           "5E01A7")),
                    //         // darken(Color(0xFF3366FF)),
                    //         // const Color(0xFF00CCFF),
                    //       ],
                    //       begin: const FractionalOffset(0.0, 0.0),
                    //       end: const FractionalOffset(1.0, 0.0),
                    //       stops: [0.0, 1.0],
                    //       tileMode: TileMode.clamp)

                    // gradient: LinearGradient(
                    //   colors: [
                    //     // List: [
                    //     Color.fromARGB(
                    //         200, 0, 0, 0),
                    //     Color.fromARGB(
                    //         0, 0, 0, 0)
                    //   ],
                    //   begin: Alignment
                    //       .bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),

                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black12,
                    //       offset: Offset(3.0, 6.0),
                    //       blurRadius: 10.0)
                    // ]
                    image: DecorationImage(
                        image: AssetImage(Constants.assetsImagePath +
                            _discoverList[i].image!),
                        fit: BoxFit.cover)),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black45,
                                Colors.black54,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                      ),

                      // Image.asset(
                      //     Constants.assetsImagePath + "pattern_discover.png",
                      //     fit: BoxFit.fill),
                      // Padding(
                      //   padding: EdgeInsets.all(7),
                      //   child: Image.asset(
                      //       Constants.assetsImagePath + _discoverList[i].image,
                      //       fit: BoxFit.scaleDown),
                      // ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                // List: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(100, 0, 0, 0),
                                Color.fromARGB(50, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0),
                                child: Text(
                                  _discoverList[i].title!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: Constants.fontsFamily,
                                    fontStyle: FontStyle.italic,
                                    // fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                ),
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),

                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 3.0,
                                    bottom: 10.0),

                                child: ConstantWidget
                                    .getTextWidgetWithFontWithMaxLine(
                                        _discoverList[i].description!,
                                        Colors.white,
                                        TextAlign.start,
                                        FontWeight.w100,
                                        13,
                                        meriendaOneFont,3),
                                // child: Text(
                                //   _discoverList[i].description!,
                                //   style: TextStyle(
                                //       fontFamily: Constants.fontsFamily,
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.w200,
                                //       color: Colors.white,
                                //       height: 1.5,
                                //       letterSpacing: 1),
                                //   maxLines: 4,
                                //   textAlign: TextAlign.start,
                                // )
                              )

                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 12.0, bottom: 12.0),
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 22.0, vertical: 6.0),
                              //     // decoration: BoxDecoration(
                              //     //     color: Colors.blueAccent,
                              //     //     borderRadius: BorderRadius.circular(20.0)),
                              //     child: Text("Read Later",
                              //         style: TextStyle(color: Colors.white)),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}

class _TabDiscover extends State<TabDiscover> {
  // List<ModelWorkoutList> _workoutList = [];
  List<ModelDiscover> _discoverList = DataFile.getDiscoverList();

  // void sendToWorkoutList(BuildContext context, int id) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) {
  //       return WidgetWorkoutExerciseList(_workoutList[0]);
  //     },
  //   ));
  // }

  List<ModelPopularWorkout> _quickWorkoutList = DataFile.getPopularList();

  var currentPage = 2 - 1.0;

  @override
  void initState() {
    // _dataHelper.getWorkoutList().then((value) {
    //   // _workoutList = value;
    //   setState(() {});
    // });
    // _dataHelper.getAllDiscoverWorkouts().then((value) {
    //   if (value != null && value.length > 0) {
    //     setState(() {
    //       _discoverList = value;
    //       print("discove==${_discoverList.length}");
    //       currentPage = _discoverList.length - 1.0;
    //     });
    //   }
    // });
    super.initState();
  }


  final listController = AutoScrollController(
    //add this for advanced viewport boundary. e.g. SafeArea


      //choose vertical/horizontal
      axis: Axis.horizontal,

      suggestedRowHeight: 200
  );

  List<ModelQuickWorkout> quickWorkoutList = DataFile.getQuickList();

  CarouselController buttonCarouselController = CarouselController();

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    PageController controller =
        PageController(initialPage: _discoverList.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    double quickWorkoutHeight = SizeConfig.safeBlockHorizontal! * 42;
    double quickWorkoutSize = SizeConfig.safeBlockHorizontal! * 32;

    double sliderHeight = Constants.getScreenPercentSize(context, 40);
    double sliderRadius = Constants.getPercentSize(sliderHeight, 8);
    double heightBottom = Constants.getPercentSize(screenWidth, 30);


    List<Widget>? imageSliders =
         _discoverList
        .map((item) {
      Color color="#99d8ef".toColor();

      int position= item.id!-1;

      if(position % 4 == 0){
        color="#aeacf9".toColor();
      }else if(position % 4 == 1){
        color="#fda0dd".toColor();
      }else if(position % 4 == 2){
        color="#81c1fe".toColor();
      }

      return Container(
        height: sliderHeight,
        margin: EdgeInsets.only(right:Constants.getWidthPercentSize(context, 5)),


        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(sliderRadius)),
          color: color,
        ),


        child: InkWell(
          onTap: () {

            ModelDummySend dummySend = new ModelDummySend(
                              item.id!,
                item.title!,
                              Constants.getTableNames(
                                  Constants.discoverId),
                item.image!);



                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return WidgetWorkoutExerciseList(dummySend);
                            },
                          ));
                          // sendToWorkoutList(context);

          },
          child: Stack(
            children: <Widget>[


              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(Constants.assetsImagePath+item.image!,height: Constants.getPercentSize(sliderHeight, 70),),
              ),

              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child:
                        ConstantWidget.getTextWidgetWithFont(
                            item.title!.toUpperCase(),
                            Colors.black87,
                            TextAlign.start,
                            FontWeight.w300,
                            ConstantWidget.getPercentSize(
                                sliderHeight, 8),
                            Constants.boldFontsFamily),
                      ),

                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child:

                        ConstantWidget
                            .getTextWidgetWithFontWithMaxLine(
                            '${item.description}',
                            Colors.black54,
                            TextAlign.start,
                            FontWeight.w100,
                            Constants.getPercentSize(
                                sliderHeight, 4),
                            Constants.boldFontsFamily,2))
                      //   ConstantWidget
                      //       .getTextWidgetWithFont(
                      //       "${item.description}",
                      //       Colors.white,
                      //       TextAlign.start,
                      //       FontWeight.w100,
                      //       Constants.getPercentSize(
                      //           sliderHeight, 8),
                      //       bebasneue),
                      // ),


                    ],
                  ),
                ),
              )
            ],
          ),
        ),

      );
    })
        .toList()
        ;


    double listHeight = Constants.getScreenPercentSize(context, 6);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            // (_discoverList.isNotEmpty)
            //     ? Stack(
            //         children: <Widget>[
            //           CardScrollWidget(currentPage, _discoverList),
            //           Positioned.fill(
            //             // Positioned.directional(
            //             //   textDirection:Directionality.maybeOf(context),
            //             //   top: 0,
            //             //   bottom: 0,
            //             child: PageView.builder(
            //               itemCount: _discoverList.length,
            //               controller: controller,
            //               reverse: true,
            //               itemBuilder: (context, index) {
            //                 ModelDiscover _discoverModel = _discoverList[index];
            //                 // return Container();
            //                 return InkWell(
            //                   onTap: () {
            //                     ModelDummySend dummySend = new ModelDummySend(
            //                         _discoverModel.id!,
            //                         _discoverModel.title!,
            //                         Constants.getTableNames(
            //                             Constants.discoverId),
            //                         _discoverModel.image!);
            //
            //                     // dummySend.tableName = Constants.getTableNames(
            //                     //     Constants.discoverId);
            //                     // dummySend.id = _discoverModel.id;
            //                     // dummySend.name = _discoverModel.title;
            //
            //                     Navigator.of(context).push(MaterialPageRoute(
            //                       builder: (context) {
            //                         return WidgetWorkoutExerciseList(dummySend);
            //                       },
            //                     ));
            //                     // sendToWorkoutList(context);
            //                     print("tapped");
            //                   },
            //                   child: Container(),
            //                 );
            //               },
            //             ),
            //           )
            //         ],
            //       )
            //     : getProgressDialog(),


            if (_discoverList.isNotEmpty) Column(
              children: <Widget>[

                SizedBox(height: Constants.getScreenPercentSize(context, 2),),


                Container(
                  margin: EdgeInsets.only(bottom: textMargin),
                  height: listHeight,
                  // color: Colors.red,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: listController,
                    itemCount: _discoverList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {

                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: listController,
                      index: index,

                      child: InkWell(

                        onTap: (){
                         setState(() {
                           _current = index;
                           buttonCarouselController.jumpToPage(index);
                         });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: (textMargin*1.2)),
                          child: Stack(
                            children: [

                              Align(
                                alignment: Alignment.centerLeft,
                                child: getCustomText(_discoverList[index].title!, _current== index?Colors.black:Colors.grey, 1,
                                    TextAlign.start, FontWeight.w600, Constants.getPercentSize(listHeight, 32)),
                              ),

                              Align(
                                alignment: Alignment.bottomLeft,

                                child: Container(
                                  margin: EdgeInsets.only(bottom:Constants.getPercentSize(listHeight, 5) ),
                                  width: Constants.getWidthPercentSize(context,5),
                                  height: Constants.getPercentSize(listHeight, 10),
                                  color: _current == index?Colors.black:Colors.transparent,

                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    );
                  },),
                ),


                CarouselSlider(
                    items:  imageSliders ,
                    carouselController: buttonCarouselController,



                    options: CarouselOptions(
                        height: sliderHeight,
                        autoPlay: false,
                        pageSnapping: true,
                        viewportFraction: 0.9,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason){
                          setState(() {
                            _current = index;
                            listController.scrollToIndex(index);

                            print("index---$index");

                          });
                        },
                        enableInfiniteScroll: false)),


              ],
            ) else getProgressDialog(),


            Padding(
                padding: EdgeInsets.all(textMargin),
                child: getTitleTexts(S.of(context).yogaStyles)),
            Container(
              margin: EdgeInsets.all(5),
              height: quickWorkoutHeight,
              child: ListView.builder(
                itemCount: quickWorkoutList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ModelQuickWorkout _modelQuickWorkout =
                      quickWorkoutList[index];


                  double radius=Constants.getPercentSize(quickWorkoutHeight, 20);

                  Color color="#99d8ef".toColor();

                  int position= index;

                  if(position % 4 == 0){
                    color="#aeacf9".toColor();
                  }else if(position % 4 == 1){
                    color="#fda0dd".toColor();
                  }else if(position % 4 == 2){
                    color="#81c1fe".toColor();
                  }

                  return InkWell(
                    child: Container(
                      width: quickWorkoutSize,
                      height: double.infinity,
                      // padding: EdgeInsets.all(7),
                      margin: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage(Constants.assetsImagePath +
                        //       _modelQuickWorkout.image),fit: BoxFit.cover
                        // ),
                        borderRadius: BorderRadius.all(Radius.circular(radius)),
                        color: color,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey,
                        //     offset: Offset(0.0, 1.5), //(x,y)
                        //     blurRadius: 2.5,
                        //   ),
                        // ],
                      ),
                      child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Expanded(
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //           image: AssetImage(
                          //               Constants.assetsImagePath +
                          //                   _modelQuickWorkout.image!),
                          //           fit: BoxFit.cover),
                          //       borderRadius: BorderRadius.only(
                          //           topLeft: Radius.circular(7),
                          //           topRight: Radius.circular(7)),
                          //     ),
                          //   ),
                          //
                          //   flex: 1,
                          // ),


                      Center(
                        child: Container(
                          margin: EdgeInsets.all(Constants.getPercentSize(quickWorkoutHeight, 3)),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      Constants.assetsImagePath +
                                          _modelQuickWorkout.image!),
                                  fit: BoxFit.cover),


                            ),
                          ),
                      ),



                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: Constants.getPercentSize(quickWorkoutHeight, 5) ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(radius)),
                            color:  Colors.black26,),


                            child: Center(
                              child:

                  ConstantWidget.getTextWidgetWithFontWithMaxLine(
                      _modelQuickWorkout.name!,
                  Colors.white,
                  TextAlign.center,
                  FontWeight.w600,
                  ConstantWidget.getPercentSize(
                      quickWorkoutHeight, 13),
                  Constants.boldFontsFamily,2)

                  // getCustomText(
                  //           _modelQuickWorkout.name!,
                  //           Colors.white,
                  //           1,
                  //           TextAlign.start,
                  //           FontWeight.bold,
                  //           Constants.getPercentSize(
                  //               quickWorkoutHeight, 11)),
                            ),
                          ),

                          // Container(
                          //   width: double.infinity,
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: Constants.getPercentSize(
                          //           quickWorkoutHeight, 5.7),
                          //       horizontal: Constants.getPercentSize(
                          //           quickWorkoutSize, 2.8)),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.only(
                          //         bottomLeft: Radius.circular(7),
                          //         bottomRight: Radius.circular(7)),
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       getCustomText(
                          //           _modelQuickWorkout.name!,
                          //           Colors.black,
                          //           1,
                          //           TextAlign.start,
                          //           FontWeight.w600,
                          //           Constants.getPercentSize(
                          //               quickWorkoutHeight, 9)),
                          //       getCustomText(
                          //           4.toString() + " Workouts",
                          //           Colors.black,
                          //           1,
                          //           TextAlign.start,
                          //           FontWeight.w200,
                          //           Constants.getPercentSize(
                          //               quickWorkoutHeight, 6.5)),
                          //     ],
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    onTap: () {
                      ModelDummySend dummySend = new ModelDummySend(
                          _modelQuickWorkout.id!,
                          _modelQuickWorkout.name!,
                          Constants.getTableNames(Constants.quickWorkoutId),
                          _modelQuickWorkout.image!);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return WidgetWorkoutExerciseList(dummySend);
                        },
                      ));

                      // sendToWorkoutList(context);
                    },
                  );
                },
              ),
            ),
            // Padding(
            //     padding: EdgeInsets.all(textMargin),
            //     child: getTitleTexts(S.of(context).popularWorkouts)),
            // FutureBuilder<List<ModelPopularWorkout>>(
            //   future: _dataHelper.getAllPopularWorkoutList(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       List<ModelPopularWorkout> _quickWorkoutList = snapshot.data;
            //       // print("getsize====${_quickWorkoutList.length}");
            //       return Container(
            //         margin: EdgeInsets.all(5),
            //         height: popularWorkoutHeight,
            //         child: ListView.builder(
            //           itemCount: _quickWorkoutList.length,
            //           primary: false,
            //           shrinkWrap: true,
            //           scrollDirection: Axis.horizontal,
            //           itemBuilder: (context, index) {
            //             ModelPopularWorkout _modelQuickWorkout =
            //                 _quickWorkoutList[index];
            //             return InkWell(
            //               onTap: () {
            //                 sendToWorkoutList(context);
            //               },
            //               child: Container(
            //                 margin: EdgeInsets.all(10),
            //                 width: SizeConfig.safeBlockHorizontal! * 70,
            //                 height: double.infinity,
            //                 decoration: BoxDecoration(
            //                     boxShadow: [
            //                       BoxShadow(
            //                         color: Colors.grey,
            //                         offset: Offset(0.0, 1.5), //(x,y)
            //                         blurRadius: 2.5,
            //                       ),
            //                     ],
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(12)),
            //                     color: Constants.getColorFromHex(
            //                         _modelQuickWorkout.color)),
            //                 child: Stack(
            //                   children: [
            //                     Container(
            //                         width: double.infinity,
            //                         height: double.infinity,
            //                         decoration: BoxDecoration(
            //                             borderRadius: BorderRadius.all(
            //                                 Radius.circular(12)),
            //                             gradient: LinearGradient(
            //                               colors: [
            //                                 // List: [
            //                                 Colors.black54,
            //                                 Colors.transparent
            //                                 // Color.fromARGB(200, 0, 0, 0),
            //                                 // Color.fromARGB(0, 0, 0, 0)
            //                               ],
            //                               begin: Alignment.bottomCenter,
            //                               end: Alignment.topCenter,
            //                             ))),
            //                     Align(
            //                       alignment: Alignment.topRight,
            //                       child: Image.asset(
            //                         Constants.ASSETS_IMAGE_PATH +
            //                             _modelQuickWorkout.image,
            //                         // width: SizeConfig.safeBlockHorizontal! * 35,
            //                         height: double.infinity,
            //                         fit: BoxFit.fitHeight,
            //                       ),
            //                     ),
            //                     Align(
            //                       alignment: Alignment.bottomLeft,
            //                       child: Padding(
            //                         padding: EdgeInsets.only(
            //                             left: 10,
            //                             right:
            //                                 SizeConfig.safeBlockHorizontal! * 20,
            //                             bottom: popularWorkoutHeight / 8),
            //                         child: Text(
            //                           _modelQuickWorkout.name,
            //                           // 'No. ${imgList.indexOf(item)} image',
            //                           style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: popularWorkoutHeight / 8,
            //                             fontFamily: Constants.fontsFamily,
            //                             fontStyle: FontStyle.italic,
            //                             // fontSize: 20.0,
            //                             fontWeight: FontWeight.w700,
            //                           ),
            //                           textAlign: TextAlign.start,
            //                           maxLines: 2,
            //                         ),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     } else {
            //       return getProgressDialog();
            //     }
            //   },
            // ),
            // Padding(
            //     padding: EdgeInsets.all(textMargin),
            //     child: getTitleTexts(S.of(context).topPicks)),
            // FutureBuilder<List<ModelPopularWorkout>>(
            //   future: _dataHelper.getAllTopPicksList(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       List<ModelPopularWorkout> _quickWorkoutList = snapshot.data;
            //       // print("getsize====${_quickWorkoutList.length}");
            //       return Container(
            //         margin: EdgeInsets.all(5),
            //         child: GridView.count(
            //           crossAxisCount: 2,
            //           shrinkWrap: true,
            //           primary: false,
            //           childAspectRatio: (2 / 0.7),
            //           children:
            //               List.generate(_quickWorkoutList.length, (index) {
            //             ModelPopularWorkout _modelPopularWorkout =
            //                 _quickWorkoutList[index];
            //             return InkWell(
            //               child: Container(
            //                 height: SizeConfig.safeBlockHorizontal! * 10,
            //                 padding: EdgeInsets.only(left: 7, right: 7),
            //                 margin: EdgeInsets.all(7),
            //                 decoration: BoxDecoration(
            //                   borderRadius:
            //                       BorderRadius.all(Radius.circular(10)),
            //                   color: Constants.getColorFromHex(
            //                       _modelPopularWorkout.color),
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.grey,
            //                       offset: Offset(0.0, 1.5), //(x,y)
            //                       blurRadius: 2.5,
            //                     ),
            //                   ],
            //                 ),
            //                 child: Stack(
            //                   children: [
            //                     Align(
            //                       alignment: Alignment.centerRight,
            //                       child: Image.asset(
            //                         Constants.ASSETS_IMAGE_PATH +
            //                             _modelPopularWorkout.image,
            //                         fit: BoxFit.fitHeight,
            //                       ),
            //                     ),
            //                     Align(
            //                       alignment: Alignment.centerLeft,
            //                       child: getCustomText(
            //                           _modelPopularWorkout.name,
            //                           Colors.white,
            //                           1,
            //                           TextAlign.start,
            //                           FontWeight.w600,
            //                           14),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               onTap: () {
            //                 sendToWorkoutList(context);
            //               },
            //             );
            //             //robohash.org api provide you different images for any number you are giving
            //           }),
            //         ),
            //       );
            //     } else {
            //       return getProgressDialog();
            //     }
            //   },
            // ),
            Padding(
                padding: EdgeInsets.all(textMargin),
                child: getTitleTexts(S.of(context).bodyFitness)),

            Container(
              margin: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: _quickWorkoutList.length,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  ModelPopularWorkout _modelQuickWorkout =
                      _quickWorkoutList[index];
                  // double imagesizes =
                  //     Constants.getPercentSize(screenWidth, 35);

                  double imagesizes = Constants.getPercentSize(screenWidth, 35);


                  return InkWell(
                    child: Container(
                        height: heightBottom,
                        margin: EdgeInsets.symmetric(horizontal:
                            Constants.getPercentSize(screenWidth, 1),vertical: Constants.getPercentSize(screenWidth, 1.5)),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     borderRadius:
                            //     BorderRadius.all(Radius.circular(10)),
                            //     color: Colors.white),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    // topLeft:
                                    Radius.circular(Constants.getPercentSize(heightBottom, 15)),
                                    // bottomLeft: Radius.circular(5),
                                  ),
                                  child: Image.asset(
                                    Constants.assetsImagePath +
                                        _modelQuickWorkout.image!,
                                    height: double.infinity,
                                    width: imagesizes,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(vertical: Constants.getPercentSize(
                                        heightBottom,5)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          children: [

                                            Expanded(
                                              child: getCustomText(
                                                  _modelQuickWorkout.name!,
                                                  Colors.black,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.bold,
                                                  Constants.getPercentSize(
                                                      heightBottom,14)),
                                            ),

                                            Image.asset(Constants.assetsImagePath+"next.png",color: Colors.black,
                                              height: Constants.getPercentSize(heightBottom, 16),)
                                          ],
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: getCustomText(
                                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                                                Colors.black,
                                                2,
                                                TextAlign.start,
                                                FontWeight.w100,
                                                Constants.getPercentSize(
                                                    heightBottom,12)),
                                          ),
                                        ),
                                        getCustomText(
                                            3.toString() + " Workouts",
                                            Colors.black,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w600,
                                            Constants.getPercentSize(
                                                heightBottom,12))
                                      ],
                                    ),
                                  ),
                                ),
                                // Icon(Icons.navigate_next, color: Colors.black),
                                // SizedBox(
                                //   width: 10,
                                // ),
                              ],
                            ),
                          ),
                        )
                        // child: Stack(
                        //   children: [
                        //     // Align(
                        //     //   alignment: Alignment.bottomLeft,
                        //     //   child:
                        //     //   Container(
                        //     //     margin: EdgeInsets.all(
                        //     //         Constants.getPercentSize(
                        //     //             screenWidth, 2)),
                        //     //     width: double.infinity,
                        //     //     height: Constants.getPercentSize(
                        //     //         heightBottom, 50),
                        //     //     decoration: BoxDecoration(
                        //     //         color: Colors.white,
                        //     //         borderRadius: BorderRadius.all(
                        //     //             Radius.circular(10))),
                        //     //     child: SizedBox(),
                        //     //   ),
                        //     // ),
                        //     Container(
                        //       width: double.infinity,
                        //       height: double.infinity,
                        //       margin: EdgeInsets.only(bottom:Constants.getPercentSize(textHeight,30),right: Constants.getPercentSize(screenWidth,10)),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.all(Radius.circular(10)),
                        //           image: DecorationImage(
                        //               image: AssetImage(
                        //                   Constants.assetsImagePath +
                        //                       _modelQuickWorkout.image),
                        //               fit: BoxFit.cover)),
                        //       child: Container(
                        //         width: double.infinity,
                        //         height: double.infinity,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.all(Radius.circular(10)),
                        //           color: Colors.black45
                        //         ),
                        //       ),
                        //     ),
                        //     Align(
                        //       alignment: Alignment.bottomRight,
                        //       child: Container(
                        //         width: Constants.getPercentSize(
                        //             screenWidth, 60),
                        //         height: textHeight,
                        //         decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(color: Colors.grey.shade200,blurRadius: 4.0)
                        //           ],
                        //             borderRadius: BorderRadius.all(
                        //                 Radius.circular(10)),
                        //             color: Colors.white),
                        //         child: Center(
                        //           child: getCustomText(
                        //               _modelQuickWorkout.name,
                        //               Colors.black,
                        //               1,
                        //               TextAlign.center,
                        //               FontWeight.bold,
                        //               Constants.getPercentSize(
                        //                   textHeight, 20)),
                        //         ),
                        //       ),
                        //     )
                        //     // Align(
                        //     //   alignment: Alignment.bottomLeft,
                        //     //   child:
                        //     //   Container(
                        //     //     margin: EdgeInsets.all(
                        //     //         Constants.getPercentSize(
                        //     //             screenWidth, 2)),
                        //     //     width: double.infinity,
                        //     //     height: double.infinity,
                        //     //     decoration: BoxDecoration(
                        //     //         color: Colors.white,
                        //     //         borderRadius: BorderRadius.all(
                        //     //             Radius.circular(10))),
                        //     //     child: SizedBox(),
                        //     //   ),
                        //     // ),
                        //     // Align(
                        //     //   alignment: Alignment.topRight,
                        //     //   child: ClipRRect(
                        //     //     borderRadius: BorderRadius.all(Radius.circular(10)),
                        //     //     child: Image.asset(
                        //     //       Constants.assetsImagePath +
                        //     //           _modelQuickWorkout.image,
                        //     //       height: imagesizes,
                        //     //       width: imagesizes,
                        //     //       fit: BoxFit.cover,
                        //     //     ),
                        //     //   ),
                        //     // )
                        //   ],
                        // ),
                        ),
                    onTap: () {
                      ModelDummySend dummySend = new ModelDummySend(
                          _modelQuickWorkout.id!,
                          _modelQuickWorkout.name!,
                          Constants.getTableNames(Constants.stretchesId),
                          _modelQuickWorkout.image!);
                      // dummySend.tableName =
                      //     Constants.getTableNames(Constants.stretchesId);
                      // dummySend.id = _modelQuickWorkout.id;
                      // dummySend.name = _modelQuickWorkout.name;

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return WidgetWorkoutExerciseList(dummySend);
                          // return WidgetWorkoutExerciseList(dummySend);
                        },
                      ));
                    },
                  );

                  // return InkWell(
                  //   onTap: () {
                  //     ModelDummySend dummySend = new ModelDummySend(
                  //         _modelQuickWorkout.id,
                  //         _modelQuickWorkout.name,
                  //         Constants.getTableNames(Constants.stretchesId));
                  //     // dummySend.tableName =
                  //     //     Constants.getTableNames(Constants.stretchesId);
                  //     // dummySend.id = _modelQuickWorkout.id;
                  //     // dummySend.name = _modelQuickWorkout.name;
                  //
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) {
                  //         return WidgetWorkoutExerciseList(dummySend);
                  //         // return WidgetWorkoutExerciseList(dummySend);
                  //       },
                  //     ));
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.all(10),
                  //     padding: EdgeInsets.only(left: 7, right: 7),
                  //     width: double.infinity,
                  //     height: SizeConfig.safeBlockHorizontal! * 18,
                  //     decoration: BoxDecoration(
                  //         borderRadius:
                  //         BorderRadius.all(Radius.circular(10)),
                  //         // color: Constants.getColorFromHex(
                  //         //     _modelQuickWorkout.color),
                  //         gradient: new LinearGradient(
                  //             colors: [
                  //               Constants.darken(
                  //                   Constants.getColorFromHex(
                  //                       _modelQuickWorkout.color)),
                  //               Constants.brighten(
                  //                   Constants.getColorFromHex(
                  //                       _modelQuickWorkout.color)),
                  //               // darken(Color(0xFF3366FF)),
                  //               // const Color(0xFF00CCFF),
                  //             ],
                  //             begin: const FractionalOffset(0.0, 0.0),
                  //             end: const FractionalOffset(1.0, 0.0),
                  //             stops: [0.0, 1.0],
                  //             tileMode: TileMode.clamp)),
                  //     child: Stack(
                  //       children: [
                  //         Align(
                  //           alignment: Alignment.centerRight,
                  //           child: SvgPicture.asset(
                  //             Constants.assetsImagePath +
                  //                 _modelQuickWorkout.image,
                  //             fit: BoxFit.fitHeight,
                  //           ),
                  //         ),
                  //         Align(
                  //           alignment: Alignment.centerLeft,
                  //           child: Padding(
                  //             padding: EdgeInsets.only(
                  //                 right: SizeConfig.safeBlockHorizontal! *
                  //                     25),
                  //             child: getCustomText(
                  //                 _modelQuickWorkout.name,
                  //                 Colors.white,
                  //                 2,
                  //                 TextAlign.start,
                  //                 FontWeight.bold,
                  //                 Constants.getPercentSize(
                  //                     SizeConfig.safeBlockHorizontal! * 18,
                  //                     25)),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              ),
            )
            // FutureBuilder<List<ModelPopularWorkout>>(
            //   future: _dataHelper.getAllStretchesList(),
            //   builder: (context, snapshot) {
            //     double heightBottom = Constants.getPercentSize(screenWidth, 30);
            //     if (snapshot.hasData) {
            //       List<ModelPopularWorkout> _quickWorkoutList = snapshot.data!;
            //       // print("getsize====${_quickWorkoutList.length}");
            //       return Container(
            //         margin: EdgeInsets.all(5),
            //         child: ListView.builder(
            //           itemCount: _quickWorkoutList.length,
            //           primary: false,
            //           shrinkWrap: true,
            //           physics: const NeverScrollableScrollPhysics(),
            //           scrollDirection: Axis.vertical,
            //           itemBuilder: (context, index) {
            //             ModelPopularWorkout _modelQuickWorkout =
            //                 _quickWorkoutList[index];
            //             // double imagesizes =
            //             //     Constants.getPercentSize(screenWidth, 35);
            //
            //
            //             double imagesizes =
            //             Constants.getPercentSize(screenWidth, 28);
            //             double radiusSer =
            //                 Constants.getPercentSize(imagesizes, 50);
            //
            //             double textHeight =
            //                 Constants.getPercentSize(heightBottom, 40);
            //             // return InkWell(
            //             //   child: Container(
            //             //       height: heightBottom,
            //             //       margin: EdgeInsets.all(
            //             //           Constants.getPercentSize(screenWidth, 3)),
            //             //       child: Container(
            //             //         decoration: BoxDecoration(
            //             //             borderRadius:
            //             //                 BorderRadius.all(Radius.circular(10)),
            //             //             color: itemBgColor),
            //             //         child: Row(
            //             //           children: [
            //             //             ClipRRect(
            //             //               borderRadius: BorderRadius.only(
            //             //                   topLeft: Radius.circular(10),
            //             //                   bottomLeft: Radius.circular(10),
            //             //                   topRight: Radius.circular(radiusSer),
            //             //                   bottomRight:
            //             //                       Radius.circular(radiusSer)),
            //             //               child: Image.asset(
            //             //                 Constants.assetsImagePath +
            //             //                     _modelQuickWorkout.image!,
            //             //                 height: double.infinity,
            //             //                 width: imagesizes,
            //             //                 fit: BoxFit.cover,
            //             //               ),
            //             //             ),
            //             //             SizedBox(
            //             //               width: 4,
            //             //             ),
            //             //             Column(
            //             //               mainAxisAlignment:
            //             //                   MainAxisAlignment.center,
            //             //               crossAxisAlignment:
            //             //                   CrossAxisAlignment.start,
            //             //               children: [
            //             //                 getCustomText(
            //             //                     _modelQuickWorkout.name!,
            //             //                     Colors.black,
            //             //                     1,
            //             //                     TextAlign.start,
            //             //                     FontWeight.bold,
            //             //                     Constants.getPercentSize(
            //             //                         screenWidth, 4.3)),
            //             //                 FutureBuilder<
            //             //                     List<ModelWorkoutExerciseList>>(
            //             //                   future: _dataHelper
            //             //                       .getWorkoutExerciseListByTableAndId(
            //             //                           _modelQuickWorkout.id!,
            //             //                           Constants.getTableNames(
            //             //                               Constants.stretchesId)),
            //             //                   builder: (context, snapshot) {
            //             //                     String s = "";
            //             //                     if (snapshot.hasData) {
            //             //                       s = snapshot.data!.length
            //             //                               .toString() +
            //             //                           " Workouts";
            //             //                     }
            //             //                     return getCustomText(
            //             //                         s,
            //             //                         Colors.black,
            //             //                         1,
            //             //                         TextAlign.start,
            //             //                         FontWeight.w300,
            //             //                         Constants.getPercentSize(
            //             //                             screenWidth, 4));
            //             //                   },
            //             //                 )
            //             //               ],
            //             //             )
            //             //           ],
            //             //         ),
            //             //       )
            //             //       // child: Stack(
            //             //       //   children: [
            //             //       //     // Align(
            //             //       //     //   alignment: Alignment.bottomLeft,
            //             //       //     //   child:
            //             //       //     //   Container(
            //             //       //     //     margin: EdgeInsets.all(
            //             //       //     //         Constants.getPercentSize(
            //             //       //     //             screenWidth, 2)),
            //             //       //     //     width: double.infinity,
            //             //       //     //     height: Constants.getPercentSize(
            //             //       //     //         heightBottom, 50),
            //             //       //     //     decoration: BoxDecoration(
            //             //       //     //         color: Colors.white,
            //             //       //     //         borderRadius: BorderRadius.all(
            //             //       //     //             Radius.circular(10))),
            //             //       //     //     child: SizedBox(),
            //             //       //     //   ),
            //             //       //     // ),
            //             //       //     Container(
            //             //       //       width: double.infinity,
            //             //       //       height: double.infinity,
            //             //       //       margin: EdgeInsets.only(bottom:Constants.getPercentSize(textHeight,30),right: Constants.getPercentSize(screenWidth,10)),
            //             //       //       decoration: BoxDecoration(
            //             //       //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //             //       //           image: DecorationImage(
            //             //       //               image: AssetImage(
            //             //       //                   Constants.assetsImagePath +
            //             //       //                       _modelQuickWorkout.image),
            //             //       //               fit: BoxFit.cover)),
            //             //       //       child: Container(
            //             //       //         width: double.infinity,
            //             //       //         height: double.infinity,
            //             //       //         decoration: BoxDecoration(
            //             //       //           borderRadius: BorderRadius.all(Radius.circular(10)),
            //             //       //           color: Colors.black45
            //             //       //         ),
            //             //       //       ),
            //             //       //     ),
            //             //       //     Align(
            //             //       //       alignment: Alignment.bottomRight,
            //             //       //       child: Container(
            //             //       //         width: Constants.getPercentSize(
            //             //       //             screenWidth, 60),
            //             //       //         height: textHeight,
            //             //       //         decoration: BoxDecoration(
            //             //       //           boxShadow: [
            //             //       //             BoxShadow(color: Colors.grey.shade200,blurRadius: 4.0)
            //             //       //           ],
            //             //       //             borderRadius: BorderRadius.all(
            //             //       //                 Radius.circular(10)),
            //             //       //             color: Colors.white),
            //             //       //         child: Center(
            //             //       //           child: getCustomText(
            //             //       //               _modelQuickWorkout.name,
            //             //       //               Colors.black,
            //             //       //               1,
            //             //       //               TextAlign.center,
            //             //       //               FontWeight.bold,
            //             //       //               Constants.getPercentSize(
            //             //       //                   textHeight, 20)),
            //             //       //         ),
            //             //       //       ),
            //             //       //     )
            //             //       //     // Align(
            //             //       //     //   alignment: Alignment.bottomLeft,
            //             //       //     //   child:
            //             //       //     //   Container(
            //             //       //     //     margin: EdgeInsets.all(
            //             //       //     //         Constants.getPercentSize(
            //             //       //     //             screenWidth, 2)),
            //             //       //     //     width: double.infinity,
            //             //       //     //     height: double.infinity,
            //             //       //     //     decoration: BoxDecoration(
            //             //       //     //         color: Colors.white,
            //             //       //     //         borderRadius: BorderRadius.all(
            //             //       //     //             Radius.circular(10))),
            //             //       //     //     child: SizedBox(),
            //             //       //     //   ),
            //             //       //     // ),
            //             //       //     // Align(
            //             //       //     //   alignment: Alignment.topRight,
            //             //       //     //   child: ClipRRect(
            //             //       //     //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //             //       //     //     child: Image.asset(
            //             //       //     //       Constants.assetsImagePath +
            //             //       //     //           _modelQuickWorkout.image,
            //             //       //     //       height: imagesizes,
            //             //       //     //       width: imagesizes,
            //             //       //     //       fit: BoxFit.cover,
            //             //       //     //     ),
            //             //       //     //   ),
            //             //       //     // )
            //             //       //   ],
            //             //       // ),
            //             //       ),
            //             //   onTap: () {
            //             //     ModelDummySend dummySend = new ModelDummySend(
            //             //         _modelQuickWorkout.id!,
            //             //         _modelQuickWorkout.name!,
            //             //         Constants.getTableNames(Constants.stretchesId),
            //             //         _modelQuickWorkout.image!);
            //             //     // dummySend.tableName =
            //             //     //     Constants.getTableNames(Constants.stretchesId);
            //             //     // dummySend.id = _modelQuickWorkout.id;
            //             //     // dummySend.name = _modelQuickWorkout.name;
            //             //
            //             //     Navigator.of(context).push(MaterialPageRoute(
            //             //       builder: (context) {
            //             //         return WidgetWorkoutExerciseList(dummySend);
            //             //         // return WidgetWorkoutExerciseList(dummySend);
            //             //       },
            //             //     ));
            //             //   },
            //             // );
            //
            //             return InkWell(
            //               child: Container(
            //                   height: heightBottom,
            //                   margin: EdgeInsets.all(
            //                       Constants.getPercentSize(screenWidth, 3)),
            //                   child: Card(
            //                     color: Colors.white,
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.all(Radius.circular(5)),
            //                     ),
            //                     child: Container(
            //                       // decoration: BoxDecoration(
            //                       //     borderRadius:
            //                       //     BorderRadius.all(Radius.circular(10)),
            //                       //     color: Colors.white),
            //                       child: Row(
            //                         children: [
            //                           ClipRRect(
            //                             borderRadius: BorderRadius.only(
            //                                 topLeft: Radius.circular(5),
            //                                 bottomLeft: Radius.circular(5),),
            //                             child: Image.asset(
            //                               Constants.assetsImagePath +
            //                                   _modelQuickWorkout.image!,
            //                               height: double.infinity,
            //                               width: imagesizes,
            //                               fit: BoxFit.cover,
            //                             ),
            //                           ),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                           Expanded(
            //                             child: Column(
            //                               mainAxisAlignment:
            //                               MainAxisAlignment.center,
            //                               crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                               children: [
            //                                 getCustomText(
            //                                     _modelQuickWorkout.name!,
            //                                     Colors.black,
            //                                     1,
            //                                     TextAlign.start,
            //                                     FontWeight.bold,
            //                                     Constants.getPercentSize(
            //                                         screenWidth, 4.3)),
            //
            //
            //                                 Padding(
            //                                   padding: EdgeInsets.only(top: 5),
            //                                   child: getCustomText(
            //                                       3
            //                                           .toString() +
            //                                           " Workouts",
            //                                       Colors.black,
            //                                       1,
            //                                       TextAlign.start,
            //                                       FontWeight.w300,
            //                                       Constants.getPercentSize(
            //                                           screenWidth, 4)),
            //                                 )
            //                               ],
            //                             ),
            //                           ),
            //
            //
            //                           Icon(Icons.navigate_next,color: Colors.black),
            //                           SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   )
            //                 // child: Stack(
            //                 //   children: [
            //                 //     // Align(
            //                 //     //   alignment: Alignment.bottomLeft,
            //                 //     //   child:
            //                 //     //   Container(
            //                 //     //     margin: EdgeInsets.all(
            //                 //     //         Constants.getPercentSize(
            //                 //     //             screenWidth, 2)),
            //                 //     //     width: double.infinity,
            //                 //     //     height: Constants.getPercentSize(
            //                 //     //         heightBottom, 50),
            //                 //     //     decoration: BoxDecoration(
            //                 //     //         color: Colors.white,
            //                 //     //         borderRadius: BorderRadius.all(
            //                 //     //             Radius.circular(10))),
            //                 //     //     child: SizedBox(),
            //                 //     //   ),
            //                 //     // ),
            //                 //     Container(
            //                 //       width: double.infinity,
            //                 //       height: double.infinity,
            //                 //       margin: EdgeInsets.only(bottom:Constants.getPercentSize(textHeight,30),right: Constants.getPercentSize(screenWidth,10)),
            //                 //       decoration: BoxDecoration(
            //                 //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //                 //           image: DecorationImage(
            //                 //               image: AssetImage(
            //                 //                   Constants.assetsImagePath +
            //                 //                       _modelQuickWorkout.image),
            //                 //               fit: BoxFit.cover)),
            //                 //       child: Container(
            //                 //         width: double.infinity,
            //                 //         height: double.infinity,
            //                 //         decoration: BoxDecoration(
            //                 //           borderRadius: BorderRadius.all(Radius.circular(10)),
            //                 //           color: Colors.black45
            //                 //         ),
            //                 //       ),
            //                 //     ),
            //                 //     Align(
            //                 //       alignment: Alignment.bottomRight,
            //                 //       child: Container(
            //                 //         width: Constants.getPercentSize(
            //                 //             screenWidth, 60),
            //                 //         height: textHeight,
            //                 //         decoration: BoxDecoration(
            //                 //           boxShadow: [
            //                 //             BoxShadow(color: Colors.grey.shade200,blurRadius: 4.0)
            //                 //           ],
            //                 //             borderRadius: BorderRadius.all(
            //                 //                 Radius.circular(10)),
            //                 //             color: Colors.white),
            //                 //         child: Center(
            //                 //           child: getCustomText(
            //                 //               _modelQuickWorkout.name,
            //                 //               Colors.black,
            //                 //               1,
            //                 //               TextAlign.center,
            //                 //               FontWeight.bold,
            //                 //               Constants.getPercentSize(
            //                 //                   textHeight, 20)),
            //                 //         ),
            //                 //       ),
            //                 //     )
            //                 //     // Align(
            //                 //     //   alignment: Alignment.bottomLeft,
            //                 //     //   child:
            //                 //     //   Container(
            //                 //     //     margin: EdgeInsets.all(
            //                 //     //         Constants.getPercentSize(
            //                 //     //             screenWidth, 2)),
            //                 //     //     width: double.infinity,
            //                 //     //     height: double.infinity,
            //                 //     //     decoration: BoxDecoration(
            //                 //     //         color: Colors.white,
            //                 //     //         borderRadius: BorderRadius.all(
            //                 //     //             Radius.circular(10))),
            //                 //     //     child: SizedBox(),
            //                 //     //   ),
            //                 //     // ),
            //                 //     // Align(
            //                 //     //   alignment: Alignment.topRight,
            //                 //     //   child: ClipRRect(
            //                 //     //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //                 //     //     child: Image.asset(
            //                 //     //       Constants.assetsImagePath +
            //                 //     //           _modelQuickWorkout.image,
            //                 //     //       height: imagesizes,
            //                 //     //       width: imagesizes,
            //                 //     //       fit: BoxFit.cover,
            //                 //     //     ),
            //                 //     //   ),
            //                 //     // )
            //                 //   ],
            //                 // ),
            //               ),
            //               onTap: () {
            //                 ModelDummySend dummySend = new ModelDummySend(
            //                     _modelQuickWorkout.id!,
            //                     _modelQuickWorkout.name!,
            //                     Constants.getTableNames(Constants.stretchesId),
            //                     _modelQuickWorkout.image!);
            //                 // dummySend.tableName =
            //                 //     Constants.getTableNames(Constants.stretchesId);
            //                 // dummySend.id = _modelQuickWorkout.id;
            //                 // dummySend.name = _modelQuickWorkout.name;
            //
            //                 Navigator.of(context).push(MaterialPageRoute(
            //                   builder: (context) {
            //                     return WidgetWorkoutExerciseList(dummySend);
            //                     // return WidgetWorkoutExerciseList(dummySend);
            //                   },
            //                 ));
            //               },
            //             );
            //
            //
            //
            //
            //             // return InkWell(
            //             //   onTap: () {
            //             //     ModelDummySend dummySend = new ModelDummySend(
            //             //         _modelQuickWorkout.id,
            //             //         _modelQuickWorkout.name,
            //             //         Constants.getTableNames(Constants.stretchesId));
            //             //     // dummySend.tableName =
            //             //     //     Constants.getTableNames(Constants.stretchesId);
            //             //     // dummySend.id = _modelQuickWorkout.id;
            //             //     // dummySend.name = _modelQuickWorkout.name;
            //             //
            //             //     Navigator.of(context).push(MaterialPageRoute(
            //             //       builder: (context) {
            //             //         return WidgetWorkoutExerciseList(dummySend);
            //             //         // return WidgetWorkoutExerciseList(dummySend);
            //             //       },
            //             //     ));
            //             //   },
            //             //   child: Container(
            //             //     margin: EdgeInsets.all(10),
            //             //     padding: EdgeInsets.only(left: 7, right: 7),
            //             //     width: double.infinity,
            //             //     height: SizeConfig.safeBlockHorizontal! * 18,
            //             //     decoration: BoxDecoration(
            //             //         borderRadius:
            //             //         BorderRadius.all(Radius.circular(10)),
            //             //         // color: Constants.getColorFromHex(
            //             //         //     _modelQuickWorkout.color),
            //             //         gradient: new LinearGradient(
            //             //             colors: [
            //             //               Constants.darken(
            //             //                   Constants.getColorFromHex(
            //             //                       _modelQuickWorkout.color)),
            //             //               Constants.brighten(
            //             //                   Constants.getColorFromHex(
            //             //                       _modelQuickWorkout.color)),
            //             //               // darken(Color(0xFF3366FF)),
            //             //               // const Color(0xFF00CCFF),
            //             //             ],
            //             //             begin: const FractionalOffset(0.0, 0.0),
            //             //             end: const FractionalOffset(1.0, 0.0),
            //             //             stops: [0.0, 1.0],
            //             //             tileMode: TileMode.clamp)),
            //             //     child: Stack(
            //             //       children: [
            //             //         Align(
            //             //           alignment: Alignment.centerRight,
            //             //           child: SvgPicture.asset(
            //             //             Constants.assetsImagePath +
            //             //                 _modelQuickWorkout.image,
            //             //             fit: BoxFit.fitHeight,
            //             //           ),
            //             //         ),
            //             //         Align(
            //             //           alignment: Alignment.centerLeft,
            //             //           child: Padding(
            //             //             padding: EdgeInsets.only(
            //             //                 right: SizeConfig.safeBlockHorizontal! *
            //             //                     25),
            //             //             child: getCustomText(
            //             //                 _modelQuickWorkout.name,
            //             //                 Colors.white,
            //             //                 2,
            //             //                 TextAlign.start,
            //             //                 FontWeight.bold,
            //             //                 Constants.getPercentSize(
            //             //                     SizeConfig.safeBlockHorizontal! * 18,
            //             //                     25)),
            //             //           ),
            //             //         )
            //             //       ],
            //             //     ),
            //             //   ),
            //             // );
            //           },
            //         ),
            //       );
            //     } else {
            //       return getProgressDialog();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class _HomeWidget extends State<HomeWidget> {
  int _currentIndex = 0;

  _HomeWidget(this._currentIndex);

  List<Destination> allDestinations = [];

  static List<Widget> _widgetOptions = <Widget>[
    TabHome(),
    TabDiscover(),
    TabActivity(),
    TabSettings()

    // Text(
    //   'Index 4: School',
    //   style: optionStyle,
    // )
  ];

  // List<Destination> allDestinations = <Destination>[
  //   Destination(S.of(context).home, CupertinoIcons.home, Colors.teal),
  //   Destination('Discover', CupertinoIcons.search, Colors.cyan),
  //   Destination('Activity', CupertinoIcons.chart_bar_square, Colors.orange),
  //   // Destination('School', CupertinoIcons.chart_bar_square, Colors.orange),
  //   Destination('Settings', Icons.settings, Colors.blue)
  // ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    allDestinations = <Destination>[
      Destination(S.of(context).home, S.of(context).yogaWorkout,
          CupertinoIcons.home, Colors.teal),
      Destination(S.of(context).seasonalYoga, S.of(context).seasonalYoga,
          CupertinoIcons.search, Colors.cyan),
      Destination(S.of(context).activity, S.of(context).activity,
          CupertinoIcons.chart_bar_square, Colors.orange),
      // Destination('School', CupertinoIcons.chart_bar_square, Colors.orange),
      Destination(S.of(context).settings, S.of(context).settings,
          Icons.settings, Colors.blue)
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);

    return WillPopScope(
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          appBar: new AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: bgDarkWhite,
            title: getCustomText(allDestinations[_currentIndex].toolbarTitle,
                accentColor, 1, TextAlign.start, FontWeight.bold, 20),
          ),
          body: SafeArea(
            // top: false,
            // child: Container(
            //   color: bgDarkWhite,
            // ),
            child: _widgetOptions[this._currentIndex],
            // child: IndexedStack(
            //   index: _currentIndex,
            //   children: allDestinations.map<Widget>((Destination destination) {
            //     return DestinationView(destination: destination);
            //   }).toList(),
            // ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: accentColor,
            unselectedItemColor: Colors.black87,
            currentIndex: _currentIndex,
            selectedLabelStyle: TextStyle(
                fontFamily: Constants.fontsFamily,
                fontWeight: FontWeight.w600,
                fontSize: 12),
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: allDestinations.map((Destination destination) {
              return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: Colors.white,
                  // backgroundColor: destination.color,
                  // activeIcon: Icon(destination.icon,color: accentColor,),
                  label: destination.title);
            }).toList(),
          ),
        ),
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          } else {
            Future.delayed(const Duration(milliseconds: 100), () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            });
          }
          return false;
        });
  }
}
