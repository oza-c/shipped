import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shipped/assets/parcel.dart';


String _apiKey = "EZAKe1e2f47481794c22a877b7159d1d770bHb4f7ivoSCgmxPPrjuSEew";
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

IconData getIconStatusFromName(String status){
    switch (status) {
      case 'pre_transit': {
          return Icons.settings_ethernet;
      } case 'in_transit': {
          return Icons.local_shipping;
      }case 'out_for_delivery': {
          return Icons.real_estate_agent;
      }case 'delivered': {
          return Icons.verified;
      }case 'return_to_sender' : {
          return Icons.keyboard_return;
      }
      default:
          return Icons.not_listed_location;
    }
}