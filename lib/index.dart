import 'package:checkin/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';
import 'api.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        // body:
        body: IndexState(),
      ),
    );
  }
}

class IndexState extends StatefulWidget {
  IndexState({Key key}) : super(key: key);

  final DateTime date = DateTime.now();

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<IndexState> {
  DateTime date;
  TextEditingController weight = TextEditingController(text: "");
  TextEditingController note = TextEditingController(text: "");
  int money = -1;
  int day = 0;
  int lottery = 0;
  int total = 0;
  bool menstruation = false;

  void initInfo() async {
    InfoResponse res = await info(context, globalToken);
    setState(() {
      day = res.day;
      lottery = res.lottery;
      total = res.money;
    });
  }

  void setDataOfDate(DateTime _date) async {
    GetResponse data = await getData(
      context,
      (_date.millisecondsSinceEpoch / 1000).round(),
      globalToken,
    );

    setState(() {
      date = _date;
      money = data.money;
      weight.text = (data.weight / 100).toString();
      note.text = data.note;
      menstruation = data.menstruation;
    });
  }

  void onDateClick() async {
    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (selectedDate != null) {
      setDataOfDate(selectedDate);
    }
  }

  bool buttonDisabled() {
    return money != -1 || !isToday(date) || menstruation;
  }

  Widget renderWeight(BuildContext context) {
    return Container(
      child: TextField(
        controller: weight,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "体重",
            prefixIcon: Icon(Icons.person),
            suffix: Text("kg")),
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[0-9.]"))
        ], //只允许输入数字
        onChanged: (v) {},
      ),
    );
  }

  Widget renderNote(BuildContext context) {
    return Container(
      child: TextField(
        controller: note,
        minLines: 2,
        maxLines: 10,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: "备注",
          // border: OutlineInputBorder(),
        ),
        onChanged: (v) {},
      ),
    );
  }

  Widget renderSaveButton(BuildContext context) {
    var callback = () async {
      SetResponse res = await setData(
        context,
        (date.millisecondsSinceEpoch / 1000).round(),
        globalToken,
        (double.parse(weight.text) * 100).round(),
        note.text,
      );
      makeToast(
        context: context,
        text: res.success ? "提交成功" : "提交失败",
      );
    };
    return RaisedButton(
      child: Text("保存当日数据"),
      onPressed: callback,
    );
  }

  Widget renderCheckInButton(BuildContext context) {
    var callback = () async {
      confirm(context, "提醒", "确定要打卡？", () async {
        var res = await checkIn(
            context, (date.millisecondsSinceEpoch / 1000).round(), globalToken);
        setState(() {
          day = res.day;
          lottery = res.lottery;
          money = res.money;

          total += money;
          day += 1;
        });
      });
    };
    return RaisedButton(
      color: Color.fromARGB(255, 255, 40, 40),
      highlightColor: Color.fromARGB(100, 255, 255, 255),
      textColor: Color.fromARGB(255, 255, 255, 255),
      child: Wrap(
        children: <Widget>[
          Icon(Icons.directions_run),
          Text("打卡！"),
        ],
      ),
      onPressed: buttonDisabled() ? null : callback,
    );
  }

  Widget renderMenButton(BuildContext context) {
    var callback = () async {
      confirm(context, "提醒", "确定今天生理期？", () async {
        var res = await setMenstruationData(
          context,
          (date.millisecondsSinceEpoch / 1000).round(),
          globalToken,
        );
        if (res.success) {
          setState(() {
            menstruation = true;
          });
        }
      });
    };
    return RaisedButton(
      child: Wrap(
        children: <Widget>[
          Icon(
            menstruation
                ? Icons.sentiment_very_dissatisfied
                : Icons.airline_seat_individual_suite,
          ),
          Text("生理期不打卡"),
        ],
      ),
      onPressed: buttonDisabled() ? null : callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      setDataOfDate(DateTime.now());
      initInfo();
    }
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("已连续签到 $day 天", style: TextStyle(fontSize: 16)),
              Text("有 $lottery 张抽奖券", style: TextStyle(fontSize: 16)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("共有 ${total / 100} 元余额", style: TextStyle(fontSize: 16)),
              RaisedButton(
                child: Wrap(
                    children: <Widget>[Icon(Icons.exit_to_app), Text("登出")]),
                onPressed: () async {
                  await logout(context, globalToken);
                  globalToken = "";
                  await delValue("token");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: onDateClick,
                    icon: Icon(Icons.date_range),
                  ),
                  Text("当前日期: ", style: TextStyle(fontSize: 20)),
                  Text(dateToString(date), style: TextStyle(fontSize: 20)),
                  Visiable(child: Text(" (今日)"), show: isToday(date)),
                ],
              ),
              Visiable(
                child: Wrap(
                  children: <Widget>[
                    Icon(Icons.airline_seat_individual_suite),
                    Text("卧床休息")
                  ],
                ),
                show: menstruation,
              ),
            ],
          ),
          renderWeight(context),
          renderNote(context),
          renderSaveButton(context),
          renderCheckInButton(context),
          Visiable(
            child: Text("${dateToString(date)}打卡获得${money / 100}元"),
            show: money != -1,
          ),
          renderMenButton(context),
        ],
      ),
    );
  }
}
