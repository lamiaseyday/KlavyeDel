import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  //state'in oluşturulduğu bloklar.
  State<StatefulWidget> createState() {
    //Burda bir state dönmesi gerekiyor!!
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  int typedCharLength = 0;
  String lorem =
      '                       Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');

  int step = 0;
  //int score = 0;
  //en son ne zaman yazdı.
  int lastTypeAt;

  void updateLastTypedAt() {
    this.lastTypeAt = new DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt(); //yazmayı bıraktığın an 4 saniye sonra oyunda yanarsın.
    //print(value);
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        //yazdığın karakter 0. index de değilse yandın!
        step = 2;
      } else {
        typedCharLength = value.length;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      //yazılan ismin sadece 3 karakteri alınır ne kadar uzun olsa da.
      this.userName = value.substring(0, 3);
      //print(userName);
    });
  }

  //yeniden başlat oyunu
  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 0;
    });
  }

  //fonksiyon tanımlaması
  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });

    Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      //game over
      setState(() {
        if (step == 1 && now - lastTypeAt > 4000) {
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //return Text('Hello World');

    var shownWidget;

    if (step == 0)
      shownWidget = <Widget>[
        Text('oyuna hoşgeldin!!'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            autofocus: false,
            onChanged: onUserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ismin nedir klavye delikanlısı?',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('BAŞLA'),
            onPressed: userName.length == 0 ? null : onStartClick,
          ),
        )
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text('$typedCharLength'),
        Container(
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 75.0,
            pauseAfterRound: Duration(seconds: 10),
            startPadding: 0,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'typing',
            ),
          ),
        ),
      ];
    else
      shownWidget = <Widget>[
        Text('başarısız oldun, skorun: $typedCharLength'),
        RaisedButton(
          child: Text('Yeniden Dene!'),
          onPressed: resetGame,
        )
      ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Klavye Delikanlısı'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
