// import 'dart:collection';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:workout/models/ModelChallengeExerciseList.dart';
// import 'package:workout/models/ModelChallengesMainCat.dart';
// import 'package:workout/models/ModelDiscover.dart';
// import 'package:workout/models/ModelExerciseDetail.dart';
// import 'package:workout/models/ModelHistory.dart';
// import 'package:workout/models/ModelLastCompleteData.dart';
// import 'package:workout/models/ModelMainCategory.dart';
// import 'package:workout/models/ModelPopularWorkout.dart';
// import 'package:workout/models/ModelQuickWorkout.dart';
// import 'package:workout/models/ModelWorkoutExerciseList.dart';
// import 'package:workout/models/ModelWorkoutList.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DataHelper {
//   static final _databaseName = "flutter_workout_ui_db.db";
//   static final _databaseVersion = 1;
//
//   DataHelper._privateConstructor();
//
//   static final DataHelper instance = DataHelper._privateConstructor();
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database == null) {
//       _database = await _initDatabase();
//     }
//
//     return _database!;
//   }
//
//   _initDatabase() async {
//     var databasepath = await getDatabasesPath();
//     String path = join(databasepath, _databaseName);
//
//     var exists = await databaseExists(path);
//
//     if (!exists) {
//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (e) {
//         print(e);
//       }
//
//       ByteData data = await rootBundle.load(join("assets", _databaseName));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//
//       await File(path).writeAsBytes(bytes, flush: true);
//     } else {}
//     return await openDatabase(path, version: _databaseVersion, readOnly: false);
//   }
//
//   // Future<List<ModelMainCategory>> getAllMainCategory() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_main_category");
//   //   List<ModelMainCategory>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelMainCategory.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelChallengesMainCat>> getAllChallengesList() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_challenges_list");
//   //   List<ModelChallengesMainCat>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelChallengesMainCat.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelExerciseList>> getAllExerciseByMainCategory(int id) async {
//   //   Database database = await instance.database;
//   //   var results = await database
//   //       .query("tbl_exercise_list", where: "main_cat_id=?", whereArgs: [id]);
//   //   List<ModelExerciseList> list = results.isNotEmpty
//   //       ? results.map((c) => ModelExerciseList.fromMap(c)).toList()
//   //       : null;
//   //   return list;
//   // }
//
//   // Future<List<ModelQuickWorkout>> getAllQuickWorkoutList() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_quick_workout");
//   //   List<ModelQuickWorkout>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelQuickWorkout.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelPopularWorkout>> getAllPopularWorkoutList() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_popular_workout");
//   //   List<ModelPopularWorkout>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelPopularWorkout.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelPopularWorkout>> getAllTopPicksList() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_top_picks");
//   //   List<ModelPopularWorkout>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelPopularWorkout.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelPopularWorkout>> getAllStretchesList() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_stretches");
//   //   List<ModelPopularWorkout>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelPopularWorkout.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//
//
//   //
//   // Future<List<ModelDiscover>> getAllDiscoverWorkouts() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_discover");
//   //   List<ModelDiscover>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelDiscover.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelWorkoutList>> getWorkoutList() async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_workout_list");
//   //   List<ModelWorkoutList>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelWorkoutList.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
// // Future<List<ModelWorkoutList>> getWorkoutListByLevelType(int id) async {
// //     Database database = await instance.database;
// //     var results = await database
// //         .query("tbl_workout_list", where: "level_type=?", whereArgs: [id]);
// //     List<ModelWorkoutList> list = results.isNotEmpty
// //         ? results.map((c) => ModelWorkoutList.fromMap(c)).toList()
// //         : null;
// //     return list;
// //   }
// //
//
//   // Future<List<ModelHistory>> getHistoryByDate(String date) async {
//   //   Database database = await instance.database;
//   //   var results =
//   //       await database.query("tbl_history", where: "date=?", whereArgs: [date]);
//   //   List<ModelHistory>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelHistory.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<List<ModelChallengeExerciseList>> getChallengeExerciseList(
//   //     int challengeId, int week, int day) async {
//   //   print("getquery===$challengeId--$week--$day");
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_challenge_exercise_list",
//   //       where: "challenge_id=? AND week=? AND day=?",
//   //       whereArgs: [challengeId, week, day]);
//   //   List<ModelChallengeExerciseList>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelChallengeExerciseList.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<int> addHistoryData(String title, String startTime, int totalDuration,
//   //     String kcal, String date) async {
//   //   Database database = await instance.database;
//   //   var map = new HashMap<String, dynamic>();
//   //   print("addcal==$kcal");
//   //   map['title'] = title;
//   //   // map['title'] = title;
//   //   map['start_time'] = startTime;
//   //   map['total_duration'] = totalDuration;
//   //   map['kcal'] = kcal;
//   //   map['date'] = date;
//   //   return database.insert("tbl_history", map, nullColumnHack: 'id');
//   // }
//
//
//   // Future calculateTotalWorkout() async {
//   //   Database database = await instance.database;
//   //   var result = await database.rawQuery("SELECT SUM(kcal) as Total FROM tbl_history");
//   //   print(result.toList());
//   // }
//
//   // Future<List> calculateTotalWorkout() async {
//   //   Database database = await instance.database;
//   //   var result = await database.rawQuery("SELECT * FROM tbl_history");
//   //   return result.toList();
//   // }
//
//   // Future<List<ModelHistory>> calculateTotalWorkout() async {
//   //   // Database database = await instance.database;
//   //   // var result = await database.rawQuery("SELECT * FROM tbl_history");
//   //
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_history");
//   //   List<ModelHistory>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelHistory.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   //
//   //   // return result.toList();
//   // }
//
//   // Future<List<ModelWorkoutExerciseList>> getWorkoutExerciseListById(
//   //     int id) async {
//   //   id = 1;
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_workout_exercise_list",
//   //       where: "workout_id=?", whereArgs: [id]);
//   //   List<ModelWorkoutExerciseList>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelWorkoutExerciseList.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<int> addCompleteChallengeData(
//   //     int week, int day, int challengeId) async {
//   //   Database database = await instance.database;
//   //   var map = new HashMap<String, dynamic>();
//   //
//   //   var res = await database.query("complete_challenge_data",
//   //       where: "challenge_id=? AND week=? AND day=?",
//   //       whereArgs: [challengeId, week, day]);
//   //   if (res.isNotEmpty) {
//   //     await database.delete("complete_challenge_data",
//   //         where: "challenge_id=? AND week=? AND day=?",
//   //         whereArgs: [challengeId, week, day]);
//   //   }
//   //   // if (res.isEmpty) {
//   //   map['challenge_id'] = challengeId;
//   //   map['week'] = week;
//   //   map['day'] = day;
//   //   print("challengedata==$week==$day==$challengeId");
//   //
//   //   return await database.insert('"complete_challenge_data"', map,
//   //       nullColumnHack: 'id');
//   //   // }
//   //   // else {
//   //   //   print("challengedata11==$week==$day==$challengeId");
//   //   //
//   //   //   return await database.delete("complete_challenge_data",
//   //   //       where: "challenge_id=? AND week=? AND day=?",
//   //   //       whereArgs: [challengeId, week, day]);
//   //   // }
//   // }
//
//   // Future<int> resetChallengePlanData(int catId, int week) async {
//   //   Database database = await instance.database;
//   //   return await database.delete("complete_challenge_data",
//   //       where: "challenge_id=? AND week=?", whereArgs: [catId, week]);
//   // }
//
//   // Future<int> getChallengeProgressPercentage(int catId, int totalWeek) async {
//   //   Database database = await instance.database;
//   //   int totalWeeks = totalWeek;
//   //   int totalExercise = totalWeeks * 7;
//   //
//   //   // var results = await database.query("tbl_challenge_exercise_list",
//   //   //     where: "challenge_id=?", whereArgs: [catId]);
//   //   // int totalExercise = results.length;
//   //   var results2 = await database.query("complete_challenge_data",
//   //       where: "challenge_id=?", whereArgs: [catId]);
//   //   // int completeExercise = 14;
//   //   int completeExercise = results2.length;
//   //   print("progress==$completeExercise");
//   //   double percent = ((completeExercise * 100) / totalExercise);
//   //   // double percent = ((completeExercise * 100) / totalExercise);
//   //   return percent.toInt();
//   // }
//
//   // Future<ModelLastCompleteData> getLastCompleteChallengeData(
//   //     ModelChallengesMainCat modelChallengesMainCat) async {
//   //   Database database = await instance.database;
//   //   int catId = modelChallengesMainCat.id!;
//   //   var res = await database.rawQuery(
//   //       "SELECT DISTINCT week FROM complete_challenge_data WHERE challenge_id=$catId ORDER BY week DESC");
//   //   int lastWeek = 1;
//   //   int lastDay = 1;
//   //   if (res.isNotEmpty && res.length > 0) {
//   //     List<int>? listWeek =
//   //         res.isNotEmpty ? res.map((c) => c['week'] as int).toList() : null;
//   //     if (listWeek != null) {
//   //       lastWeek = listWeek[0];
//   //       var res2 = await database.rawQuery(
//   //           "SELECT DISTINCT day FROM complete_challenge_data WHERE challenge_id=$catId AND week=$lastWeek ORDER BY day DESC");
//   //       if (res2.isNotEmpty && res2.length > 0) {
//   //         List<int>? list = res2.isNotEmpty
//   //             ? res2.map((c) => c['day'] as int).toList()
//   //             : null;
//   //         if (list != null) {
//   //           lastDay = list[0];
//   //           var res3 = await database.rawQuery(
//   //               "SELECT DISTINCT day FROM tbl_challenge_exercise_list WHERE challenge_id=$catId AND week=$lastWeek ORDER BY day DESC");
//   //           List<int>? listAllDays = res3.isNotEmpty
//   //               ? res3.map((c) => c['day'] as int).toList()
//   //               : null;
//   //           print("lastData1===$lastWeek--$lastDay");
//   //
//   //           if (lastDay == listAllDays!.length &&
//   //               lastWeek < modelChallengesMainCat.weeks!) {
//   //             lastDay = 1;
//   //             lastWeek = lastWeek + 1;
//   //           } else if (lastDay < listAllDays.length) {
//   //             lastDay++;
//   //           }
//   //         }
//   //       }
//   //     }
//   //   }
//
//   //   print("lastData2===$lastWeek--$lastDay");
//   //
//   //   ModelLastCompleteData _modelLastCompleted =
//   //       ModelLastCompleteData(lastWeek, lastDay);
//   //   // var results = await database.query("challege_exercise_data",
//   //   //     where: "challenge_cat_id=?", whereArgs: [catId]);
//   //   // int totalExercise = results.length;
//   //   // var results2 = await database.query("complete_challenge_data",
//   //   //     where: "challenge_id=?", whereArgs: [catId]);
//   //   // int completeExercise = results2.length;
//   //   // print("progress==$results==$results2");
//   //   // double percent = ((completeExercise * 100) / totalExercise);
//   //   return _modelLastCompleted;
//   // }
//
//   // Future<bool> isChallengeCompleted(int id, int week, int day) async {
//   //   Database database = await instance.database;
//   //   var res = await database.query("complete_challenge_data",
//   //       where: "challenge_id=? AND week=? AND day=?",
//   //       whereArgs: [id, week, day]);
//   //   return res.isNotEmpty;
//   // }
//
//   // Future<List<ModelWorkoutExerciseList>> getWorkoutExerciseListByTableAndId(
//   //     int id, String tableName) async {
//   //   print("getids===$id==$tableName");
//   //   id = 1;
//   //   Database database = await instance.database;
//   //   var results =
//   //       await database.query(tableName, where: "workout_id=?", whereArgs: [id]);
//   //   print("getids===$id==$tableName=--$results");
//   //   List<ModelWorkoutExerciseList>? list = results.isNotEmpty
//   //       ? results.map((c) => ModelWorkoutExerciseList.fromMap(c)).toList()
//   //       : null;
//   //   return list!;
//   // }
//
//   // Future<ModelWorkoutList> getWorkoutLevelById(int id) async {
//   //   Database database = await instance.database;
//   //   var results = await database
//   //       .query("tbl_workout_list", where: "id=?", whereArgs: [id]);
//   //   ModelWorkoutList? list =
//   //       results.isNotEmpty ? ModelWorkoutList.fromMap(results.first) : null;
//   //   return list!;
//   // }
//
//   // Future<ModelExerciseDetail> getExerciseDetailById(int id) async {
//   //   Database database = await instance.database;
//   //   var results = await database
//   //       .query("tbl_exercise_detail", where: "id=?", whereArgs: [id]);
//   //   ModelExerciseDetail? exerciseDetail =
//   //       results.isNotEmpty ? ModelExerciseDetail.fromMap(results.first) : null;
//   //   // ModelExerciseList  list = results.isNotEmpty
//   //   //     ? results.map((c) => ModelExerciseList.fromMap(c)).toList()
//   //   //     : null;
//   //   return exerciseDetail!;
//   // }
//
//   // Future<List<ModelExerciseDetail>> getExerciseDetailByIdList(
//   //     List<int> id) async {
//   //   Database database = await instance.database;
//   //   var results = await database.query("tbl_exercise_detail",
//   //       where: "id=?", whereArgs: [1,2,3]);
//   //   // List<ModelWorkoutExerciseList> list = results.isNotEmpty
//   //   //     ? results.map((c) => ModelWorkoutExerciseList.fromMap(c)).toList()
//   //   // : null;
//   //   List<ModelExerciseDetail>? exerciseDetail =
//   //       results.isNotEmpty ?  results.map((c) => ModelExerciseDetail.fromMap(c)).toList() : null;
//   //   // ModelExerciseList  list = results.isNotEmpty
//   //   //     ? results.map((c) => ModelExerciseList.fromMap(c)).toList()
//   //   //     : null;
//   //   return exerciseDetail!;
//   // }
// }
