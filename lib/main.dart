import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder>{
        '/emperor': (BuildContext context) => new EmperorPage(),
        '/slave': (BuildContext context) => new SlavePage(),
        '/result': (BuildContext context) => new ResultPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: Center(
        child: TextButton(
          child: Text(
            "Start",
            style: TextStyle(
              fontSize: 46,
            ),
          ),
          onPressed: () {
            // （1） 指定した画面に遷移する
            Navigator.push(
                context,
                MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => EmperorPage()));
          },
        ),
      ),
    );
  }
}

var emperor = ['市民', '市民', '市民', '市民', '皇帝'];
int flg = 0;
var re = "hoge";

class EmperorPage extends StatelessWidget {
  final double defalut_width = 30;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("皇帝の選択")),
        body: Center(
          child: Row(
            // 中央寄せ
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final emperor_ in emperor)
                ElevatedButton(
                  onPressed: () {
                    if (emperor_ == '皇帝') {
                      emperor.remove("皇帝");
                    } else {
                      emperor.remove("市民");
                    }
                    Navigator.of(context)
                        .pushNamed("/slave", arguments: emperor_);
                  },
                  child: Text(
                    emperor_,
                    style: TextStyle(
                      fontSize: 46,
                    ),
                  ),
                ),
              SizedBox(
                width: defalut_width,
                height: 30,
              ),
            ],
          ),
        ));
  }
}

var slave = ['市民', '市民', '市民', '市民', '奴隷'];

class SlavePage extends StatelessWidget {
  final double defalut_width = 30;
  var select_card = "sample";
  Object? args;
  @override
  Widget build(BuildContext context) {
    if (args == null) {
      args = ModalRoute.of(context)!.settings.arguments;
      select_card = args as String; //Object型なので型を指定する
    }
    return Scaffold(
        appBar: AppBar(title: Text("奴隷の選択")),
        body: Center(
          child: Row(
            // 中央寄せ
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final slave_ in slave)
                ElevatedButton(
                  onPressed: () {
                    if (slave_ == '奴隷') {
                      slave.remove("奴隷");
                    } else {
                      slave.remove("市民");
                    }
                    // ここでバトルするぜ！！
                    battle(emperor_: select_card, slave_: slave_, flg: flg);
                    //残タスク -> バトル結果表示画面に遷移！
                    Navigator.of(context).pushNamed("/result", arguments: re);
                  },
                  child: Text(
                    slave_,
                    style: TextStyle(
                      fontSize: 46,
                    ),
                  ),
                ),
              // 少しずつ値を変えたいけど、やりかた分らん。
              SizedBox(
                width: defalut_width,
                height: 30,
              ),
            ],
          ),
        ));
  }
}

// flg = 0 -> 続行
// flg = 1 -> 皇帝の勝ち
// flg = 2 -> 奴隷の勝ち

String battle({emperor_, slave_, flg}) {
  if (emperor_ == '皇帝') {
    if (slave_ == '奴隷') {
      flg = 2;
      re = "奴隷の勝ち！！\nHOMEに戻って再読み込みしてください。";
    } else {
      flg = 1;
      re = "皇帝の勝ち\nHOMEに戻って再読み込みしてください。";
    }
  } else {
    if (slave_ == '奴隷') {
      flg = 1;
      re = "皇帝の勝ち！！\nHOMEに戻って再読み込みしてください。";
    } else {
      flg = 0;
      re = "続行ボタンをおしてください。";
    }
  }
  return re;
}

class ResultPage extends StatelessWidget {
  Object? args;
  String result_ = "hoge";
  @override
  Widget build(BuildContext context) {
    if (args == null) {
      args = ModalRoute.of(context)!.settings.arguments;
      result_ = args as String; //Object型なので型を指定する
    }
    return Scaffold(
        appBar: AppBar(title: Text("結果")),
        body: Center(
          child: Column(
            // 中央寄せ
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result_,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/emperor");
                },
                child: Text(
                  '続行する',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 10, height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(
                  'HOMEに戻る',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 10, height: 10),
            ],
          ),
        ));
  }
}
