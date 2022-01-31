import 'package:flutter/cupertino.dart';

import 'IntroModel.dart';
import 'models/ModelChallengeExerciseList.dart';
import 'models/ModelChallengesMainCat.dart';
import 'models/ModelDiscover.dart';
import 'models/ModelExerciseDetail.dart';
import 'models/ModelPopularWorkout.dart';
import 'models/ModelQuickWorkout.dart';
import 'models/ModelWorkoutExerciseList.dart';
import 'models/ModelWorkoutList.dart';

class DataFile{


  static List<IntroModel> getIntroModel(BuildContext context) {
    List<IntroModel> introList = [];

    IntroModel mainModel = new IntroModel();
    mainModel.id = 1;
    mainModel.name = "Daily Yoga";
    mainModel.image = "intro_1.png";
    mainModel.desc ="Do your practice of physical exercise and relaxation make helthy";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 2;
    mainModel.name = "Yoga Classes";
    mainModel.image = "intro_2.png";
    mainModel.desc ="Meditation is the key to Productivity.Happiness & Longevity";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 3;
    mainModel.name = "Practice Yoga";
    mainModel.image = "intro_3.png";
    mainModel.desc ="Do your practice of Physical exercise and relaxation";
    introList.add(mainModel);

    return introList;
  }



  static List<ModelChallengesMainCat> challengesMainCat(){
    List<ModelChallengesMainCat> list=[];

    ModelChallengesMainCat modelChallengesMainCat = new ModelChallengesMainCat();
    modelChallengesMainCat.image = "asthanga_yoga.jpg";
    modelChallengesMainCat.icon = "yoga_images.png";
    modelChallengesMainCat.background = "asthanga_yoga.jpg";
    modelChallengesMainCat.title = "Beginner";
    modelChallengesMainCat.weeks = 7;
    modelChallengesMainCat.id = 1;
    list.add(modelChallengesMainCat);



    modelChallengesMainCat = new ModelChallengesMainCat();
    modelChallengesMainCat.image = "asthanga_yoga.jpg";
    modelChallengesMainCat.background = "asthanga_yoga.jpg";
    modelChallengesMainCat.title = "Intermediate";
    modelChallengesMainCat.weeks = 7;
    modelChallengesMainCat.id = 2;
    modelChallengesMainCat.icon = "hathha_yoga.png";
    list.add(modelChallengesMainCat);


    modelChallengesMainCat = new ModelChallengesMainCat();
    modelChallengesMainCat.image = "asthanga_yoga.jpg";
    modelChallengesMainCat.icon = "yoga_imges5.png";
    modelChallengesMainCat.background = "asthanga_yoga.jpg";
    modelChallengesMainCat.title = "Advanced";
    modelChallengesMainCat.weeks = 6;
    modelChallengesMainCat.id = 3;
    list.add(modelChallengesMainCat);

    return list;
  }


  static List<ModelChallengeExerciseList> getExerciseList(){
    List<ModelChallengeExerciseList> list=[];

    ModelChallengeExerciseList model = new ModelChallengeExerciseList();
    model.duration = "10";
    model.id = 1;
    model.exercise_id = 1;
    model.day = 1;
    model.week = 1;
    model.challenge_id = 1;
    list.add(model);



    model = new ModelChallengeExerciseList();
    model.duration = "10";
    model.id = 2;
    model.exercise_id = 1;
    model.day = 1;
    model.week = 1;
    model.challenge_id = 1;
    list.add(model);


    model = new ModelChallengeExerciseList();
    model.duration = "10";
    model.id = 3;
    model.exercise_id = 1;
    model.day = 1;
    model.week = 1;
    model.challenge_id = 1;
    list.add(model);


    model = new ModelChallengeExerciseList();
    model.duration = "10";
    model.id = 4;
    model.exercise_id = 1;
    model.day = 1;
    model.week = 1;
    model.challenge_id = 1;
    list.add(model);



    model = new ModelChallengeExerciseList();
    model.duration = "10";
    model.id = 5;
    model.exercise_id = 1;
    model.day = 1;
    model.week = 1;
    model.challenge_id = 1;
    list.add(model);

    return list;
  }


  static List<ModelExerciseDetail> getExerciseDetailList(){
    List<ModelExerciseDetail> list=[];

    ModelExerciseDetail model = new ModelExerciseDetail();
    model.id = 1;
    model.image = "abs_1";
    model.name = "Beginner";

    model.detail = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

    list.add(model);




    model = new ModelExerciseDetail();
    model.id = 2;
    model.image = "abs_1";
    model.name = "Beginner";

    model.detail = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

    list.add(model);

    model = new ModelExerciseDetail();
    model.id = 3;
    model.image = "abs_1";
    model.name = "Beginner";
    model.detail = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";


    list.add(model);


    model = new ModelExerciseDetail();
    model.id = 4;
    model.image = "abs_1";
    model.name = "Beginner";
    model.detail = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";


    list.add(model);

    model = new ModelExerciseDetail();
    model.id = 5;
    model.image = "abs_1";
    model.name = "Beginner";
    model.detail = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";


    list.add(model);
    return list;
  }



  static List<ModelWorkoutExerciseList> getWorkoutExerciseList(){
    List<ModelWorkoutExerciseList> list=[];

    ModelWorkoutExerciseList model = new ModelWorkoutExerciseList();
    model.duration = "10";
    model.exerciseId = 1;

    model.id = 1;
    list.add(model);



     model = new ModelWorkoutExerciseList();
    model.duration = "10";
    model.exerciseId = 1;

    model.id = 2;
    list.add(model);


    model = new ModelWorkoutExerciseList();
    model.duration = "10";
    model.exerciseId = 1;

    model.id = 3;
    list.add(model);

    model = new ModelWorkoutExerciseList();
    model.duration = "10";
    model.exerciseId = 1;

    model.id = 4;
    list.add(model);


    model = new ModelWorkoutExerciseList();
    model.duration = "10";
    model.exerciseId = 1;

    model.id = 5;
    list.add(model);

    return list;
  }
  static List<ModelWorkoutList> getWorkoutList(){
    List<ModelWorkoutList> list=[];

    ModelWorkoutList model = new ModelWorkoutList();
    model.name = "Sun Salutation";
    model.image = "sun_salutation.jpg";

    model.id = 1;
    list.add(model);



    model = new ModelWorkoutList();
    model.name = "Seated Yoga";
    model.image = "seated_yoga.jpg";
    model.id = 2;
    list.add(model);


    model = new ModelWorkoutList();
    model.name = "Standing Yoga";
    model.image = "standing_yoga.jpg";
    model.id = 3;
    list.add(model);

    model = new ModelWorkoutList();
    model.name = "Floor Yoga";
    model.image = "floor_yoga.jpg";
    model.id = 4;
    list.add(model);


    return list;
  }
static List<ModelDiscover> getDiscoverList(){
    List<ModelDiscover> list=[];

    ModelDiscover model = new ModelDiscover();
    model.id =1;
    model.title ="Winter Season";
    model.description ="Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
    model.image ="yoga_imges5.png";

    list.add(model);


    model = new ModelDiscover();
    model.id =2;
    model.title ="Fall Season";
    model.description ="Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
    model.image ="mediation.png";
    list.add(model);


    model = new ModelDiscover();
    model.id =3;
    model.title ="Summer Season";
    model.description ="Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
    model.image ="leg_1.png";
    list.add(model);



    model = new ModelDiscover();
    model.id =4;
    model.title ="Spring Season";
    model.description ="Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
    model.image ="mediation_2.png";
    list.add(model);


    return list;
  }

static List<ModelPopularWorkout> getPopularList(){
    List<ModelPopularWorkout> list=[];

    ModelPopularWorkout model = new ModelPopularWorkout();
    model.id =1;
    model.image ="abs_workout.jpg";
    model.name ="Abs Workout";
    list.add(model);


    model = new ModelPopularWorkout();
    model.id =2;
    model.image ="glutes_workout.jpg";
    model.name ="Glutes/Butt Workout";
    list.add(model);


    model = new ModelPopularWorkout();
    model.id =3;
    model.image ="legs_workout.jpg";
    model.name ="Leg Workout";
    list.add(model);


    model = new ModelPopularWorkout();
    model.id =4;
    model.image ="back_workout.jpg";
    model.name ="Back Workout";
    list.add(model);



    model = new ModelPopularWorkout();
    model.id =5;
    model.image ="chest_workout.jpg";
    model.name ="Chest Workout";
    list.add(model);


    model = new ModelPopularWorkout();
    model.id =6;
    model.image ="arms_workout.jpg";
    model.name ="Arms Workout";
    list.add(model);

    model = new ModelPopularWorkout();
    model.id =7;
    model.image ="shoulders_workout.jpg";
    model.name ="Shoulders Workout";
    list.add(model);


    model = new ModelPopularWorkout();
    model.id =8;
    model.image ="neck_workout.jpg";
    model.name ="Neck Workout";
    list.add(model);

    return list;
  }


  static List<ModelQuickWorkout> getQuickList(){
    List<ModelQuickWorkout> list=[];

    ModelQuickWorkout model = new ModelQuickWorkout();
    model.id =1;
    model.image ="hathha_yoga.png";
    model.name ="Hatha Yoga";
    list.add(model);


    model = new ModelQuickWorkout();
    model.id =2;
    model.image ="power_yoga.png";
    model.name ="Power Yoga";
    list.add(model);


    model = new ModelQuickWorkout();
    model.id =3;
    model.image ="leg_1.png";
    model.name ="Leg Workout";
    list.add(model);


    model = new ModelQuickWorkout();
    model.id =4;
    model.image ="hathha_yoga.png";
    model.name ="Bikram Yoga";
    list.add(model);



    model = new ModelQuickWorkout();
    model.id =5;
    model.image ="yoga_images_1.png";
    model.name ="Vinayasa Yoga";
    list.add(model);


    model = new ModelQuickWorkout();
    model.id =6;
    model.image ="yoga_imges5.png";
    model.name ="Asthana Yoga";
    list.add(model);

    model = new ModelQuickWorkout();
    model.id =7;
    model.image ="mask_group.png";
    model.name ="Iyengar Yoga";
    list.add(model);

    return list;
  }


}