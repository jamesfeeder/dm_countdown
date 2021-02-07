import 'package:dm_countdown/model.dart';
import 'package:dm_countdown/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeManagerProvider = ChangeNotifierProvider.autoDispose<ThemeManager>((ref) => ThemeManager());

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    ThemeManager _themeProvider = watch(themeManagerProvider);
    _themeProvider.loadDefault();
    return MaterialApp(
      title: 'DM7 Countdown',
      themeMode: _themeProvider.theme,
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        scaffoldBackgroundColor: Colors.blueGrey[100],
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.quicksandTextTheme()
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.blueGrey[900],
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.quicksandTextTheme().apply(bodyColor: Colors.white)
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
    Event(name: "Project in DM 1 : Final Presentation", time: DateTime(2021, 3, 16, 8, 30)),
    Event(name: "Internship : Start", time: DateTime(2021, 4, 1)),
    Event(name: "Internship : End", time: DateTime(2021, 6, 1)),
    Event(name: "Cooperative Education : Start", time: DateTime(2021, 6, 21)),
    Event(name: "Cooperative Education : End", time: DateTime(2021, 10, 9)),
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width, 
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : Colors.grey[800],
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 8,
                focal: Alignment.topLeft,
                colors: Theme.of(context).brightness == Brightness.light 
                ? [
                    Colors.blueGrey[50],
                    Colors.blueGrey[400]
                  ]
                : [
                    Colors.blueGrey[800],
                    Colors.blueGrey[900]
                  ]
              ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Light Theme"),
                      Consumer(
                        builder: (context, watch, child) {
                          ThemeManager _themeProvider = watch(themeManagerProvider);
                          return Switch(
                            value: Theme.of(context).brightness == Brightness.dark,
                            onChanged: (value) => _themeProvider.isDark = value
                          );
                        }
                      ),
                      Text("Dark Theme"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          clockCard(context, eventDiff, day, hrs, min, sec),
        ],
      ),
    );
  }

  Widget clockCard(BuildContext context, Duration eventDiff, String day, String hrs, String min, String sec) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : Colors.grey[800],
          border: Border.all(width: 1, color: Colors.white12),
          borderRadius: BorderRadius.circular(16),
          boxShadow: Theme.of(context).brightness == Brightness.light 
          ? [
              BoxShadow(color: Colors.blueGrey[600], offset: Offset(16,16), blurRadius: 48, spreadRadius: -8),
              BoxShadow(color: Colors.white, offset: Offset(-16,-16), blurRadius: 48, spreadRadius: 8),
            ]
          : [
              BoxShadow(color: Colors.black54, offset: Offset(16,16), blurRadius: 48, spreadRadius: 8),
              BoxShadow(color: Colors.blueGrey[700], offset: Offset(-16,-16), blurRadius: 48, spreadRadius: -8),
            ],
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 8,
            focal: Alignment.topLeft,
            colors: Theme.of(context).brightness == Brightness.light 
            ? [
                Colors.white,
                Colors.blueGrey[50]
              ]
            : [
                Colors.blueGrey[800],
                Colors.blueGrey[900]
              ]
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${_currentEvent.name}", style: TextStyle(fontSize: 28)),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (eventDiff.inDays.abs() >= 1) SizedBox(
                        width: eventDiff.isNegative ? 108 : 84,
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
                        width: 84,
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
                        width: 84,
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
                        width: 84,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("$sec", style: TextStyle(fontSize: 56))
                        )
                      ),
                    ],
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
