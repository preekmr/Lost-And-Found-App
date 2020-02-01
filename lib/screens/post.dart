import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lost_and_found_app/models/item.dart';
import 'package:lost_and_found_app/repository/items_repository.dart';
import 'package:lost_and_found_app/widgets/custom_drawer.dart';
import 'package:image_picker/image_picker.dart';

import '../util.dart';

class PostItemPage extends StatefulWidget {
  static const String routeName = '/post_items';

  PostItemPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PostItemPageState createState() => _PostItemPageState();
}

class _PostItemPageState extends State<PostItemPage> {
  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _shapeController = TextEditingController();
  final _colorController = TextEditingController();
  final _locationController = TextEditingController();
  ProgressDialog pr;
  FocusNode nameFocusNode;
  File _image;
  String _date =
      '${Util.formatDM(DateTime.now().day)}/${Util.formatDM(DateTime.now().month)}/${DateTime.now().year}';

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _shapeController.dispose();
    _colorController.dispose();
    _locationController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: new Container(
          margin: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Enter Item Details",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    decoration: const InputDecoration(helperText: "Item Name"),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.body1,
                    controller: _nameController,
                    focusNode: nameFocusNode,
                  ),
                  TextField(
                    decoration: const InputDecoration(helperText: "Owner"),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.body1,
                    controller: _ownerController,
                  ),
                  TextField(
                    decoration: const InputDecoration(helperText: "Color"),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.body1,
                    controller: _colorController,
                  ),
                  TextField(
                    decoration: const InputDecoration(helperText: "Shape"),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.body1,
                    controller: _shapeController,
                  ),
                  SizedBox(height: 20.0),
                  Text("Date Found", style: Theme.of(context).textTheme.body1),
                  getDatePicker(),
                  TextField(
                    decoration: const InputDecoration(helperText: "Location"),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.body1,
                    controller: _locationController,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {_choose(true);},
                            child: Text('Image From Camera'),
                          ),
                          SizedBox(width: 10.0),
                          RaisedButton(
                            onPressed: () {_choose(false);},
                            child: Text('Image From Gallery'),
                          ),
                        ],
                      ),
                      _image == null
                          ? Text('No Image Selected')
                          : Image.file(_image)
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                      onPressed: () {
                        saveItems();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "SAVE",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)))
                ]),
          )),
    );
  }

  void saveItems() async {
    String name = _nameController.text;
    String owner = _ownerController.text;
    String shape = _shapeController.text;
    String color = _colorController.text;
    String location = _locationController.text;
    Item item = new Item(name, shape, color, owner, _date, location);
    if (name != '') {
      pr.show();
      Stream<String> stream = await insertItem(item, _image.path);
      stream.listen((String message) => setState(() {
            pr.dismiss();
            print(message);
            if (message.contains("successfully")) {
              Alert(
                  context: context,
                  title: "Done!",
                  desc: "Data saved successfully",
                  type: AlertType.success,
                  style: AlertStyle(isCloseButton: false),
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        clearData(context);
                      },
                      width: 120,
                    )
                  ]).show();
            } else {
              Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Error",
                      desc: "Error during the Save. Please try again.",
                      style: AlertStyle(isCloseButton: false))
                  .show();
            }
          }));
    } else {
      Alert(
              context: context,
              type: AlertType.error,
              title: "Error",
              desc: "Enter Name",
              style: AlertStyle(isCloseButton: false))
          .show();
    }
  }

  void clearData(context) {
    _nameController.text = '';
    _ownerController.text = '';
    _shapeController.text = '';
    _colorController.text = '';
    _locationController.text = '';
    _date = '${Util.formatDM(DateTime.now().day)}/${Util.formatDM(DateTime.now().month)}/${DateTime.now().year}';
    _image = null;
    Navigator.pop(context);
    FocusScope.of(context).requestFocus(nameFocusNode);
  }

  void _choose(isCamera) async {
    var image;
    if(isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });

  }


  Widget getDatePicker() {
    return FlatButton(
      onPressed: () {
        DatePicker.showDatePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true,
            minTime: DateTime(2000, 1, 1),
            maxTime: DateTime.now(),
            onConfirm: (date) {
              _date = '${Util.formatDM(date.day)}/${Util.formatDM(date.month)}/${date.year}';
              setState(() {});
            },
            currentTime: convertDateFromString(_date), locale: LocaleType.en);
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: Colors.black,
                      ),
                      Text(
                        " $_date",
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ),
          ],
        ),
      ),
      color: Colors.white70,
    );
  }

  DateTime convertDateFromString(String strDate) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    return dateFormat.parse(strDate);
  }
}
