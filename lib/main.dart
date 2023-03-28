// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  Duration duration = Duration(minutes: 25);
  Timer? reFunc;
  counter() {
    reFunc = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int newSec = duration.inSeconds - 1;
        duration = Duration(seconds: newSec);
      });
      if (duration.inSeconds == 0) {
        setState(() {
          reFunc!.cancel();
          duration = Duration(minutes: 25);
          isRunning = false;
        });
      }
    });
  }

  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Pomodoro",
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          backgroundColor:
              isRunning ? Colors.red : Color.fromARGB(255, 50, 65, 71),
        ),
        backgroundColor: Color.fromARGB(255, 33, 40, 43),
        body: SizedBox(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                        radius: 120,
                        center: Text(
                            "${duration.inMinutes.toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                            style:
                                TextStyle(fontSize: 80, color: Colors.white)),
                        progressColor: Colors.red,
                        backgroundColor: Colors.grey,
                        lineWidth: 8.0,
                        percent: duration.inMinutes / 25,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: 2000),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                isRunning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (reFunc!.isActive) {
                                setState(() {
                                  reFunc!.cancel();
                                });
                              } else {
                                counter();
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.all(8)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child: Text(
                                (reFunc!.isActive)
                                    ? "Stop studying"
                                    : "Resume studying",
                                style: TextStyle(fontSize: 20)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                reFunc!.cancel();
                                duration = Duration(minutes: 25);
                                isRunning = false;
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.all(8)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child:
                                Text("Cancel", style: TextStyle(fontSize: 24)),
                          )
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            counter();
                            isRunning = true;
                          });
                        },
                        style: ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(8)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        child: Text("Start studying",
                            style: TextStyle(fontSize: 24)),
                      ),
                SizedBox(height: 50),
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  DateFormat("hh:mm a").format(DateTime.now()),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ]),
        ));
  }
}
