import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Welcome to Attentive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Duration timeout = Duration(seconds: 3);
  Duration ms = Duration(milliseconds: 1);
  double _time = 0;
  double _newTime = 0;
  double _timeSet = 0;
  bool _running = false;
  double currentTime = 0;
  double timeConfirm = 0;
  String displayTime = "0:00";
  IconData iconData = Icons.access_alarm;

  //PERIODIC TIMER TEST from https://stackoverflow.com/questions/54610121/flutter-countdown-timer
  Timer _timer;
  double _startTime = 0;
  int _current = 0;

   startTimer() {
     if (_running) {
       _current = _startTime.toInt();
       const oneSec = const Duration(seconds: 1);
       _timer = new Timer.periodic(oneSec,
               (Timer timer) =>
               setState(
                     () {
                   if (_current < 1) {
                     timer.cancel();
                   } else {
                     print("Timer increment to " + _current.toString());
                     _current = _current - 1;
                     displayTime = _timeFormat(_current);
                   }
                 },
               )
       );
     }
   }
  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  _beginTimer() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _running = !_running;
    });

    startTimer();
  }
  _pauseTimer(){
     _running = false;
  }
  _cancelTimer(){

  }
  String _timeFormat(int seconds){
    int minutesPlace = (seconds ~/ 60);
    int secondsPlace = (seconds - (minutesPlace * 60).toInt());
    if(secondsPlace.toString().length == 1){
      return (minutesPlace.toString() + ":0" + secondsPlace.toString());
    }else{
      return (minutesPlace.toString() + ":" + secondsPlace.toString());
    }


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'How long do you want to focus for?',
            ),
            Slider(
              activeColor: Colors.orangeAccent,
              inactiveColor: Colors.deepOrange,
              min: 0,
              max: 3600,
              onChanged: (newTime) {
                if(!_running) {
                  setState(() => _startTime = newTime);
                  _current = _startTime.toInt();
                  displayTime = _timeFormat(_current);
                }else{
                  //setState(() => _timeSet = currentTime);
                  //displayTime = _timeFormat(newTime);
                }
              },
              value: _startTime,
            ),
            FlatButton(
              onPressed: (){
                if(_running) {
                  _cancelTimer();
                }
              }
            ),
            Text(
              '$displayTime',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(!_running) {
            _beginTimer();
          }else{
            _pauseTimer();
          }
        },
        tooltip: 'Toggle timer',
        child: Icon(Icons.access_alarm),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
