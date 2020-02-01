import 'package:flutter/material.dart';
import 'package:lost_and_found_app/screens/items.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lost_and_found_app/routes/Routes.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ProgressDialog pr;
  String _state = "Locked";
  Color _lockTextColor = Colors.blueGrey;
  // List<User> _users = <User>[];
  final _pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // listenForUsers();
  }

  @override
  void dispose() {
    super.dispose();
    _pwdController.dispose();
  }

  // void listenForUsers() async {
  //   final Stream<User> stream = await getUsers();
  //   stream.listen((User user) => setState(() {
  //     _users.add(user);
  //   }));
  // }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: new Container(
          margin: EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lock, size: 70.0, color: _lockTextColor),
              Text(_state, style: TextStyle(color: _lockTextColor),),
              SizedBox(height: 20.0),
              TextField(
                textAlign: TextAlign.center,
                controller: _pwdController,
                obscureText: true,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 16.0),
                decoration: new InputDecoration(
                  hintText: 'Enter PIN',
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.blueGrey,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (txt) {
                    setState(() {
                      _state = "Locked";
                      _lockTextColor = Colors.blueGrey;
                    });
                },
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                  onPressed: () {
                    login(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.forward,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0, height: 50.0,),
                      Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
              SizedBox(height: 30.0),
            ],
          )),
    );
  }

  void login(BuildContext context) {
    if (_pwdController.text == '') {
      Alert(
          context: context,
          type: AlertType.error,
          title: "Error",
          desc: "Enter PIN and try again",
          style: AlertStyle(isCloseButton: false))
          .show();
      return;
    }

      if ('123' == _pwdController.text) {
        // Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, Routes.items);
        // Navigator.of(context)
        // .pushReplacement(
          // new MaterialPageRoute(builder: (BuildContext context) => ItemsPage(title: "Lost Items")));
      } else {
        setState(() {
          _state = "Incorrect PIN";
          _lockTextColor = Colors.red;
        });
      }
    
  }

}
