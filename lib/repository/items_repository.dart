import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lost_and_found_app/main.dart';
import 'package:lost_and_found_app/models/item.dart';
  
Future<Stream<Item>> getItems() async {
 final String url = MyApp.BASE_URL+'items';

 final client = new http.Client();
 final streamedRest = await client.send(
   http.Request('get', Uri.parse(url))
 );

 return streamedRest.stream
     .transform(utf8.decoder)
     .transform(json.decoder)
     .expand((data) => (data as List))
     .map((data) => Item.fromJSON(data));
}

Future<Stream<String>> insertItem(data, filePath) async {
 final String url = MyApp.BASE_URL+'insert';
 print(url);
 final client = new http.Client();

 http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
 http.MultipartFile multipartFile =
 await http.MultipartFile.fromPath('file', filePath); //returns a Future<MultipartFile>
 request.files.add(multipartFile);
 request.fields.putIfAbsent('data', () => jsonEncode(data));
 final streamedRest = await client.send(request);

 return streamedRest.stream
     .transform(utf8.decoder);
    //  .transform(json.decoder)
    //  .map((data) => Message.fromJSON(data));
}

class PItem {
  String customerid;
  String vehicleid;
  String noofbox;
  String rate;
  String commission;
  String vchdate;

  PItem(this.customerid, this.vehicleid, this.noofbox, this.rate, this.commission, this.vchdate);

  Map<String, dynamic> toJson() =>
  {
    'customerid': this.customerid,
    'vehicleid': this.vehicleid,
    'noofbox': this.noofbox,
    'rate': this.rate,
    'commission': this.commission,
    'vchdate': this.vchdate
  }; 
}

class Message {
  String success;

  Message(Map<String, dynamic> data) {
    success = data['success'];
  }
}