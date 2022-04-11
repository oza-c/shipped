import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shipped/assets/parcel.dart';


String _apiKey = "" //Place your EasyPost API Key here;
String basicAuth = 'Basic ' + base64Encode(utf8.encode(_apiKey));

Future<TrackingInfo> getTrackingData(String parcel) async {
  Map data = {
  'tracking_code' : parcel,
  };
  String body = json.encode(data);
    var response = await http.post(Uri.https("api.easypost.com", "/v2/trackers")
    ,headers: <String, String>{
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    },
  body: body,
  );
  TrackingInfo details = TrackingInfo.fromJson(jsonDecode(response.body));
  return details;
}