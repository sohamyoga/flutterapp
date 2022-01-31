import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ModelExerciseDetail
{

  int? id;
  String? name;
  String? detail;
  String? image;
  String? video;


  // ModelExerciseDetail.fromMap(dynamic objects)
  // {
  //   video=objects['video'];
  //   image=objects['image'];
  //   detail=objects['detail'];
  //   name=objects['name'];
  //   id=objects['id'];
  // }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['video']=video;
    map['image']=image;
    map['detail']=detail;
    map['name']=name;
    map['id']=id;
    return map;
  }

  }