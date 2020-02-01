import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lost_and_found_app/models/item.dart';
import 'package:lost_and_found_app/repository/items_repository.dart';
import 'package:lost_and_found_app/widgets/custom_drawer.dart';

import '../main.dart';

class ItemsPage extends StatefulWidget {
  static const String routeName = '/items';

  ItemsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List<Item> _items = <Item>[];
  ProgressDialog pr;

  void listenForItems() async {
    final Stream<Item> stream = await getItems();
    stream.listen((Item item) => setState(() {
          _items.add(item);
        }));
  }

  @override
  void initState() {
    super.initState();
    listenForItems();
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
          margin: EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: getItemsLayout()),
          )),
    );
  }

  List<Widget> getItemsLayout() {
    List<Widget> widgets = <Widget>[];
    widgets.add(SizedBox(height: 10.0));
    for (Item item in _items) {
      widgets.add(Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.white,
        elevation: 6.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              getTextKeyValue('Name', item.name),
                              getTextKeyValue('Owner', item.owner),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              getTextKeyValue('Shape', item.shape),
                              getTextKeyValue('Color', item.color),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              getTextKeyValue('Found on', item.date_found),
                              getTextKeyValue('Location', item.location_found),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 100.0,
                          child: Image.network(
                              MyApp.BASE_URL+'uploads/'+item.file_name,
                              height: 90,
                              fit:BoxFit.cover
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
      widgets.add(SizedBox(height: 10.0));
    }
    return widgets;
  }

  Widget getTextKeyValue(key, value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(key, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
          Text(value, overflow: TextOverflow.ellipsis, style:
            TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          SizedBox(height: 3.0)
        ],
      ),
    );
  }
}
