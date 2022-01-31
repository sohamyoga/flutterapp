import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String pkgName = "sohamyoga.home.ui";
  static String remindTime = pkgName+"ttsSetRemindTime";
  static String remindDays = pkgName+"ttsSetRemindDays";
  static String remindAmPm = pkgName+"ttsSetRemindAmPm";
  static String trainingRest = pkgName+"ttsTrainingRest";
  static String reminderOn = pkgName+"ttsIsReminderOn";
  static String calorieBurn =pkgName+"ttsCalorieBurn";
  static String getDailyGoal = pkgName+"ttsCalorieBurnDailyGoal";
  static String isFirst = pkgName+"ttsIsFirstIntro";
  static String keyHeight =pkgName+"ttsHeightKeys";
  static String keyWeight = pkgName+"ttsWeightKeys";
  static String keyIsMale = pkgName+"ttsGenderKeys";
  static String isKg = pkgName+"ttsIsKgUNit";
  static String isSoundOn = pkgName+"soundIsMutes";
  static String isTtsOn = pkgName+"ttsIsMutes";
  static String isIntro = pkgName+"isIntro";


  addRestTime(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(trainingRest, sizes);
  }

  addReminderTime(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindTime, sizes);
  }

  static setIsIntro(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isIntro, sizes);
  }


  static getIsIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(isIntro) ?? true;
    return intValue;
  }

  addReminderDays(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindDays, sizes);
  }

  addReminderAmPm(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindAmPm, sizes);
  }

  addHeight(double sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyHeight, sizes);
  }

  addWeight(double sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyWeight, sizes);
  }

  addDailyCalGoal(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(getDailyGoal, sizes);
  }

  setIsFirst(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirst, sizes);
  }

  setIsKgUnit(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isKg, sizes);
  }

  setIsReminderOn(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(reminderOn, sizes);
  }

  setIsMale(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsMale, sizes);
  }

  addBurnCalorie(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(calorieBurn, sizes);
  }

  getRestTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(trainingRest) ?? 10;
    return intValue;
  }

  getHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    double intValue = prefs.getDouble(keyHeight) ?? 100;
    return intValue;
  }

  getRemindTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    String intValue = prefs.getString(remindTime) ?? "5:30";
    return intValue;
  }

  getRemindDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    String intValue = prefs.getString(remindDays) ?? "";
    return intValue;
  }

  getRemindAmPm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    String intValue = prefs.getString(remindAmPm) ?? "AM";
    return intValue;
  }

  getWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    double intValue = prefs.getDouble(keyWeight) ?? 50;
    return intValue;
  }

  getDailyCalGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(getDailyGoal) ?? 200;
    return intValue;
  }

  getIsFirstIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(isFirst) ?? true;
    return intValue;
  }

  getIsReminderOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(reminderOn) ?? true;
    return intValue;
  }

  getIsMute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(isTtsOn) ?? true;
    return intValue;
  }

  getIsSoundOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(isSoundOn) ?? true;
    return intValue;
  }

  setIsMute(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isTtsOn, sizes);
  }

  setIsSoundOn(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isSoundOn, sizes);
  }


  getIsKgUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(isKg) ?? true;
    return intValue;
  }

  getIsMale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    bool intValue = prefs.getBool(keyIsMale) ?? true;
    return intValue;
  }

  getBurnCalorie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(calorieBurn) ?? 0;
    return intValue;
  }
}
