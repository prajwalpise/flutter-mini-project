import 'dart:math';

import 'package:bmi_calculator/age_weight_widget.dart';
import 'package:bmi_calculator/gender_widget.dart';
import 'package:bmi_calculator/height_widget.dart';
import 'package:bmi_calculator/score_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("BMI Calculator"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 12,
              shape: const RoundedRectangleBorder(),
              child: Column(
                children: [
                  //Lets create widget for gender selection
                  GenderWidget(
                    onChange: (genderVal) {
                    },
                  ),
                  HeightWidget(
                    onChange: (heightVal) {
                      _height = heightVal;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AgeWeightWidget(
                          onChange: (ageVal) {
                            _age = ageVal;
                          },
                          title: "Age",
                          initValue: 30,
                          min: 0,
                          max: 100),
                      AgeWeightWidget(
                          onChange: (weightVal) {
                            _weight = weightVal;
                          },
                          title: "Weight(Kg)",
                          initValue: 50,
                          min: 0,
                          max: 200)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 60),
                    child: SwipeableButtonView(
                        isFinished: _isFinished,
                        onFinish: () async {
                          await Navigator.push(
                              context,
                              PageTransition(
                                  child: ScoreScreen(
                                    bmiScore: _bmiScore,
                                    age: _age,
                                  ),
                                  type: PageTransitionType.fade));

                          setState(() {
                            _isFinished = false;
                          });
                        },
                        onWaitingProcess: () {
                          //Calculate BMI here
                          calculateBmi();

                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              _isFinished = true;
                            });
                          });
                        },
                        activeColor: Colors.blue,
                        buttonWidget: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        ),
                        buttonText: "CALCULATE"),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
