import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shipped/assets/getTrackingInformation.dart';
import 'package:shipped/assets/parcel.dart';

class watchParcel extends StatefulWidget {
  const watchParcel({Key? key, required this.activParcel}) : super(key: key);

  final Shipment activParcel;
  @override
  State<watchParcel> createState() => _watchParcelState();
}

class _watchParcelState extends State<watchParcel> {
  Future reloadTrackingInfo() async {
    getTrackingData(widget.activParcel.parcel_id).then((TrackingInfo result) {
      setState(() {
        widget.activParcel.tracking = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(196, 226, 133, 19),
          title: Text(widget.activParcel.parcelname),
        ),
        body: LiquidPullToRefresh(
          color: const Color.fromARGB(196, 226, 133, 19),
          onRefresh: reloadTrackingInfo,
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(8),
            itemCount: widget.activParcel.tracking.trackingDetails.length,
            itemBuilder: (context, index) {
              return buildItem(
                  widget.activParcel.tracking.trackingDetails[index]);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ));
  }

  Widget buildItem(TrackingDetail tracking) => Container(
      child: Stack(children: <Widget>[
        Positioned(
            top: 10,
            left: 5,
            child: SizedBox(
                width: 100,
                height: 100,
                child: Icon(getIconStatusFromName(tracking.status), size: 70))),
        Positioned(
            top: 20,
            left: 110,
            child: SizedBox(
                width: 250,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tracking.message,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ))),
        Positioned(
            top: 42,
            left: 110,
            child: SizedBox(
                width: 250,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      DateTime.parse(tracking.datetime).toLocal().toString(),
                      style: const TextStyle(fontSize: 15)),
                ))),
      ]),
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white),
      height: 115);
}
