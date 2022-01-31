import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ModelChallengeExerciseList {
  int? id;
  int? challenge_id; // ignore: non_constant_identifier_names
  int? day;
  int? week;
  // ignore: non_constant_identifier_names
  int? exercise_id;
  String? duration;

  //
  // ModelChallengeExerciseList.fromMap(dynamic dynamicObj) {
  //   duration = dynamicObj['duration'];
  //   exercise_id = dynamicObj['exercise_id'];
  //   week = dynamicObj['week'];
  //   day = dynamicObj['day'];
  //   challenge_id = dynamicObj['challenge_id'];
  //   id = dynamicObj['id'];
  // }


  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['duration'] = duration;
    map['exercise_id'] = exercise_id;
    map['week'] = week;
    map['day'] = day;
    map['challenge_id'] = challenge_id;
    map['id'] = id;
    return map;
  }


}
