// ignore_for_file: non_constant_identifier_names

class Shipment {
  String parcelname;
  String parcel_id;
  String shippingprovider;

  Shipment({required this.parcelname, required this.parcel_id, required this.shippingprovider});

  Shipment.fromJson(Map<String, dynamic> json)
      : parcelname = json['ParcelName'],
        parcel_id = json['ParcelId'],
        shippingprovider = json['Shippingprovider'];

  Map<String, dynamic> toJson() => {
        'ParcelName': parcelname,
        'ParcelId': parcel_id,
        'Shippingprovider': shippingprovider,
      };
}