import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workout/Constants.dart';

import 'ColorCategory.dart';
import 'SplashScreen.dart';
import 'generated/l10n.dart';

const MethodChannel platform = MethodChannel('dexterx.dev/workout');

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int? id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  runApp(
    BetterFeedback(
      child: MyApp(),
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName =
      await platform.invokeMethod<String>('getTimeZoneName');
  print("getname===$timeZoneName");
  try {
    Location getlocal =
        tz.getLocation(timeZoneName!.replaceAll("Calcutta", "Kolkata"));
    tz.setLocalLocation(getlocal);
  } catch (e) {
    print(e);
    Location getlocal = tz.getLocation(Constants.defTimeZoneName);
    tz.setLocalLocation(getlocal);
    print("getnamerr=${e.toString()}");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ThemeData themeData = new ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor));

  void _requestPermissions() {}

  void _configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      // await Navigator.pushNamed(context, '/secondPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions();

    _configureDidReceiveLocalNotificationSubject(context);
    _configureSelectNotificationSubject();
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      // locale: new Locale(setLocals, ''),
      title: 'Flutter Demo',
      theme: themeData,

      home: SplashScreen(),
      // home: IntroScreen(),
    );
  }
}
