import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shipped/assets/getTrackingInformation.dart';
import 'package:shipped/sites/addParcel.dart';
import 'package:shipped/sites/watchParcel.dart';
import 'assets/parcel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipped',
      theme: ThemeData(
        primaryColor: Colors.white,
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        ),
    darkTheme: ThemeData(
        primaryColor: Color.fromARGB(255, 47, 47, 47),
        primaryColorLight: Colors.black,
        brightness: Brightness.dark,
        primaryColorDark: Color.fromARGB(255, 47, 47, 47),      
        indicatorColor: Colors.white,
        canvasColor: Color.fromARGB(255, 47, 47, 47),
        cardColor: Color.fromARGB(255, 68, 68, 68)
        // next line is important!
        ),
        themeMode: ThemeMode.dark,
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
          child: ParcelList()),
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
    setState(() => data = data);
  }

  Future addDataToList(Shipment getData) async {
    data.add(getData);
    loadList();
  }

  @override
  Widget build(BuildContext context) => buildList();

  Widget buildList() => data.isEmpty
      ? Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: const Color.fromARGB(196, 226, 133, 19)),
            onPressed: (() {
              addNewEntry();
            }), child: Container(
              height: 60,
              width: 200,
              child: Row(
              children: const <Widget>[
                Icon(Icons.add),
                Text("Add your first Parcel")
              ]
            ))))            
      : Scaffold(
            body: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.forward) {
                  if (!isFabVisible) setState(() => isFabVisible = true);
                } else if (notification.direction ==
                    ScrollDirection.reverse) {
                  if (isFabVisible) setState(() => isFabVisible = false);
                }
                return true;
              },
              child: LiquidPullToRefresh(
              onRefresh: loadList,
              color: const Color.fromARGB(196, 226, 133, 19),
              key: null,
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
          floatingActionButton: isFabVisible
              ? FloatingActionButton(
                  onPressed: () async {
                    await addNewEntry();
                  },
                  backgroundColor: Color.fromARGB(255, 226, 133, 19),
                  child: const Icon(Icons.add))
              : null,
        );

  Future<void> addNewEntry() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: ((context) => const AddParcel())));
        if(result != null) addDataToList(result);
  }

  Widget buildItem(Shipment parcel) => InkWell(
    onTap:() => Navigator.push(
        context, MaterialPageRoute(builder: ((context) => watchParcel(activParcel: parcel)))),
    child: Container(
        child: Stack(children: <Widget>[
          Positioned(
              top: 40,
              left: 5,
              child: Container(
                  width: 100,
                  height: 100,
                  child: Icon(getIconStatusFromName(parcel.tracking.status), size: 70))),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(parcel.tracking.trackingDetails.first.message,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ))),
        ]),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Theme.of(context).cardColor,
            ),
        height: 200),
  );
}
