// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';

class Shipment {
  String parcelname;
  String parcel_id;
  String shippingprovider;
  TrackingInfo tracking;

  Shipment(
      {required this.parcelname,
      required this.parcel_id,
      required this.shippingprovider, required this.tracking});

  Shipment.fromJson(Map<String, dynamic> json)
      : parcelname = json['ParcelName'],
        parcel_id = json['ParcelId'],
        shippingprovider = json['Shippingprovider'],
        tracking = json['Tracking'];

  Map<String, dynamic> toJson() => {
        'ParcelName': parcelname,
        'ParcelId': parcel_id,
        'Shippingprovider': shippingprovider,
        'Tracking': tracking,
      };
}

class TrackingInfo {
  TrackingInfo({
    required this.status,
    required this.weight,
    required this.estDeliveryDate,
    required this.trackingDetails,
  });

  late final String status;
  final double weight;
  final String estDeliveryDate;
  final List<TrackingDetail> trackingDetails;

  factory TrackingInfo.fromJson(Map<String, dynamic> json) {
    var list = json['tracking_details'] as List;
    List<TrackingDetail> trackingsList =
        list.map((i) => TrackingDetail.fromJson(i)).toList();

    return TrackingInfo(
        status: json['status'],
        weight: json['weight'],
        estDeliveryDate: json['est_delivery_date'],
        trackingDetails: new List.from(trackingsList.reversed));
  }
}

class TrackingDetail {
  TrackingDetail({
    required this.status,
    required this.datetime,
    required this.message
  });
  final String status;
  final String message;
  final String datetime;

  factory TrackingDetail.fromJson(Map<String, dynamic> parsedJson) {
    return TrackingDetail(
      status: parsedJson['status'],
      message: parsedJson['message'],
      datetime: parsedJson['datetime'],
    );
  }
}
