import 'package:checkin/index.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: LoginState(),
      ),
    );
  }
}

class LoginState extends StatefulWidget {
  LoginState({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginState> {
  bool showPassword = false;
  TextEditingController username = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: username,
            decoration: InputDecoration(
              labelText: "账号",
              prefixIcon: Icon(Icons.people),
            ),
          ),
          TextField(
            obscureText: !showPassword,
            controller: password,
            decoration: InputDecoration(
                labelText: "密码",
                prefixIcon: Icon(Icons.lock),
                suffix: IconButton(
                  iconSize: 20,
                  icon:
                      Icon(showPassword ? Icons.lock_open : Icons.lock_outline),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                  child: Text(
                    "登录",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    Map res;
                    try {
                      res = await request(
                        "/login",
                        {"username": username.text, "password": password.text},
                      );
                    } catch (e) {
                      makeToast(context: context, text: "登录失败");
                      return;
                    }
                    if (res["token"] == "") {
                      makeToast(context: context, text: "登录失败");
                    } else {
                      setValue("token", res["token"]);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => IndexPage()));
                    }
                  })
            ],
          )
        ],
      ),
    );
  }
}
