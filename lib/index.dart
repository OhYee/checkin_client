import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexState(),
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

  void getData(DateTime _date) async {
    date = _date;
    Map temp = await request("/get", {"date": dateToString(_date)});
    Data data = Data(
      weight: temp["weight"],
      note: temp["note"],
      money: temp["money"],
    );
    money = data.money;
    weight.text = data.weight.toString();
    note.text = data.note;
  }

  _IndexState() {
    getData(DateTime.now());
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
      setState(() {
        getData(selectedDate);
      });
    }
  }

  Widget renderWeight() {
    return Container(
      child: TextField(
        controller: weight,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "体重",
            prefixIcon: Icon(Icons.person),
            suffix: Text("kg")),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly], //只允许输入数字
        onChanged: (v) {},
      ),
    );
  }

  Widget renderNote() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("变胖的小仙女"),
      ),
      // body:
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: onDateClick,
                  icon: Icon(Icons.date_range),
                ),
                Text(
                  "当前日期: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  dateToString(date),
                  style: TextStyle(fontSize: 20),
                ),
                Visiable(child: Text(" (今日)"), show: isToday(date)),
              ],
            ),
            renderWeight(),
            renderNote(),
            RaisedButton(
              child: Text("保存当日数据"),
              onPressed: () {},
            ),
            RaisedButton(
              color: Color.fromARGB(255, 255, 40, 40),
              highlightColor: Color.fromARGB(100, 255, 255, 255),
              textColor: Color.fromARGB(255, 255, 255, 255),
              child: Wrap(
                children: <Widget>[
                  Icon(Icons.directions_run),
                  Text("打卡！"),
                ],
              ),
              onPressed: money != -1 ? null : () {},
            ),
            Visiable(
                child: Text("${dateToString(date)}打卡获得${money / 100}元"),
                show: money != -1),
          ],
        ),
      ),
    );
  }
}
