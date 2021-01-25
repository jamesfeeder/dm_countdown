import 'package:dm_countdown/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DM Countdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.alataTextTheme()
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Event> _events = [
    Event(name: "Project in DM 1 : 1st Presentation", time: DateTime(2020, 12, 21, 8, 30)),
    Event(name: "Happy New Year 2021", time: DateTime(2021)),
    Event(name: "Project in DM 1 : 2nd Presentation", time: DateTime(2021, 1, 25, 8, 30)),
    Event(name: "Project in DM 1 : Final Presentation", time: DateTime(2021, 3, 16, 8, 30))
  ];

  Event _currentEvent;

  @override
  void initState() {
    updateState();
    super.initState();
  }

  Future<void> updateState() async {
    _currentEvent = _events.firstWhere((element) => element.time.isAfter(DateTime.now()), orElse: () => _events.last);
    return Future.delayed(Duration(milliseconds: 1000),
    () {
        setState(() {
          updateState();
        });
      }
    );
  }

  String formatNumber(int value) {
    if (value < 10 && value >= 0) {
      return "0$value";
    } else {
      return "$value";
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration eventDiff = _currentEvent.time.difference(DateTime.now());
    var day = formatNumber(eventDiff.inDays);
    var hrs = formatNumber((eventDiff.inHours - (eventDiff.inDays*24)).abs());
    var min = formatNumber((eventDiff.inMinutes - (eventDiff.inHours*60)).abs());
    var sec = formatNumber((eventDiff.inSeconds - (eventDiff.inMinutes*60)).abs());
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${_currentEvent.name}", style: TextStyle(fontSize: 28)),
                  SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (eventDiff.inDays.abs() >= 1) SizedBox(
                          width: eventDiff.isNegative ? 108 : 80,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("$day", style: TextStyle(fontSize: 56))
                          )
                        ),
                        if (eventDiff.inDays.abs() >= 1) SizedBox(
                          width: eventDiff.inDays.abs() > 1 ? 138 : 108,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(eventDiff.inDays.abs() > 1 ? "Days" : "Day", style: TextStyle(fontSize: 56))
                          )
                        ),
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("$hrs", style: TextStyle(fontSize: 56))
                          )
                        ),
                        SizedBox(
                          width: 24,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(":", style: TextStyle(fontSize: 56))
                          )
                        ),
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("$min", style: TextStyle(fontSize: 56))
                          )
                        ),
                        SizedBox(
                          width: 24,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(":", style: TextStyle(fontSize: 56))
                          )
                        ),
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("$sec", style: TextStyle(fontSize: 56))
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
