import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'assets/parcel.dart';
import 'widget/refresh_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipped',
      theme: ThemeData(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(196, 226, 133, 19),
          title: const Text("Shipped - Track your Parcels"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(196, 226, 133, 19),
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: const Text(''),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: ParcelList()
            ),
    );
  }
}

class ParcelList extends StatefulWidget {
  @override
  _ParcelListState createState() => _ParcelListState();
}

class _ParcelListState extends State<ParcelList> {
  List<Shipment> data = [];
    static bool isFabVisible = true;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    data = [];
    data.add(Shipment(
        parcelname: 'Amazon',
        parcel_id: '92183912843023812',
        shippingprovider: 'DHL'));
    data.add(Shipment(
        parcelname: 'LFDY',
        parcel_id: '92183912843023812',
        shippingprovider: 'DHL'));
    data.add(Shipment(
        parcelname: 'PESO',
        parcel_id: '92183912843023812',
        shippingprovider: 'DHL'));
    data.add(Shipment(
        parcelname: 'Zalando',
        parcel_id: '92183912843023812',
        shippingprovider: 'DHL'));

    setState(() => this.data = data);
  }

  @override
  Widget build(BuildContext context) => buildList();

  Widget buildList() => data.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) =>[
          const SliverAppBar(
            floating: true,
            snap : true,
            title: Text("Add Parcel +"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(225, 226, 133, 19),
          ) 
          ], body:  LiquidPullToRefresh(
            onRefresh: loadList,
            color: const Color.fromARGB(196, 226, 133, 19),
            key: null,
            child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
               if(notification.direction == ScrollDirection.forward) {
                 if(!isFabVisible) setState(() => isFabVisible = true);
               }else if(notification.direction == ScrollDirection.reverse){
                 if(isFabVisible) setState(() => isFabVisible = false);
               }
               return true;
              },
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return buildItem(data[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ),
        ),
          floatingActionButton: isFabVisible ? const FloatingActionButton(
              onPressed: null,
              backgroundColor: Color.fromARGB(255, 226, 133, 19),
              child: Icon(Icons.add)
            )
            : null,
      );

  Widget buildItem(Shipment parcel) => Container(
      child: Stack(children: <Widget>[
        Positioned(
            top: 40,
            left: 5,
            child: Container(
                width: 100,
                height: 100,
                child: const Icon(Icons.mail, size: 70))),
        Positioned(
            top: 40,
            left: 110,
            child: Container(
                width: 250,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(parcel.parcelname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ))),
        Positioned(
            top: 70,
            left: 110,
            child: Container(
                width: 250,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(parcel.parcel_id,
                      style: const TextStyle(fontSize: 15)),
                ))),
        Positioned(
            top: 100,
            left: 110,
            child: Container(
                width: 250,
                height: 70,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Das Paket ist im Zustellzentrum angekommen",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ))),
      ]),
      decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white),
      height: 200);
}
